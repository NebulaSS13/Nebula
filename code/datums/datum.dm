/datum
	var/tmp/gc_destroyed //Time when this object was destroyed.
	var/tmp/is_processing = FALSE
	var/list/active_timers  //for SStimer

#ifdef TESTING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
#endif

// The following vars cannot be edited by anyone
/datum/VV_static()
	return UNLINT(..()) + list("gc_destroyed", "is_processing")

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	SHOULD_CALL_PARENT(TRUE)
	tag = null
	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.

	if(istype(SSnano))
		SSnano.close_uis(src)

	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent && !(timer.flags & TIMER_LOOP))
			continue
		qdel(timer)

	if(extensions)
		for(var/expansion_key in extensions)
			var/list/extension = extensions[expansion_key]
			if(islist(extension))
				extension.Cut()
			else
				qdel(extension)
		extensions = null

	if(istype(events_repository)) // Typecheck is needed (rather than nullchecking) due to oddness with new() ordering during world creation.
		events_repository.raise_event(/decl/observ/destroyed, src)

	if (!isturf(src))	// Not great, but the 'correct' way to do it would add overhead for little benefit.
		cleanup_events(src)

	var/list/machines = global.state_machines["\ref[src]"]
	if(length(machines))
		for(var/base_type in machines)
			qdel(machines[base_type])
		global.state_machines -= "\ref[src]"

	return QDEL_HINT_QUEUE

/datum/proc/Process()
	SHOULD_NOT_SLEEP(TRUE)
	return PROCESS_KILL

// This is more or less a helper to avoid needing to cast extension holders to atom.
// Previously called get() and get_holder_of_type().
// See /atom/get_recursive_loc_of_type() for actual logic.
/datum/proc/get_recursive_loc_of_type(var/loc_type)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("get_recursive_loc_of_type() called on datum type [type] - this proc should only be called on /atom.")
