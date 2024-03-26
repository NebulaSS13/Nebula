/mob/living/silicon/ai
	var/fireloss = 0
	var/bruteloss = 0
	var/oxyloss = 0

/mob/living/silicon/ai/getFireLoss()
	return fireloss

/mob/living/silicon/ai/getBruteLoss()
	return bruteloss

/mob/living/silicon/ai/getOxyLoss()
	return oxyloss

/mob/living/silicon/ai/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	if(status_flags & GODMODE) return
	fireloss = max(0, fireloss + min(amount, current_health))
	if(do_update_health)
		update_health()

/mob/living/silicon/ai/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	if(!(status_flags & GODMODE))
		bruteloss = max(0, bruteloss + min(amount, current_health))
	..()

/mob/living/silicon/ai/adjustOxyLoss(var/damage, var/do_update_health = TRUE)
	if(!(status_flags & GODMODE))
		oxyloss = max(0, oxyloss + min(damage, get_max_health() - oxyloss))
	..()

/mob/living/silicon/ai/setBruteLoss(var/amount)
	if(status_flags & GODMODE)
		bruteloss = 0
		return
	bruteloss = max(0, amount)

/mob/living/silicon/ai/setFireLoss(var/amount)
	if(status_flags & GODMODE)
		fireloss = 0
		return
	fireloss = max(0, amount)

/mob/living/silicon/ai/setOxyLoss(var/amount)
	if(status_flags & GODMODE)
		oxyloss = 0
		return
	oxyloss = max(0, amount)

/mob/living/silicon/ai/update_health()
	. = ..()
	if(!.)
		set_damage(OXY, 0)

/mob/living/silicon/ai/rejuvenate()
	..()
	add_ai_verbs(src)

// Returns percentage of AI's remaining backup capacitor charge (max health - oxyloss).
/mob/living/silicon/ai/proc/backup_capacitor()
	var/current_max_health = get_max_health()
	return ((get_damage(OXY) - current_max_health) / current_max_health) * (-100)
