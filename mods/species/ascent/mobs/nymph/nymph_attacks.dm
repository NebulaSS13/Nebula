/mob/living/carbon/alien/ascent_nymph/UnarmedAttack(var/atom/A)
	. = ..()
	if(. && istype(A, /mob))
		visible_message(SPAN_NOTICE("\The [src] butts its head into \the [A]."))
		return

/mob/living/carbon/alien/ascent_nymph/get_throw_verb()
	return "spits out"
