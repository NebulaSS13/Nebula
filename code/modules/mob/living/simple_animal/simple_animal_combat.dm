/mob/living/simple_animal/proc/attack_target(mob/target)

	if(buckled_mob == target && (!faction || buckled_mob.faction != faction))
		visible_message(SPAN_DANGER("\The [src] attempts to unseat \the [buckled_mob]!"))
		set_dir(pick(global.cardinal))
		setClickCooldown(attack_delay)
		if(prob(33))
			unbuckle_mob()
			if(buckled_mob != target && !QDELETED(target))
				to_chat(target, SPAN_DANGER("You are thrown off \the [src]!"))
				SET_STATUS_MAX(target, STAT_WEAK, 3)
		return target

	if(isliving(target) && Adjacent(target))
		a_intent = I_HURT
		UnarmedAttack(target, TRUE)
		return target
