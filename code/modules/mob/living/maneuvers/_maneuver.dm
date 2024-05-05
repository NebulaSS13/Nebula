/decl/maneuver
	abstract_type = /decl/maneuver
	var/name = "unnamed"
	var/delay = 2 SECONDS
	var/cooldown = 10 SECONDS
	var/stamina_cost = 10
	var/reflexive_modifier = 1
	var/selection_icon = 'icons/screen/maneuver.dmi'
	var/selection_icon_state

/decl/maneuver/validate()
	. = ..()
	if(!selection_icon)
		. += "no selection icon"
	else if(!selection_icon_state)
		. += "no selection icon_state"
	else if(!check_state_in_icon(selection_icon_state, selection_icon))
		. += "selection icon_state [selection_icon_state] not found in icon [selection_icon]"

/decl/maneuver/proc/can_be_used_by(var/mob/living/user, var/atom/target, var/silent = FALSE)
	if(!istype(user) || !user.can_do_maneuver(src, silent))
		return FALSE
	if(user.buckled)
		if(!silent)
			to_chat(user, SPAN_WARNING("You are buckled down and cannot maneuver!"))
		return FALSE
	if(!user.has_gravity())
		if(!silent)
			to_chat(user, SPAN_WARNING("You cannot maneuver in zero gravity!"))
		return FALSE
	if(user.incapacitated(INCAPACITATION_DISABLED|INCAPACITATION_DISRUPTED) || user.current_posture.prone || !isturf(user.loc))
		if(!silent)
			to_chat(user, SPAN_WARNING("You are not in position for maneuvering."))
		return FALSE
	if(user.is_on_special_ability_cooldown())
		if(!silent)
			to_chat(user, SPAN_WARNING("You cannot maneuver again for another [user.get_seconds_until_next_special_ability_string()]."))
		return FALSE
	if(user.get_stamina() < stamina_cost)
		if(!silent)
			to_chat(user, SPAN_WARNING("You are too exhausted to maneuver right now."))
		return FALSE
	return TRUE

/decl/maneuver/proc/show_initial_message(var/mob/user, var/atom/target)
	return

/decl/maneuver/proc/perform(var/mob/living/user, var/atom/target, var/strength, var/reflexively = FALSE)
	if(can_be_used_by(user, target))
		if(!reflexively)
			show_initial_message(user, target)
		user.face_atom(target)
		. = (!delay || reflexively || (do_after(user, delay) && can_be_used_by(user, target)))
		if(cooldown)
			user.set_special_ability_cooldown(cooldown)
		if(stamina_cost)
			user.adjust_stamina(stamina_cost)
