/mob/living/carbon/alien/ascent_nymph/UnarmedAttack(var/atom/A)
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(a_intent == I_DISARM || a_intent == I_HELP)
		if(can_collect(A))
			collect(A)
			return

	if(istype(A, /mob))
		visible_message(SPAN_NOTICE("\The [src] butts its head into \the [A]."))
		return

	. = ..()

/mob/living/carbon/alien/ascent_nymph/RangedAttack(atom/A, var/params)
	if((a_intent == I_HURT || a_intent == I_GRAB) && holding_item)
		setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		visible_message(SPAN_DANGER("\The [src] spits \a [holding_item] at \the [A]!"))
		var/atom/movable/temp = holding_item
		try_unequip(holding_item)
		if(temp)
			temp.throw_at(A, 10, rand(3,5), src)
		return TRUE
	. = ..()