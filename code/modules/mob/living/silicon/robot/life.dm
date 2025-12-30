/mob/living/silicon/robot/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	use_power()
	process_killswitch()
	process_locks()
	process_queued_alarms()
	process_os()

/mob/living/silicon/robot/proc/use_power()
	used_power_this_tick = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if ( cell && is_component_functioning("power cell") && src.cell.charge > 0 )
		// 50W load for every enabled tool TODO: tool-specific loads
		var/use_power = 50 * length(get_held_items())
		if(use_power)
			cell_use_power(use_power)

		if(lights_on)
			if(intenselight)
				cell_use_power(100)	// Upgraded light. Double intensity, much larger power usage.
			else
				cell_use_power(30) 	// 30W light. Normal lights would use ~15W, but increased for balance reasons.

		src.has_power = 1
	else
		power_down()

/mob/living/silicon/robot/proc/power_down()
	if (has_power)
		visible_message("[src] beeps stridently as it begins to run on emergency backup power!", SPAN_WARNING("You beep stridently as you begin to run on emergency backup power!"))
		has_power = 0
		set_stat(UNCONSCIOUS)
	if(lights_on) // Light is on but there is no power!
		lights_on = 0
		set_light(0)

/mob/living/silicon/robot/should_be_dead()
	return current_health < get_config_value(/decl/config/num/health_health_threshold_dead)

/mob/living/silicon/robot/handle_regular_status_updates()
	SHOULD_CALL_PARENT(FALSE)
	update_health()

	set_status_condition(STAT_PARA, min(GET_STATUS(src, STAT_PARA), 30))
	if(HAS_STATUS(src, STAT_ASLEEP))
		SET_STATUS_MAX(src, STAT_PARA, 3)

	if (stat != DEAD) //Alive.
		// This previously used incapacitated(INCAPACITATION_DISRUPTED) but that was setting the robot to be permanently unconscious, which isn't ideal.
		if(!has_power || incapacitated(INCAPACITATION_STUNNED) || HAS_STATUS(src, STAT_PARA))
			SET_STATUS_MAX(src, STAT_BLIND, 2)
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)

	else //Dead.
		cameranet.update_visibility(src, FALSE)
		SET_STATUS_MAX(src, STAT_BLIND, 2)

	if(has_genetic_condition(GENE_COND_BLINDED))
		SET_STATUS_MAX(src, STAT_BLIND, 2)

	if(has_genetic_condition(GENE_COND_DEAFENED))
		src.set_status_condition(STAT_DEAF, 1)

	//update the state of modules and components here
	if (stat != CONSCIOUS)
		drop_held_items()

	if(silicon_radio)
		if(!is_component_functioning("radio"))
			silicon_radio.on = 0
		else
			silicon_radio.on = 1

	if(!isnull(components["camera"]) && !is_component_functioning("camera"))
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		cameranet.update_visibility(src, FALSE)

	return 1

/mob/living/silicon/robot/handle_regular_hud_updates()
	. = ..()
	if(!.)
		return
	var/obj/item/borg/sight/hud/hud = (locate(/obj/item/borg/sight/hud) in src)
	if(hud?.hud)
		hud.hud.process_hud(src)
	else
		switch(src.sensor_mode)
			if (SEC_HUD)
				process_sec_hud(src,0,network = get_computer_network())
			if (MED_HUD)
				process_med_hud(src,0,network = get_computer_network())

	if(stat != DEAD)
		if(is_blind())
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(has_genetic_condition(GENE_COND_NEARSIGHTED), "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(GET_STATUS(src, STAT_BLURRY), "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(GET_STATUS(src, STAT_DRUGGY), "high", /obj/screen/fullscreen/high)

/mob/living/silicon/robot/handle_vision()
	..()

	if (src.stat == DEAD || has_genetic_condition(GENE_COND_XRAY) || (src.sight_mode & BORGXRAY))
		set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
	else if ((src.sight_mode & BORGMESON) && (src.sight_mode & BORGTHERM))
		set_sight(sight|SEE_TURFS|SEE_MOBS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else if (src.sight_mode & BORGMESON)
		set_sight(sight|SEE_TURFS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else if (src.sight_mode & BORGMATERIAL)
		set_sight(sight|SEE_OBJS)
		set_see_in_dark(8)
	else if (src.sight_mode & BORGTHERM)
		set_sight(sight|SEE_MOBS)
		set_see_in_dark(8)
		set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)
	else if (src.stat != DEAD)
		set_sight(sight&(~SEE_TURFS)&(~SEE_MOBS)&(~SEE_OBJS))
		set_see_in_dark(8) 			 // see_in_dark means you can FAINTLY see in the dark, humans have a range of 3 or so
		set_see_invisible(SEE_INVISIBLE_LIVING) // This is normal vision (25), setting it lower for normal vision means you don't "see" things like darkness since darkness
							 // has a "invisible" value of 15

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			to_chat(src, SPAN_DANGER("Killswitch activated."))
			killswitch = 0
			spawn(5)
				gib()
/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		drop_held_items()
		weaponlock_time --
		if(weaponlock_time <= 0)
			to_chat(src, SPAN_DANGER("Weapon lock timed out!"))
			weapon_lock = 0
			weaponlock_time = 120

/mob/living/silicon/robot/update_fire()
	overlays -= image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")
	if(is_on_fire())
		overlays += image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")

//Silicons don't gain stacks from hotspots, but hotspots can ignite them
/mob/living/silicon/increase_fire_intensity(exposed_temperature)
	return

/mob/living/silicon/can_ignite()
	return !is_on_fire()
