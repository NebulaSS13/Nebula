// This system is used to grab a ghost from observers with the required preferences and lack of bans set.
/decl/ghosttrap
	var/name
	var/minutes_since_death = 0     // If non-zero the ghost must have been dead for this many minutes to be allowed to spawn
	var/list/ban_checks
	var/pref_check
	var/ghost_trap_message
	var/can_set_own_name = TRUE
	var/list_as_special_role = TRUE	// If true, this entry will be listed as a special role in the character setup
	var/list/request_timeouts

/decl/ghosttrap/proc/forced(var/mob/user)
	return

// Check for bans, proper atom types, etc.
/decl/ghosttrap/proc/assess_candidate(var/mob/observer/ghost/candidate, var/mob/target, var/feedback = TRUE)
	. = TRUE
	if(get_config_value(/decl/config/enum/server_whitelist) == CONFIG_SERVER_JOIN_WHITELIST && !check_server_whitelist(candidate))
		. = FALSE
	else if(!candidate.MayRespawn(feedback, minutes_since_death))
		. = FALSE
	else if(islist(ban_checks))
		for(var/bantype in ban_checks)
			if(jobban_isbanned(candidate, "[bantype]"))
				if(feedback)
					to_chat(candidate, "You are banned from one or more required roles and hence cannot enter play as \a [name].")
				. = FALSE
				break

// Print a message to all ghosts with the right prefs/lack of bans.
/decl/ghosttrap/proc/request_player(var/mob/target, var/request_string, var/request_timeout)
	if(request_timeout)
		LAZYSET(request_timeouts, target, world.time + request_timeout)
		events_repository.register(/decl/observ/destroyed, target, src, TYPE_PROC_REF(/decl/ghosttrap, unregister_target))
	else
		unregister_target(target)

	for(var/mob/O in global.player_list)
		if(!assess_candidate(O, target, FALSE))
			return
		if(pref_check && !O.client.wishes_to_be_role(pref_check))
			continue
		if(O.client)
			to_chat(O, "[request_string] <a href='byond://?src=\ref[src];candidate=\ref[O];target=\ref[target]'>(Occupy)</a> ([ghost_follow_link(target, O)])")

/decl/ghosttrap/proc/unregister_target(var/target)
	LAZYREMOVE(request_timeouts, target)
	events_repository.unregister(/decl/observ/destroyed, target, src, TYPE_PROC_REF(/decl/ghosttrap, unregister_target))

// Handles a response to request_player().
/decl/ghosttrap/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["candidate"] && href_list["target"])
		var/mob/observer/ghost/candidate = locate(href_list["candidate"]) // BYOND magic.
		var/mob/target = locate(href_list["target"])                     // So much BYOND magic.
		if(!target || !candidate)
			return
		if(candidate != usr)
			return

		var/timeout = LAZYACCESS(request_timeouts, target)
		if(!isnull(timeout) && world.time > timeout)
			to_chat(candidate, "This occupation request is no longer valid.")
			return
		if(target.key)
			to_chat(candidate, "The target is already occupied.")
			return
		if(assess_candidate(candidate, target))
			transfer_personality(candidate,target)
		return 1

// Shunts the ckey/mind into the target mob.
/decl/ghosttrap/proc/transfer_personality(var/mob/candidate, var/mob/target)
	if(assess_candidate(candidate, target))
		target.ckey = candidate.ckey
		if(target.mind)
			target.mind.reset()
			target.mind.assigned_role = "[capitalize(name)]"
		announce_ghost_joinleave(candidate, 0, "[ghost_trap_message]")
		if(target)
			welcome_candidate(target)
			set_new_name(target)
			. = TRUE

/decl/ghosttrap/proc/welcome_candidate(var/mob/target)
	return

/decl/ghosttrap/proc/set_new_name(var/mob/target)
	if(!can_set_own_name)
		return

	var/newname = sanitize_safe(input(target,"Enter a name, or leave blank for the default name.", "Name change",target.real_name) as text, MAX_NAME_LEN)
	if (newname && newname != "")
		target.real_name = newname
		target.SetName(target.real_name)

/***********************************
* Computer intelligence cores. *
***********************************/
/decl/ghosttrap/machine_intelligence
	name = "machine intelligence"
	ban_checks = list("AI",ASSIGNMENT_ROBOT)
	pref_check = "ghost_machine_intelligence"
	ghost_trap_message = "They are occupying a computer intelligence core now."

