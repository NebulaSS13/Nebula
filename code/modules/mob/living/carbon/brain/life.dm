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
					adjustToxLoss(1, do_update_health = TRUE)

			if(50 to 74)
				radiation -= 2
				adjustToxLoss(1, do_update_health = TRUE)
				if(prob(5))
					radiation -= 5
					if(!container)
						to_chat(src, "<span class='warning'>You feel weak.</span>")
					else
						to_chat(src, "<span class='warning'>STATUS: DANGEROUS LEVELS OF RADIATION DETECTED.</span>")

			if(75 to 100)
				radiation -= 3
				adjustToxLoss(3, do_update_health = TRUE)

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
	return !container && (current_health < config.health_threshold_dead || (config.revival_brain_life >= 0 && (world.time - timeofhostdeath) > config.revival_brain_life))

/mob/living/carbon/brain/handle_regular_status_updates()

	. = ..()
	if(!. || stat == DEAD || !emp_damage || !container)
		return

/mob/living/carbon/brain/can_change_intent()
	return TRUE
