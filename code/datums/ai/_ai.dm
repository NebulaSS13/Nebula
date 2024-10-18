/* Notes/thoughts/assumptions, June 2024:
 *
 * 1. AI should not implement any bespoke mob logic within the proc it uses
 *    to trigger or respond to game events. It should share entrypoints with
 *    action performed by players and should respect the same intents, etc.
 *    that players have to manage, through the same procs players use. This
 *    should mean that players can be slotted into the pilot seat of any mob,
 *    suspending AI behavior, and should then be able to freely use any of the
 *    behaviors the AI can use with that mob (special attacks, burrowing, so on).
 *
 * 2. Where possible, attacks/effects/etc should use existing systems (see the
 *    natural attack item simple_animal uses for example) for a similar reason to
 *    the above. Ideally this should also extend to ranged attacks in the future.
 *
 */

/datum/mob_controller
	/// The parent mob we control.
	var/mob/living/body
	/// Type of mob this AI applies to.
	var/expected_type = /mob/living

	// WANDERING
	/// How many life ticks should pass before we wander?
	var/turns_per_wander = 2
	/// How many life ticks have passed since our last wander?
	var/turns_since_wander = 0
	/// Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/stop_wander = FALSE
	/// Does the mob wander around when idle?
	var/do_wander = TRUE
	/// When set to 1 this stops the animal from moving when someone is grabbing it.
	var/stop_wander_when_pulled = TRUE

	// SPEAKING/EMOTING
	/// A prob chance of speaking.
	var/speak_chance = 0
	/// Strings shown when this mob speaks and is not understood.
	var/list/emote_speech
	/// Hearable emotes that this mob can randomly perform.
	var/list/emote_hear
	/// Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	var/list/emote_see
	/// What directions can we wander in? Uses global.cardinal if unset.
	var/list/wander_directions

	/// Can we automatically escape from buckling?
	var/can_escape_buckles = FALSE

	/// What is our current general attitude and demeanor?
	var/stance = STANCE_NONE
	/// What are we busy with currently?
	var/current_activity = AI_ACTIVITY_IDLE

	/// Who are we friends with? Lazylist of weakrefs.
	var/list/_friends
	/// Who are our sworn enemies? Lazylist of weakrefs.
	var/list/_enemies

	/// Aggressive AI var; defined here for reference without casting.
	var/try_destroy_surroundings = FALSE

	/// Reference to the atom we are targetting.
	var/weakref/target_ref

	/// Current path for A* pathfinding.
	var/list/executing_path
	/// A counter for times we have failed to progress along our path.
	var/path_frustration = 0
	/// A list of any obstacles we should path around in future.
	var/list/path_obstacles = null

	/// Radius of target scan area when looking for valid targets. Set to 0 to disable target scanning.
	var/target_scan_distance = 0
	/// Time tracker for next target scan.
	var/next_target_scan_time
	/// How long minimum between scans.
	var/target_scan_delay = 1 SECOND

/datum/mob_controller/New(var/mob/living/target_body)
	body = target_body
	if(expected_type && !istype(body, expected_type))
		PRINT_STACK_TRACE("AI datum [type] received a body ([body ? body.type : "NULL"]) of unexpected type ([expected_type]).")
	START_PROCESSING(SSmob_ai, src)

/datum/mob_controller/Destroy()
	LAZYCLEARLIST(_friends)
	LAZYCLEARLIST(_enemies)
	set_target(null)
	if(is_processing)
		STOP_PROCESSING(SSmob_ai, src)
	if(body)
		if(body.ai == src)
			body.ai = null
		body = null
	. = ..()

/datum/mob_controller/proc/can_process()
	if(!body || !body.loc || ((body.client || body.mind) && !(body.status_flags & ENABLE_AI)))
		return FALSE
	if(body.stat == DEAD)
		return FALSE
	return TRUE

/datum/mob_controller/Process()
	if(can_process())
		do_process()

/datum/mob_controller/proc/pause()
	if(is_processing)
		STOP_PROCESSING(SSmob_ai, src)
		return TRUE
	return FALSE

/datum/mob_controller/proc/resume()
	if(!is_processing)
		START_PROCESSING(SSmob_ai, src)
		return TRUE
	return FALSE

// This is the place to actually do work in the AI.
/datum/mob_controller/proc/do_process()
	SHOULD_CALL_PARENT(TRUE)
	if(!body || QDELETED(body))
		return FALSE
	if(get_stance() == STANCE_BUSY)
		return FALSE
	if(!body.stat)
		try_unbuckle()
		try_wander()
		try_bark()
	return TRUE

// The mob will try to unbuckle itself from nets, beds, chairs, etc.
/datum/mob_controller/proc/try_unbuckle()
	if(body.buckled && can_escape_buckles)
		if(istype(body.buckled, /obj/effect/energy_net))
			var/obj/effect/energy_net/Net = body.buckled
			Net.escape_net(body)
		else if(prob(25))
			body.buckled.unbuckle_mob(body)
		else if(prob(25))
			body.visible_message(SPAN_WARNING("\The [body] struggles against \the [body.buckled]!"))

// The mob will periodically sit up or step 1 tile in a random direction.
/datum/mob_controller/proc/try_wander()
	//Movement
	if(stop_wander || body.buckled_mob || !do_wander || body.anchored)
		return
	if(body.current_posture?.prone)
		if(!body.incapacitated())
			body.set_posture(/decl/posture/standing)
	else if(isturf(body.loc))		//This is so it only moves if it's not inside a closet, gentics machine, etc.
		turns_since_wander++
		if(turns_since_wander >= turns_per_wander && (!(stop_wander_when_pulled) || !LAZYLEN(body.grabbed_by))) //Some animals don't move when pulled
			var/direction = pick(wander_directions || global.cardinal)
			var/turf/move_to = get_step(body.loc, direction)
			if(body.turf_is_safe(move_to))
				body.SelfMove(direction)
				turns_since_wander = 0

// The mob will periodically make a noise or perform an emote.
/datum/mob_controller/proc/try_bark()
	//Speaking
	if(prob(speak_chance))
		var/action = pick(
			LAZYLEN(emote_speech); "emote_speech",
			LAZYLEN(emote_hear);   "emote_hear",
			LAZYLEN(emote_see);    "emote_see"
		)
		var/do_emote
		var/emote_type = VISIBLE_MESSAGE
		switch(action)
			if("emote_speech")
				if(length(emote_speech))
					body.say(pick(emote_speech))
			if("emote_hear")
				do_emote = SAFEPICK(emote_hear)
				emote_type = AUDIBLE_MESSAGE
			if("emote_see")
				do_emote = SAFEPICK(emote_see)

		if(istext(do_emote))
			body.custom_emote(emote_type, "[do_emote].")
		else if(ispath(do_emote, /decl/emote))
			body.emote(do_emote)

/datum/mob_controller/proc/destroy_surroundings()
	return

/datum/mob_controller/proc/handle_death(gibbed)
	return

/// General-purpose scooping reaction proc, used by /passive.
/// Returns TRUE if the scoop should proceed, FALSE if it should be canceled.
/datum/mob_controller/proc/scooped_by(mob/initiator)
	return TRUE

// By default, randomize the target area a bit to make armor/combat
// a bit more dynamic (and avoid constant organ damage to the chest)
/datum/mob_controller/proc/update_target_zone()
	if(body)
		return body.set_target_zone(ran_zone())
	return FALSE
