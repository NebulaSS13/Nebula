/mob/living/exosuit
	var/static/list/ignore_status_conditions = list(
		STAT_STUN,
		STAT_WEAK,
		STAT_PARA
	)

/mob/living/exosuit/set_status(condition, amount)
	. = !(condition in ignore_status_conditions) && ..()

/mob/living/exosuit/getOxyLoss()
	return 0

/mob/living/exosuit/setOxyLoss()
	return 0

/mob/living/exosuit/adjustOxyLoss(var/damage, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return 0

/mob/living/exosuit/getToxLoss()
	return 0

/mob/living/exosuit/setToxLoss()
	return 0

/mob/living/exosuit/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	return 0

/mob/living/exosuit/getBrainLoss()
	return 0

/mob/living/exosuit/setBrainLoss()
	return 0

/mob/living/exosuit/adjustBrainLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return 0

/mob/living/exosuit/getCloneLoss()
	return 0

/mob/living/exosuit/setCloneLoss()
	return 0

/mob/living/exosuit/adjustCloneLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return 0

/mob/living/exosuit/getHalLoss()
	return 0

/mob/living/exosuit/setHalLoss()
	return 0

/mob/living/exosuit/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return 0