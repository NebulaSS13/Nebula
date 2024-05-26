/mob/living/apply_radiation(var/damage = 0)
	if(!damage)
		return FALSE

	radiation = max(0, radiation + damage)
	return TRUE

/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/damage_flags = 0)
	if(brute)	take_damage(brute,   BRUTE, target_zone = def_zone)
	if(burn)	take_damage(burn,    BURN,  target_zone = def_zone)
	if(tox)		take_damage(tox,     TOX,   target_zone = def_zone)
	if(oxy)		take_damage(oxy,     OXY,   target_zone = def_zone)
	if(clone)	take_damage(clone,   CLONE, target_zone = def_zone)
	if(halloss) take_damage(halloss, PAIN,  target_zone = def_zone)
	return TRUE

/mob/living/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))	return FALSE
	switch(effecttype)
		if(STUN)
			SET_STATUS_MAX(src, STAT_STUN, effect * blocked_mult(blocked))
		if(WEAKEN)
			SET_STATUS_MAX(src, STAT_WEAK, effect * blocked_mult(blocked))
		if(PARALYZE)
			SET_STATUS_MAX(src, STAT_PARA, effect * blocked_mult(blocked))
		if(PAIN)
			take_damage(effect * blocked_mult(blocked), PAIN)
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter - TODO CANSTUTTER flag?
				SET_STATUS_MAX(src, STAT_STUTTER, effect * blocked_mult(blocked))
		if(EYE_BLUR)
			SET_STATUS_MAX(src, STAT_BLURRY, effect * blocked_mult(blocked))
		if(DROWSY)
			SET_STATUS_MAX(src, STAT_DROWSY, effect * blocked_mult(blocked))
	return TRUE

/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0)
	if(stun)		apply_effect(stun,      STUN, blocked)
	if(weaken)		apply_effect(weaken,    WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze,  PARALYZE, blocked)
	if(stutter)		apply_effect(stutter,   STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur,   EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy,    DROWSY, blocked)
	if(agony)		apply_effect(agony,     PAIN, blocked)
	return TRUE
