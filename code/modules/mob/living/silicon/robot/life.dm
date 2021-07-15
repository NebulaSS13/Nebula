/mob/living/silicon/robot/Life()

	SHOULD_CALL_PARENT(FALSE)

	set invisibility = 0
	set background = 1

	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return

	src.blinded = null

	//Status updates, death etc.
	clamp_values()
	handle_regular_status_updates()
	handle_status_effects()
	handle_actions()

	if(client)
		handle_regular_hud_updates()
		update_items()
	if (src.stat != DEAD) //still using power
		use_power()
		process_killswitch()
		process_locks()
		process_queued_alarms()
	UpdateLyingBuckledAndVerbStatus()

/mob/living/silicon/robot/proc/clamp_values()
	set_status(STAT_PARA, min(GET_STATUS(src, STAT_PARA), 30))
	set_status(STAT_ASLEEP, 0)
	adjustBruteLoss(0)
	adjustToxLoss(0)
	adjustOxyLoss(0)
	adjustFireLoss(0)

/mob/living/silicon/robot/proc/use_power()
	used_power_this_tick = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if ( cell && is_component_functioning("power cell") && src.cell.charge > 0 )
		if(src.module_state_1)
			cell_use_power(50) // 50W load for every enabled tool TODO: tool-specific loads
		if(src.module_state_2)
			cell_use_power(50)
		if(src.module_state_3)
			cell_use_power(50)

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

/mob/living/silicon/robot/handle_regular_status_updates()

	if(src.camera && !scrambledcodes)
		if(src.stat == 2 || wires.IsIndexCut(BORG_WIRE_CAMERA))
			src.camera.set_status(0)
		else
			src.camera.set_status(1)

	updatehealth()

	if(HAS_STATUS(src, STAT_ASLEEP))
		SET_STATUS_MAX(src, STAT_PARA, 3)

	if(src.resting)
		SET_STATUS_MAX(src, STAT_WEAK, 5)

	if(health < config.health_threshold_dead && src.stat != 2) //die only once
		death()

	if (src.stat != DEAD) //Alive.
		if (incapacitated(INCAPACITATION_DISRUPTED) || !has_power)
			src.set_stat(UNCONSCIOUS)
			if (HAS_STATUS(src, STAT_STUN))
				ADJ_STATUS(src, STAT_STUN, -1)
			if(HAS_STATUS(src, STAT_WEAK))
				ADJ_STATUS(src, STAT_WEAK, -1)
			if (HAS_STATUS(src, STAT_PARA) > 0)
				ADJ_STATUS(src, STAT_PARA, -1)
				src.blinded = 1
			else
				src.blinded = 0

		else	//Not stunned.
			src.set_stat(CONSCIOUS)

	else //Dead.
		src.blinded = 1
		src.set_stat(DEAD)

	if(HAS_STATUS(src, STAT_BLIND))
		ADJ_STATUS(src, STAT_BLIND, -1)
		src.blinded = 1

	src.set_density(!src.lying)
	if(src.sdisabilities & BLINDED)
		src.blinded = 1
	if(src.sdisabilities & DEAFENED)
		src.set_status(STAT_DEAF, 1)

	//update the state of modules and components here
	if (src.stat != CONSCIOUS)
		uneq_all()

	if(silicon_radio)
		if(!is_component_functioning("radio"))
			silicon_radio.on = 0
		else
			silicon_radio.on = 1

	if(isnull(components["camera"]) || is_component_functioning("camera"))
		src.blinded = 0
	else
		src.blinded = 1

	return 1

