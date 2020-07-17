/*
Contians the proc to handle radiation.
Specifically made to do radiation burns.
*/


/mob/living/carbon/apply_radiation(damage)
	..()
	if(!isSynthetic() && !ignore_rads)
		damage = 0.25 * damage * (species ? species.get_radiation_mod(src) : 1)
		adjustFireLoss(damage)
		updatehealth()
	return TRUE
