/datum/mob_controller/bot/security/ed209/handle_ranged_target(atom/ranged_target)
	if(istype(ranged_target))
		body.RangedAttack(ranged_target)
