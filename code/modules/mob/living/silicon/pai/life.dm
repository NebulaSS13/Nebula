/mob/living/silicon/pai/Life()

	SHOULD_CALL_PARENT(FALSE)

	if (src.stat == DEAD)
		return

	if(src.cable)
		if(get_dist(src, cable) > 1)
			visible_message( \
				message = SPAN_NOTICE("The data cable rapidly retracts back into its spool."), \
				blind_message = SPAN_NOTICE("You hear a click and the sound of wire spooling rapidly."))
			QDEL_NULL(cable)

	handle_regular_hud_updates()

	if(src.secHUD == 1)
		process_sec_hud(src, 1, network = get_computer_network())

	if(src.medHUD == 1)
		process_med_hud(src, 1, network = get_computer_network())

	process_os() // better safe than sorry, in case some pAI has it

	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>")

	handle_status_effects()

	if(health <= 0)
		death(null,"gives one shrill beep before falling lifeless.")

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = 100 - getBruteLoss() - getFireLoss()