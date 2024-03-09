/mob/living/setBruteLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/getBruteLoss()
	return get_max_health() - current_health

/mob/living/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	adjustBruteLoss(amount * 0.5, do_update_health)

/mob/living/setToxLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	adjustBruteLoss(amount * 0.5, do_update_health)

/mob/living/setFireLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	adjustBruteLoss(amount * 0.5, do_update_health)

/mob/living/setHalLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())
