/mob/living/silicon/ai/should_be_dead()
	return get_health_percent() <= 0 || backup_capacitor() <= 0

/mob/living/silicon/ai/handle_regular_status_updates()
	. = ..()
	if(stat != CONSCIOUS)
		src.cameraFollow = null
		src.reset_view(null)

/mob/living/silicon/ai/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	// If our powersupply object was destroyed somehow, create new one.
	if(!psupply)
		create_powersupply()
	// We aren't shut down, and we lack external power. Try to fix it using the restoration routine.
	if (!self_shutdown && !has_power(0))
		// AI's restore power routine is not running. Start it automatically.
		if(aiRestorePowerRoutine == AI_RESTOREPOWER_IDLE)
			aiRestorePowerRoutine = AI_RESTOREPOWER_STARTING
			handle_power_failure()
	update_power_usage()
	handle_power_oxyloss()
	process_queued_alarms()
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