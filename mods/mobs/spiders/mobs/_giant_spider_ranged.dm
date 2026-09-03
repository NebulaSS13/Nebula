/mob/living/simple_animal/hostile/giant_spider/ranged
	abstract_type = /mob/living/simple_animal/hostile/giant_spider/ranged
	var/ranged_charges = 10
	var/max_ranged_charges = 15
	var/ranged_charge_regen_prob = 20

/mob/living/simple_animal/hostile/giant_spider/ranged/has_ranged_attack(atom/target)
	. = ranged_charges > 0 && !Adjacent(target)
	if(. && isliving(target))
		var/mob/living/victim = target
		if(victim.incapacitated(INCAPACITATION_DISABLED) || victim.stat != CONSCIOUS)
			. = FALSE

/mob/living/simple_animal/hostile/giant_spider/ranged/handle_regular_status_updates()
	. = ..()
	if(!.)
		return FALSE
	if(ranged_charges <= max_ranged_charges && prob(ranged_charge_regen_prob))
		ranged_charges++

/mob/living/simple_animal/hostile/giant_spider/ranged/shoot_at()
	. = ..()
	if(.)
		ranged_charges--
