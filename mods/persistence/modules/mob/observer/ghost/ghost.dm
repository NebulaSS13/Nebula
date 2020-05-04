/mob/living/Initialize()
	. = ..()
	verbs -= /mob/living/verb/ghost

/mob/ghostize(var/can_reenter_corpse = CORPSE_CAN_REENTER, var/is_admin_ghost = FALSE)
	if(is_admin_ghost && key && check_rights(R_ADMIN, 0, src)) // Allow admins to ghost.
		hide_fullscreens()
		var/mob/observer/ghost/ghost = new(src)	//Transfer safety to observer spawning proc.
		ghost.can_reenter_corpse = can_reenter_corpse
		ghost.timeofdeath = src.stat == DEAD ? src.timeofdeath : world.time
		ghost.key = key
		if(ghost.client && !ghost.client.holder && !config.antag_hud_allowed)		// For new ghosts we remove the verb from even showing up if it's not allowed.
			ghost.verbs -= /mob/observer/ghost/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
		return ghost

	return

/datum/movement_handler/mob/death/DoMove()
	return // no ghosting.