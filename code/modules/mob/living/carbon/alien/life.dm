/mob/living/carbon/alien/handle_mutations_and_radiation()
	..()
	if(radiation)
		var/rads = radiation/25
		radiation -= rads
		adjust_nutrition(rads)
		heal_overall_damage(rads,rads)
		adjustOxyLoss(-(rads))
		adjustToxLoss(-(rads))

/mob/living/carbon/alien/handle_regular_status_updates()

	. = ..()

	if(stat == DEAD)
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		set_status(STAT_SILENCE, 0)
	else if(HAS_STATUS(src, STAT_PARA))
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		set_stat(UNCONSCIOUS)
		if(getHalLoss() > 0)
			adjustHalLoss(-3)
	if(HAS_STATUS(src, STAT_ASLEEP))
		adjustHalLoss(-3)
		if (mind)
			if(mind.active && client != null)
				ADJ_STATUS(src, STAT_ASLEEP, -1)
		SET_STATUS_MAX(src, STAT_BLIND, 2)
		set_stat(UNCONSCIOUS)
	else if(resting)
		if(getHalLoss() > 0)
			adjustHalLoss(-3)
	else
		set_stat(CONSCIOUS)
		if(getHalLoss() > 0)
			adjustHalLoss(-1)

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

/mob/living/carbon/alien/handle_environment(var/datum/gas_mixture/environment)
	..()
	// Both alien subtypes survive in vaccum and suffer in high temperatures,
	// so I'll just define this once, for both (see radiation comment above)
	if(environment && environment.temperature > (T0C+66))
		adjustFireLoss((environment.temperature - (T0C+66))/5) // Might be too high, check in testing.
		if(prob(20))
			to_chat(src, "<span class='danger'>You feel a searing heat!</span>")

/mob/living/carbon/alien/handle_fire()
	if(..())
		return
	bodytemperature += BODYTEMP_HEATING_MAX //If you're on fire, you heat up!
	return
