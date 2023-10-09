/mob/living/carbon/alien/handle_mutations_and_radiation()
	..()
	var/rads = get_damage(IRRADIATE)
	if(rads)
		rads /= 25
		adjust_nutrition(rads)
		heal_damage(rads, IRRADIATE)
		heal_damage(rads, BRUTE)
		heal_damage(rads, BURN)
		heal_damage(rads, OXY, skip_update_health = TRUE)
		heal_damage(rads, TOX)

/mob/living/carbon/alien/handle_regular_status_updates()

	. = ..()

	if(stat == DEAD)
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		set_status(STAT_SILENCE, 0)
	else if(HAS_STATUS(src, STAT_PARA))
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		set_stat(UNCONSCIOUS)
		if(get_damage(PAIN) > 0)
			heal_damage(3, PAIN)
	if(HAS_STATUS(src, STAT_ASLEEP))
		heal_damage(3, PAIN)
		if (mind)
			if(mind.active && client != null)
				ADJ_STATUS(src, STAT_ASLEEP, -1)
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		set_stat(UNCONSCIOUS)
	else if(resting)
		if(get_damage(PAIN) > 0)
			heal_damage(3, PAIN)
	else
		set_stat(CONSCIOUS)
		if(get_damage(PAIN) > 0)
			heal_damage(3, PAIN)

	// Eyes and blindness.
	if(!check_has_eyes())
		set_status(STAT_BLIND, 1)
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		set_status(STAT_BLURRY, 1)
	else if(GET_STATUS(src, STAT_BLIND))
		ADJ_STATUS(src, STAT_BLIND, -1)
		SET_STATUS_MAX(src, STAT_BLIND, 2)
	update_icon()
	return TRUE

/mob/living/carbon/alien/handle_regular_hud_updates()
	. = ..()
	if(!.)
		return
	update_sight()
	if (healths)
		if(stat != DEAD)
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
		if(machine)
			if(machine.check_eye(src) < 0)
				reset_view(null)

/mob/living/carbon/alien/handle_environment(var/datum/gas_mixture/environment)
	..()
	// Both alien subtypes survive in vaccum and suffer in high temperatures,
	// so I'll just define this once, for both (see radiation comment above)
	if(environment && environment.temperature > (T0C+66))
		take_damage((environment.temperature - (T0C+66))/5, BURN) // Might be too high, check in testing.
		if (fire) fire.icon_state = "fire2"
		if(prob(20))
			to_chat(src, "<span class='danger'>You feel a searing heat!</span>")
	else
		if (fire) fire.icon_state = "fire0"

/mob/living/carbon/alien/handle_fire()
	if(..())
		return
	bodytemperature += BODYTEMP_HEATING_MAX //If you're on fire, you heat up!
	return
