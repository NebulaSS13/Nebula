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

/datum/mob_controller/New(var/mob/living/target_body)
	body = target_body
	if(expected_type && !istype(body, expected_type))
		PRINT_STACK_TRACE("AI datum [type] received a body ([body ? body.type : "NULL"]) of unexpected type ([expected_type]).")
	START_PROCESSING(SSmob_ai, src)

/datum/mob_controller/Destroy()
	LAZYCLEARLIST(_friends)
	LAZYCLEARLIST(_enemies)
	if(is_processing)
		STOP_PROCESSING(SSmob_ai, src)
	if(body)
		if(body.ai == src)
			body.ai = null
		body = null
	. = ..()

/datum/mob_controller/proc/get_automove_target(datum/automove_metadata/metadata)
	return null

/datum/mob_controller/proc/can_do_automated_move(variant_move_delay)
	return body && !body.client

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


/datum/mob_controller/proc/get_activity()
	return current_activity

/datum/mob_controller/proc/set_activity(new_activity)
	if(current_activity != new_activity)
		current_activity = new_activity
		return TRUE
	return FALSE

// The mob will periodically sit up or step 1 tile in a random direction.
/datum/mob_controller/proc/try_wander()
	//Movement
	if(body.current_posture?.prone)
		if(!body.incapacitated())
			body.set_posture(/decl/posture/standing)
	else if(!stop_wander && !body.buckled_mob && do_wander && !body.anchored)
		if(isturf(body.loc) && !body.current_posture?.prone)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
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

/datum/mob_controller/proc/get_target()
	return null

/datum/mob_controller/proc/set_target(atom/new_target)
	return

/datum/mob_controller/proc/find_target()
	return

/datum/mob_controller/proc/valid_target(var/atom/A)
	return

/datum/mob_controller/proc/move_to_target(var/move_only = FALSE)
	return

/datum/mob_controller/proc/stop_wandering()
	stop_wander = TRUE

/datum/mob_controller/proc/resume_wandering()
	stop_wander = FALSE

/datum/mob_controller/proc/set_stance(new_stance)
	if(stance != new_stance)
		stance = new_stance
		return TRUE
	return FALSE

/datum/mob_controller/proc/get_stance()
	return stance

/datum/mob_controller/proc/list_targets(var/dist = 7)
	return

/datum/mob_controller/proc/open_fire()
	return

/datum/mob_controller/proc/startle()
	if(QDELETED(body) || body.stat != UNCONSCIOUS)
		return
	body.set_stat(CONSCIOUS)
	if(body.current_posture?.prone)
		body.set_posture(/decl/posture/standing)

/datum/mob_controller/proc/retaliate(atom/source)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(body) || body.stat == DEAD)
		return FALSE
	startle()
	if(isliving(source))
		remove_friend(source)
	return TRUE

/datum/mob_controller/proc/destroy_surroundings()
	return

/datum/mob_controller/proc/lose_target()
	return

/datum/mob_controller/proc/lost_target()
	return

/datum/mob_controller/proc/handle_death(gibbed)
	return

/datum/mob_controller/proc/pacify(mob/user)
	lose_target()
	add_friend(user)

// General-purpose memorise proc, used by /commanded
/datum/mob_controller/proc/memorise(mob/speaker, message)
	return

// General-purpose memory checking proc, used by /faithful_hound
/datum/mob_controller/proc/check_memory(mob/speaker, message)
	return FALSE

// Enemy tracking - used on /aggressive
/datum/mob_controller/proc/get_enemies()
	return _enemies

/datum/mob_controller/proc/add_enemy(mob/enemy)
	if(istype(enemy))
		LAZYDISTINCTADD(_enemies, weakref(enemy))

/datum/mob_controller/proc/add_enemies(list/enemies)
	for(var/thing in enemies)
		if(ismob(thing))
			add_friend(thing)
		else if(istype(thing, /weakref))
			LAZYDISTINCTADD(_enemies, thing)

/datum/mob_controller/proc/remove_enemy(mob/enemy)
	LAZYREMOVE(_enemies, weakref(enemy))

/datum/mob_controller/proc/set_enemies(list/new_enemies)
	_enemies = new_enemies

/datum/mob_controller/proc/is_enemy(mob/enemy)
	. = istype(enemy) && LAZYLEN(_enemies) && (weakref(enemy) in _enemies)

/datum/mob_controller/proc/clear_enemies()
	LAZYCLEARLIST(_enemies)

// Friend tracking - used on /aggressive.
/datum/mob_controller/proc/get_friends()
	return _friends

/datum/mob_controller/proc/add_friend(mob/friend)
	if(istype(friend))
		LAZYDISTINCTADD(_friends, weakref(friend))
		return TRUE
	return FALSE

/datum/mob_controller/proc/remove_friend(mob/friend)
	LAZYREMOVE(_friends, weakref(friend))

/datum/mob_controller/proc/set_friends(list/new_friends)
	_friends = new_friends

/datum/mob_controller/proc/is_friend(mob/friend)
	. = istype(friend) && LAZYLEN(_friends) && (weakref(friend) in _friends)
