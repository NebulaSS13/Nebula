#define SSRC_NOT_QUEUED 0
#define SSRC_PENDING_QUEUE 1
#define SSRC_QUEUED 2
#define SSRC_EXPENDED 3

// Reverse map of above for debug messages.
var/global/list/dbg_ssrc_rev = list(
	"SSRC_NOT_QUEUED",
	"SSRC_PENDING_QUEUE",
	"SSRC_QUEUED",
	"SSRC_EXPENDED"
)

/**
 * # Runechat Subsystem
 *
 * Maintains a timer-like system to handle destruction of runechat messages. Much of this code is modeled
 * after or adapted from the timer subsystem. Made by Bobbahbrown of /tg/station13
 *
 * AA Note:
 * One of the primary reasons for this is because each chatmessage has a timer attached to it, which is extra load on the GC
 * At 150 population, the GC literally cannot keep up with processing 368,000 runechats and 368,000 extra timers in a 1 hour 30 minute round
 * This also makes performance profiling a lot easier.
 *
 */

SUBSYSTEM_DEF(runechat)
	name = "Runechat"
	wait = 1 	// ds
	flags = SS_KEEP_TIMING | SS_NO_INIT
	priority = SS_PRIORITY_RUNECHAT

	/// Events that have been scheduled and sorted -- do not modify this outside of the subsystem.
	var/list/events = list()
	/// Events pending scheduling -- shove new events in here.
	var/list/pending_events = list()
	var/queue_index = 1
	var/updating_queue = FALSE

/datum/controller/subsystem/runechat/stat_entry()
	..("Q:[events.len] P:[pending_events.len]")

/datum/controller/subsystem/runechat/Recover()
	events = SSrunechat.events
	pending_events = SSrunechat.pending_events
	if (SSrunechat.queue_index > 1)
		// flush nulls
		events -= new /list(events.len)
		pending_events -= new /list(pending_events.len)
		queue_index = 1

/datum/controller/subsystem/runechat/fire(resumed = FALSE)
	if (!events.len && !pending_events.len)
		return

	if (!resumed && pending_events.len)
		updating_queue = TRUE
		ASSERT(queue_index == 1)

	// - Queue pending events if we're not mid-tick -

	if (updating_queue)
		while (queue_index <= pending_events.len)
			var/datum/runechat/chat = pending_events[queue_index]
			pending_events[queue_index] = null
			queue_index += 1

			BINARY_INSERT(chat, events, /datum/runechat, chat, eol_complete, COMPARE_KEY)

			chat.queue_state = SSRC_QUEUED

			if (MC_TICK_CHECK)
				return

		if (queue_index > 1)
			pending_events.Cut(1, queue_index)
			queue_index = 1

		updating_queue = FALSE

	// - Process queued events -

	while (queue_index <= events.len)
		var/datum/runechat/chat = events[queue_index]
		queue_index += 1

		if (!chat || chat.queue_state == SSRC_EXPENDED)	// rescheduled or hard deleted
			continue

		// If the next most recent event is in the future, nothing after it will be ready to run either.
		// Requeued events will still be in the list but should just be ignored.
		if (chat.eol_complete > world.time)
			break

		chat.end_of_life()
		chat.queue_state = SSRC_EXPENDED
		events[queue_index - 1] = null

		if (MC_TICK_CHECK)
			return

	if (queue_index > 1)
		events.Cut(1, queue_index)
		queue_index = 1

/datum/controller/subsystem/runechat/proc/reschedule(datum/runechat/chat, reschedule_to)
	switch (chat.queue_state)
		if (SSRC_QUEUED)
			var/index = events.Find(chat)
			ASSERT(index != 0)
			events[index] = null
			chat.eol_complete = reschedule_to
			pending_events += chat

		if (SSRC_PENDING_QUEUE)
			// Not actually scheduled yet, ez.
			chat.eol_complete = reschedule_to

		else
			CRASH("Invalid state: [global.dbg_ssrc_rev[chat.queue_state]], expected PENDING_QUEUE or QUEUED.")

/datum/runechat
	var/queue_state = SSRC_NOT_QUEUED

/datum/runechat/proc/enter_subsystem(reschedule_to)
	if (reschedule_to)
		ASSERT(queue_state != SSRC_NOT_QUEUED)
		SSrunechat.reschedule(src, reschedule_to)
		return

	ASSERT(queue_state == SSRC_NOT_QUEUED)
	SSrunechat.pending_events += src
	queue_state = SSRC_PENDING_QUEUE

/datum/runechat/proc/leave_subsystem()
	// Just let it fall out of the queue, if this subsystem is taking more than 2 minutes to complete a run you have larger problems than a single harddel.
	queue_state = SSRC_EXPENDED

#undef SSRC_NOT_QUEUED
#undef SSRC_PENDING_QUEUE
#undef SSRC_QUEUED
#undef SSRC_EXPENDED