/mob/living/silicon/robot/handle_regular_hud_updates()
	..()

	var/obj/item/borg/sight/hud/hud = (locate(/obj/item/borg/sight/hud) in src)
	if(hud && hud.hud)
		hud.hud.process_hud(src)
	else
		switch(src.sensor_mode)
			if (SEC_HUD)
				process_sec_hud(src,0,network = get_computer_network())
			if (MED_HUD)
				process_med_hud(src,0,network = get_computer_network())

	if(length(get_active_grabs()))
		ui_drop_grab.invisibility = 0
		ui_drop_grab.alpha = 255
	else
		ui_drop_grab.invisibility = INVISIBILITY_MAXIMUM
		ui_drop_grab.alpha = 0

	if (src.healths)
		if (src.stat != 2)
			if(istype(src,/mob/living/silicon/robot/drone))
				switch(health)
					if(35 to INFINITY)
						src.healths.icon_state = "health0"
					if(25 to 34)
						src.healths.icon_state = "health1"
					if(15 to 24)
						src.healths.icon_state = "health2"
					if(5 to 14)
						src.healths.icon_state = "health3"
					if(0 to 4)
						src.healths.icon_state = "health4"
					if(-35 to 0)
						src.healths.icon_state = "health5"
					else
						src.healths.icon_state = "health6"
			else
				switch(health)
					if(200 to INFINITY)
						src.healths.icon_state = "health0"
					if(150 to 200)
						src.healths.icon_state = "health1"
					if(100 to 150)
						src.healths.icon_state = "health2"
					if(50 to 100)
						src.healths.icon_state = "health3"
					if(0 to 50)
						src.healths.icon_state = "health4"
					if(config.health_threshold_dead to 0)
						src.healths.icon_state = "health5"
					else
						src.healths.icon_state = "health6"
		else
			src.healths.icon_state = "health7"

	if (src.syndicate && src.client)
		var/decl/special_role/traitors = GET_DECL(/decl/special_role/traitor)
		for(var/datum/mind/tra in traitors.current_antagonists)
			if(tra.current)
				// TODO: Update to new antagonist system.
				var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
				src.client.images += I
		src.disconnect_from_ai()
		if(src.mind)
			traitors.add_antagonist_mind(mind)

	if (src.cells)
		if (src.cell)
			var/chargeNum = Clamp(CEILING(cell.percent()/25), 0, 4)	//0-100 maps to 0-4, but give it a paranoid clamp just in case.
			src.cells.icon_state = "charge[chargeNum]"
		else
			src.cells.icon_state = "charge-empty"

	if(bodytemp)
		switch(src.bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				src.bodytemp.icon_state = "temp2"
			if(320 to 335)
				src.bodytemp.icon_state = "temp1"
			if(300 to 320)
				src.bodytemp.icon_state = "temp0"
			if(260 to 300)
				src.bodytemp.icon_state = "temp-1"
			else
				src.bodytemp.icon_state = "temp-2"

	var/datum/gas_mixture/environment = loc?.return_air()
	if(fire && environment)
		switch(environment.temperature)
			if(-INFINITY to T100C)
				src.fire.icon_state = "fire0"
			else
				src.fire.icon_state = "fire1"
	if(oxygen && environment)
		var/decl/species/species = all_species[global.using_map.default_species]
		if(!species.breath_type || environment.gas[species.breath_type] >= species.breath_pressure)
			src.oxygen.icon_state = "oxy0"
			for(var/gas in species.poison_types)
				if(environment.gas[gas])
					src.oxygen.icon_state = "oxy1"
					break
		else
			src.oxygen.icon_state = "oxy1"

	if(stat != DEAD)
		if(blinded)
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(GET_STATUS(src, STAT_BLURRY), "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(GET_STATUS(src, STAT_DRUGGY), "high", /obj/screen/fullscreen/high)

	return 1

/mob/living/silicon/robot/handle_vision()
	..()

	if (src.stat == DEAD || (MUTATION_XRAY in mutations) || (src.sight_mode & BORGXRAY))
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


/mob/living/silicon/robot/proc/update_items()
	if (src.client)
		src.client.screen -= src.contents
		for(var/obj/I in src.contents)
			if(I && !(istype(I,/obj/item/cell) || istype(I,/obj/item/radio)  || istype(I,/obj/machinery/camera) || istype(I,/obj/item/mmi)))
				src.client.screen += I
	if(src.module_state_1)
		src.module_state_1:screen_loc = ui_inv1
	if(src.module_state_2)
		src.module_state_2:screen_loc = ui_inv2
	if(src.module_state_3)
		src.module_state_3:screen_loc = ui_inv3
	update_icon()

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(src.client)
				to_chat(src, "<span class='danger'>Killswitch Activated</span>")
			killswitch = 0
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(src.client)
				to_chat(src, "<span class='danger'>Weapon Lock Timed Out!</span>")
			weapon_lock = 0
			weaponlock_time = 120

/mob/living/silicon/robot/update_fire()
	overlays -= image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")
	if(on_fire)
		overlays += image("icon"='icons/mob/OnFire.dmi', "icon_state"="Standing")

/mob/living/silicon/robot/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!on_fire) //Silicons don't gain stacks from hotspots, but hotspots can ignite them
		IgniteMob()
