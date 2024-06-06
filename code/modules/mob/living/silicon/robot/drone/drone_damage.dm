//Redefining some robot procs, since drones can't be repaired and really shouldn't take component damage.
/mob/living/silicon/robot/drone
	var/fireloss = 0
	var/bruteloss = 0

/mob/living/silicon/robot/drone/heal_damage(amount, damage_type = BRUTE, do_update_health, heal_synthetic)
	if(!heal_synthetic || !amount)
		return
	if(damage_type == BURN)
		fireloss = clamp(fireloss-amount, 0, get_max_health())
	else if(damage_type == BRUTE)
		bruteloss = clamp(bruteloss-amount, 0, get_max_health())
	else
		return
	if(do_update_health)
		update_health()

/mob/living/silicon/robot/drone/take_damage(damage, damage_type = BRUTE, damage_flags, used_weapon, armor_pen = 0, target_zone, silent = FALSE, override_droplimb, do_update_health = TRUE)

	if(status_flags & GODMODE)
		return

	if(damage_type == BURN)
		fireloss = clamp(fireloss+damage, 0, get_max_health())
	else if(damage_type == BRUTE)
		bruteloss = clamp(bruteloss+damage, 0, get_max_health())
	else
		return
	if(do_update_health)
		update_health()

/mob/living/silicon/robot/drone/getFireLoss()
	return fireloss

/mob/living/silicon/robot/drone/getBruteLoss()
	return bruteloss
