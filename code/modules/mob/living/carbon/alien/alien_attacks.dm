//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return


/mob/living/carbon/alien/default_help_interaction(mob/user)
	. = ..()
	if(!.)
		help_shake_act(user)
		return TRUE

/mob/living/carbon/alien/default_hurt_interaction(mob/user)
	. = ..()
	if(!.)
		var/damage = rand(1, 9)
		if (prob(90))
			playsound(loc, "punch", 25, 1, -1)
			visible_message(SPAN_DANGER("\The [user] has punched \the [src]!"), 1)
			if (damage > 4.9)
				SET_STATUS_MAX(src, STAT_WEAK, rand(10,15))
				user.visible_message(SPAN_DANGER("\The [user] has weakened \the [src]!"), 1, SPAN_WARNING("You hear someone fall."), 2)
			adjustBruteLoss(damage)
		else
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message(SPAN_DANGER("\The [user] has attempted to punch \the [src]!"), 1)
		return TRUE
