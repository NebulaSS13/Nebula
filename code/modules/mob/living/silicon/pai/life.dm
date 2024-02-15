/mob/living/silicon/pai/handle_regular_hud_updates()
	. = ..()
	if(.)
		if(src.secHUD == 1)
			process_sec_hud(src, 1, network = get_computer_network())
		if(src.medHUD == 1)
			process_med_hud(src, 1, network = get_computer_network())

/mob/living/silicon/pai/handle_regular_status_updates()
	. = ..()
	process_os() // better safe than sorry, in case some pAI has it
	if(src.cable && get_dist(src, cable) > 1)
		visible_message( \
			message = SPAN_NOTICE("The data cable rapidly retracts back into its spool."), \
			blind_message = SPAN_NOTICE("You hear a click and the sound of wire spooling rapidly."))
		QDEL_NULL(cable)
