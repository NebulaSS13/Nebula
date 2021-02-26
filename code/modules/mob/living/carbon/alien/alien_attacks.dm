//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/mob/living/carbon/alien/attack_hand(mob/user)

	switch(user.a_intent)

		if(I_GRAB)
			return ..()

		if (I_HELP)
			help_shake_act(user)

		else
			var/damage = rand(1, 9)
			if (prob(90))
				if (MUTATION_HULK in user.mutations)
					damage += 5
					spawn(0)
						Paralyse(1)
						step_away(src, user, 15)
						sleep(3)
						step_away(src, user, 15)
				playsound(loc, "punch", 25, 1, -1)
				visible_message(SPAN_DANGER("\The [user] has punched \the [src]!"), 1)
				if (damage > 4.9)
					Weaken(rand(10,15))
					user.visible_message(SPAN_DANGER("\The [user] has weakened \the [src]!"), 1, SPAN_WARNING("You hear someone fall."), 2)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("\The [user] has attempted to punch \the [src]!"), 1)
