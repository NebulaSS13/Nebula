/mob/living/carbon/alien/ascent_nymph/UnarmedAttack(var/atom/A)

	. = ..()
	if(.)
		return

	if(ismob(A))
		setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		visible_message(SPAN_NOTICE("\The [src] butts its head into \the [A]."))
		return TRUE
	return FALSE
