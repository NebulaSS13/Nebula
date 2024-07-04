/mob/living/setBruteLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))

/mob/living/getBruteLoss()
	return get_max_health() - current_health

/mob/living/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	. = ..()
	if(amount > 0 && istype(ai))
		ai.retaliate()

/mob/living/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	take_damage(amount * 0.5, do_update_health = do_update_health)

/mob/living/setToxLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))

/mob/living/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	take_damage(amount * 0.5, do_update_health = do_update_health)
	if(amount > 0 && istype(ai))
		ai.retaliate()

/mob/living/setFireLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))

/mob/living/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	take_damage(amount * 0.5, do_update_health = do_update_health)

/mob/living/setHalLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))

/mob/living/explosion_act()
	var/oldhealth = current_health
	. = ..()
	if(istype(ai) && current_health < oldhealth)
		ai.retaliate()
