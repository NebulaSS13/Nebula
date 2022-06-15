/mob/living/carbon/alien/ascent_nymph/get_throw_verb()
	return "spits out"

/mob/living/carbon/alien/ascent_nymph/UnarmedAttack(var/atom/A)
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return A.attack_hand(src)
