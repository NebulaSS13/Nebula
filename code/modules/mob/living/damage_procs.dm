/mob/living/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))	return FALSE
	switch(effecttype)
		if(STUN)
			SET_STATUS_MAX(src, STAT_STUN, effect * blocked_mult(blocked))
		if(WEAKEN)
			SET_STATUS_MAX(src, STAT_WEAK, effect * blocked_mult(blocked))
		if(PARALYZE)
			SET_STATUS_MAX(src, STAT_PARA, effect * blocked_mult(blocked))
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter - TODO CANSTUTTER flag?
				SET_STATUS_MAX(src, STAT_STUTTER, effect * blocked_mult(blocked))
		if(EYE_BLUR)
			SET_STATUS_MAX(src, STAT_BLURRY, effect * blocked_mult(blocked))
		if(DROWSY)
			SET_STATUS_MAX(src, STAT_DROWSY, effect * blocked_mult(blocked))
	return TRUE

/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/blocked = 0)
	if(stun)		apply_effect(stun,      STUN,     blocked)
	if(weaken)		apply_effect(weaken,    WEAKEN,   blocked)
	if(paralyze)	apply_effect(paralyze,  PARALYZE, blocked)
	if(stutter)		apply_effect(stutter,   STUTTER,  blocked)
	if(eyeblur)		apply_effect(eyeblur,   EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy,    DROWSY,   blocked)
	return TRUE
