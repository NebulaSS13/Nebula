/mob/living/silicon/pai/handle_regular_hud_updates()
	. = ..()
	if(.)
		if(src.secHUD == 1)
			process_sec_hud(src, 1, network = get_computer_network())
		if(src.medHUD == 1)
			process_med_hud(src, 1, network = get_computer_network())

/mob/living/silicon/pai/handle_regular_status_updates()
	. = ..()
	if(src.cable && get_dist(src, cable) > 1)
		visible_message( \
			message = SPAN_NOTICE("The data cable rapidly retracts back into its spool."), \
			blind_message = SPAN_NOTICE("You hear a click and the sound of wire spooling rapidly."))
		QDEL_NULL(cable)

/mob/living/silicon/pai/death(gibbed, deathmessage, show_dead_message)
	return ..(deathmessage = "gives one shrill beep before falling lifeless.")

/mob/living/silicon/pai/Life()
	SHOULD_CALL_PARENT(FALSE)

	update_health()
	if (src.stat == DEAD)
		return
	handle_regular_hud_updates()
	process_os() // better safe than sorry, in case some pAI has it

	handle_status_effects()

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = 100 - getBruteLoss() - getFireLoss()