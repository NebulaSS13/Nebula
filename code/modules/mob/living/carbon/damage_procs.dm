/*
Contians the proc to handle radiation.
Specifically made to do radiation burns.
*/


/mob/living/carbon/apply_radiation(damage)
	..()
	if(!isSynthetic() && !ignore_rads)
		var/decl/bodytype/my_bodytype = get_bodytype()
		damage = 0.25 * damage * (my_bodytype ? my_bodytype.get_radiation_mod(src) : 1)
		adjustFireLoss(damage)
		updatehealth()
	return TRUE
