/* Notes/thoughts/assumptions, June 2024:
 *
 * 1. AI should not implement any bespoke mob logic within the proc it uses
 *    to trigger or respond to game events. It should share entrypoints with
 *    actions performed by players and should respect the same intents, etc.
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
	/// Various behavioral flags.
	var/ai_flags = AI_FLAG_NO_PULLED_WANDER | AI_FLAG_WANDERS

/datum/mob_controller/New(var/mob/living/target_body)
	stance = RESOLVE_TO_DECL(stance) || GET_DECL(/decl/mob_controller_stance/idle)
	body = target_body
	if(expected_type && !istype(body, expected_type))
		PRINT_STACK_TRACE("AI datum [type] received a body ([body ? body.type : "NULL"]) of unexpected type ([expected_type]).")
	START_PROCESSING(SSmob_ai, src)
	if(friendly_to_role)
		friendly_to_role = RESOLVE_TO_DECL(friendly_to_role)
	if(length(known_commands))
		for(var/command in known_commands)
			known_commands -= command
			known_commands |= RESOLVE_TO_DECL(command)
		known_commands = sortTim(known_commands, /proc/cmp_decl_sort_value_asc, FALSE)
	..()

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
	return ..()

/datum/mob_controller/proc/can_process()
	if(!body || !body.loc)
		return FALSE
	if((body.client || body.mind) && !(body.status_flags & ENABLE_AI))
		return FALSE
	if(body.stat != CONSCIOUS)
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

	// Do some sanity checks.
	if(is_busy() || QDELETED(body) || QDELETED(src) || !istype(stance))
		return FALSE

	// If we are contained, don't move.
	if(!isturf(body.loc))
		body.stop_automove()
		return FALSE

	// Handle our commands in general.
	if(length(known_commands))

		// Process any pending commands.
		if(length(command_buffer))
			for(var/list/command_strings as anything in command_buffer)
				var/mob/speaker   = command_strings[1]
				var/message       = command_strings[2]
				var/filtered_name = lowertext(html_decode(body.name))
				//in case somebody wants to command 8 bears at once.
				if(!dd_hasprefix(message, filtered_name) && !dd_hasprefix(message, "everyone") && !dd_hasprefix(message, "everybody"))
					continue
				var/substring = copytext(message, length(filtered_name)+1) //get rid of the name.
				for(var/decl/mob_command/command in known_commands)
					if(command.receive_command(body, speaker, substring, src))
						if(current_command != command)
							current_command.end_command(src)
						command.execute_command(body, speaker, substring, src)
						if(command.keep_processing)
							current_command = command
						else
							current_command = null
						break
			command_buffer = null

		// Handle any commands
		if(current_command?.do_process(body, src, known_commands[current_command]))
			return FALSE

	// Handle our general stance behavior.
	stance.on_body_life(body, src)

	// Recheck in case we walked into lava or something during wandering.
	return !is_busy() && !QDELETED(body) && !QDELETED(src)

/datum/mob_controller/proc/destroy_surroundings(atom/target)

	// If we're not hunting something, don't destroy stuff.
	if(!istype(target) || !body.can_act() || !(ai_flags & AI_FLAG_DESTROYER))
		return

	// Not breaking stuff, or already adjacent to a target.
	if(!prob(break_stuff_probability) || body.Adjacent(target))
		return

	// Try to get our next step towards the target.
	body.face_atom(target)
	var/turf/targ = get_step_towards(body, target)
	if(!targ)
		return

	// Attack anything on the target turf.
	var/obj/effect/shield/S = locate(/obj/effect/shield) in targ
	if(S && S.gen && S.gen.check_flag(MODEFLAG_NONHUMANS))
		body.set_intent(I_FLAG_HARM)
		body.ClickOn(S)
		return

	// Hostile mobs will bash through these in order with their natural weapon
	// Note that airlocks and blast doors are handled separately below.
	// TODO: mobs should destroy powered/unforceable doors before trying to pry them.
	var/static/list/valid_obstacles_by_priority = list(
		/obj/structure/window,
		/obj/structure/closet,
		/obj/machinery/door/window,
		/obj/structure/table,
		/obj/structure/grille,
		/obj/structure/barricade,
		/obj/structure/wall_frame,
		/obj/structure/railing
	)

	for(var/type in valid_obstacles_by_priority)
		var/obj/obstacle = locate(type) in targ
		if(obstacle)
			body.set_intent(I_FLAG_HARM)
			body.ClickOn(obstacle)
			return

	if(body.can_pry_door())
		for(var/obj/machinery/door/obstacle in targ)
			if(obstacle.density)
				if(!obstacle.can_open(1))
					return
				body.face_atom(obstacle)
				body.pry_door((obstacle.pry_mod * body.get_door_pry_time()), obstacle)
				return

/datum/mob_controller/proc/handle_death(gibbed)
	return