/decl/ghosttrap/machine_intelligence/transfer_personality(mob/candidate, mob/target)
	if(assess_candidate(candidate))

		var/obj/item/organ/internal/brain/robotic/brain = target.loc?.loc
		if(!istype(brain))
			return FALSE

		brain.transfer_key_to_brainmob(candidate, update_brainmob = FALSE)
		brain.searching = FALSE
		brain.update_icon()
		announce_ghost_joinleave(candidate, 0, "[ghost_trap_message]")

		var/mob/living/brainmob = brain.get_brainmob(create_if_missing = TRUE)
		if(brainmob)
			welcome_candidate(brainmob)
			return TRUE

/decl/ghosttrap/machine_intelligence/forced(var/mob/user)
	var/obj/item/organ/internal/brain/robotic/brain = new(get_turf(user))
	request_player(brain.get_brainmob(create_if_missing = TRUE), "Someone is requesting a player for a machine intelligence.", 60 SECONDS)

/decl/ghosttrap/machine_intelligence/welcome_candidate(var/mob/target)
	to_chat(target, "<b>You are a machine intelligence, brought into existence on [station_name()].</b>")
	to_chat(target, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(target, "<b>Remember, the purpose of your existence is to serve the crew and the [station_name()]. Above all else, do no harm.</b>")
	to_chat(target, "<b>Use say [target.get_language_prefix()]b to speak to other artificial intelligences.</b>")
	var/turf/T = get_turf(target)
	T.visible_message(SPAN_NOTICE("\The [target] beeps loudly."))

/***********************************
* Walking mushrooms and such. *
***********************************/
/decl/ghosttrap/sentient_plant
	name = "sentient plant"
	ban_checks = list("Botany Roles")
	pref_check = "ghost_plant"
	ghost_trap_message = "They are occupying a living plant now."

/decl/ghosttrap/sentient_plant/forced(var/mob/user)
	request_player(new /mob/living/simple_animal/mushroom(get_turf(user)), "Someone is harvesting a walking mushroom.", 15 SECONDS)

/decl/ghosttrap/sentient_plant/welcome_candidate(var/mob/target)
	to_chat(target, "<span class='alium'><B>You awaken slowly, stirring into sluggish motion as the air caresses you.</B></span>")

/********************
* Maintenance Drone *
*********************/
/decl/ghosttrap/maintenance_drone
	name = "maintenance drone"
	pref_check = "ghost_maintdrone"
	ghost_trap_message = "They are occupying a maintenance drone now."
	can_set_own_name = FALSE

/decl/ghosttrap/maintenance_drone/Initialize()
	. = ..()
	minutes_since_death = DRONE_SPAWN_DELAY

/decl/ghosttrap/maintenance_drone/forced(var/mob/user)
	request_player(new /mob/living/silicon/robot/drone(get_turf(user)), "Someone is attempting to reboot a maintenance drone.", 30 SECONDS)

/decl/ghosttrap/maintenance_drone/assess_candidate(var/mob/observer/ghost/candidate, var/mob/target)
	. = ..()
	if(. && !target?.can_be_possessed_by(candidate))
		return 0

/decl/ghosttrap/maintenance_drone/transfer_personality(var/mob/candidate, var/mob/target)
	if(!assess_candidate(candidate))
		return 0
	var/mob/living/silicon/robot/drone/drone = target
	if(istype(drone))
		drone.transfer_personality(candidate.client)

/******************
* Wizard Familiar *
******************/
/decl/ghosttrap/wizard_familiar
	name = "wizard familiar"
	pref_check = "ghost_wizard"
	ghost_trap_message = "They are occupying a familiar now."
	ban_checks = list(/decl/special_role/wizard)

/decl/ghosttrap/wizard_familiar/welcome_candidate(var/mob/target)
	return 0

// Stub PAI ghost trap so that PAI shows up in the ghost role list.
// Actually invoking this ghost trap as normal will not do anything.
/decl/ghosttrap/personal_ai
	name = "personal AI"
	pref_check = BE_PAI
/decl/ghosttrap/personal_ai/forced(mob/user)
	user?.client?.makepAI(user && get_turf(user))
/decl/ghosttrap/personal_ai/request_player(mob/target, request_string, request_timeout)
	return FALSE
