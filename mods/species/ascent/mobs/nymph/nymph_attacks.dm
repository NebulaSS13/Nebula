/mob/living/carbon/alien/ascent_nymph/UnarmedAttack(var/atom/A)

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	if(ismob(A))
		visible_message(SPAN_NOTICE("\The [src] butts its head into \the [A]."))
		return

	. = ..()
