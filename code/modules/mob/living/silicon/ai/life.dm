/mob/living/silicon/ai/Life()

	SHOULD_CALL_PARENT(FALSE)

	if (src.stat == DEAD)
		return

	if (src.stat!=CONSCIOUS)
		src.cameraFollow = null
		src.reset_view(null)

	src.updatehealth()

	if ((hardware_integrity() <= 0) || (backup_capacitor() <= 0))
		death()
		return

	// If our powersupply object was destroyed somehow, create new one.
	if(!psupply)
		create_powersupply()

	lying = 0			// Handle lying down

	// We aren't shut down, and we lack external power. Try to fix it using the restoration routine.
	if (!self_shutdown && !has_power(0))
		// AI's restore power routine is not running. Start it automatically.
		if(aiRestorePowerRoutine == AI_RESTOREPOWER_IDLE)
			aiRestorePowerRoutine = AI_RESTOREPOWER_STARTING
			handle_power_failure()

	handle_impaired_vision()
	update_power_usage()
	handle_power_oxyloss()
	update_sight()

	process_queued_alarms()
	handle_regular_hud_updates()
	handle_status_effects()

	switch(src.sensor_mode)
		if (SEC_HUD)
			process_sec_hud(src,0,src.eyeobj,get_computer_network())
		if (MED_HUD)
			process_med_hud(src,0,src.eyeobj,get_computer_network())

	process_os()

	if(controlling_drone && stat != CONSCIOUS)
		controlling_drone.release_ai_control("<b>WARNING: Primary control loop failure.</b> Session terminated.")

/mob/living/silicon/ai/update_living_sight()
	if(!has_power() || self_shutdown)
		update_icon()
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		set_sight(sight&(~SEE_TURFS)&(~SEE_MOBS)&(~SEE_OBJS))
		set_see_in_dark(0)
		set_see_invisible(SEE_INVISIBLE_LIVING)
	else
		clear_fullscreen("blind")
		..()