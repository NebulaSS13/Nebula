/mob/living/carbon/brain/need_breathe()
	return FALSE

/mob/living/carbon/brain/should_breathe()
	return FALSE

/mob/living/carbon/brain/handle_mutations_and_radiation()
	..()
	if (radiation)
		if (radiation > 100)
			radiation = 100
			if(!container)//If it's not in an MMI
				to_chat(src, "<span class='notice'>You feel weak.</span>")
			else//Fluff-wise, since the brain can't detect anything itself, the MMI handles thing like that
				to_chat(src, "<span class='warning'>STATUS: CRITICAL AMOUNTS OF RADIATION DETECTED.</span>")
		switch(radiation)
			if(1 to 49)
				radiation--
				if(prob(25))
					adjustToxLoss(1)

			if(50 to 74)
				radiation -= 2
				adjustToxLoss(1)
				if(prob(5))
					radiation -= 5
					if(!container)
						to_chat(src, "<span class='warning'>You feel weak.</span>")
					else
						to_chat(src, "<span class='warning'>STATUS: DANGEROUS LEVELS OF RADIATION DETECTED.</span>")

			if(75 to 100)
				radiation -= 3
				adjustToxLoss(3)

/mob/living/carbon/brain/handle_environment(datum/gas_mixture/environment)
	..()
	if(!environment)
		return
	var/environment_heat_capacity = environment.heat_capacity()
	if(isspaceturf(get_turf(src)))
		var/turf/heat_turf = get_turf(src)
		environment_heat_capacity = heat_turf.heat_capacity
	if((environment.temperature > (T0C + 50)) || (environment.temperature < (T0C + 10)))
		var/transfer_coefficient = 1
		handle_temperature_damage(SLOT_HEAD, environment.temperature, environment_heat_capacity*transfer_coefficient)
	if(stat == DEAD)
		bodytemperature += 0.1*(environment.temperature - bodytemperature)*environment_heat_capacity/(environment_heat_capacity + 270000)


/mob/living/carbon/brain/proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
	if(status_flags & GODMODE) return
	if(exposed_temperature > bodytemperature)
		var/discomfort = min( abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)
		adjustFireLoss(20.0*discomfort)
	else
		var/discomfort = min( abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)
		adjustFireLoss(5.0*discomfort)

/mob/living/carbon/brain/apply_chemical_effects()
	. = ..()
	if(resting)
		ADJ_STATUS(src, STAT_DIZZY, -4)
		return TRUE

/mob/living/carbon/brain/is_blind()
	return !container || ..()

/mob/living/carbon/brain/should_be_dead()
	if(container)
		return FALSE
	if(current_health >= get_config_value(/decl/config/num/health_health_threshold_dead))
		return FALSE
	var/revival_brain_life = get_config_value(/decl/config/num/health_revival_brain_life)
	return revival_brain_life >= 0 && (world.time - timeofhostdeath) > revival_brain_life

/mob/living/carbon/brain/handle_regular_status_updates()

	. = ..()
	if(!. || stat == DEAD || !emp_damage || !container)
		return

	//Handling EMP effect in the Life(), it's made VERY simply, and has some additional effects handled elsewhere
	//This is pretty much a damage type only used by MMIs, dished out by the emp_act
	emp_damage = round(emp_damage,1)//Let's have some nice numbers to work with
	switch(emp_damage)
		if(31 to INFINITY)
			emp_damage = 30//Let's not overdo it
		if(21 to 30)//High level of EMP damage, unable to see, hear, or speak
			SET_STATUS_MAX(src, STAT_BLIND, 2)
			SET_STATUS_MAX(src, STAT_DEAF, 1)
			set_status(STAT_SILENCE, 1)
			if(!alert)//Sounds an alarm, but only once per 'level'
				emote("alarm")
				to_chat(src, SPAN_WARNING("Major electrical distruption detected: System rebooting."))
				alert = 1
			if(prob(75))
				emp_damage -= 1
		if(20)
			alert = 0
			set_status(STAT_BLIND,   0)
			set_status(STAT_DEAF,    0)
			set_status(STAT_SILENCE, 0)
			emp_damage -= 1
		if(11 to 19)//Moderate level of EMP damage, resulting in nearsightedness and ear damage
			set_status(STAT_BLURRY, 1)
			set_status(STAT_TINNITUS, 1)
			if(!alert)
				emote("alert")
				to_chat(src, SPAN_WARNING("Primary systems are now online."))
				alert = 1
			if(prob(50))
				emp_damage -= 1
		if(10)
			alert = 0
			set_status(STAT_BLURRY, 0)
			set_status(STAT_TINNITUS, 0)
			emp_damage -= 1
		if(2 to 9)//Low level of EMP damage, has few effects(handled elsewhere)
			if(!alert)
				emote("notice")
				to_chat(src, SPAN_WARNING("System reboot nearly complete."))
				alert = 1
			if(prob(25))
				emp_damage -= 1
		if(1)
			alert = 0
			to_chat(src, SPAN_WARNING("All systems restored."))
			emp_damage -= 1

/mob/living/carbon/brain/handle_regular_hud_updates()
	. = ..()
	if(!.)
		return
	update_sight()
	if (healths)
		if (stat != DEAD)
			switch(current_health)
				if(100 to INFINITY)
					healths.icon_state = "health0"
				if(80 to 100)
					healths.icon_state = "health1"
				if(60 to 80)
					healths.icon_state = "health2"
				if(40 to 60)
					healths.icon_state = "health3"
				if(20 to 40)
					healths.icon_state = "health4"
				if(0 to 20)
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

	if(stat != DEAD)
		if(is_blind())
			overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
		else
			clear_fullscreen("blind")
			set_fullscreen(disabilities & NEARSIGHTED, "impaired", /obj/screen/fullscreen/impaired, 1)
			set_fullscreen(GET_STATUS(src, STAT_BLURRY), "blurry", /obj/screen/fullscreen/blurry)
			set_fullscreen(GET_STATUS(src, STAT_DRUGGY), "high", /obj/screen/fullscreen/high)
		if (machine)
			if (!( machine.check_eye(src) ))
				reset_view(null)
	return 1

/mob/living/carbon/brain/can_change_intent()
	return TRUE
