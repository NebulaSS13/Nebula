/mob/living/exosuit
	var/static/list/ignore_status_conditions = list(
		STAT_STUN,
		STAT_WEAK,
		STAT_PARA
	)

/mob/living/exosuit/set_status(condition, amount)
	. = !(condition in ignore_status_conditions) && ..()

/mob/living/exosuit/get_brain_damage()
	return 0

/mob/living/exosuit/set_brain_damage()
	return 0
