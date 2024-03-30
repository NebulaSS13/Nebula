/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn

	Returns
	standard 0 if fail
*/
/mob/living/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/damage_flags = 0, var/used_weapon = null, var/armor_pen, var/silent = FALSE)

	if(status_flags & GODMODE)
		return FALSE

	if(!damage)
		return FALSE

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, silent)
	damage = after_armor[1]
	damagetype = after_armor[2]
	damage_flags = after_armor[3] // args modifications in case of parent calls
	if(!damage)
		return FALSE

	switch(damagetype)
		if(BRUTE)
			take_damage(BRUTE, damage)
		if(BURN)
			if(MUTATION_COLD_RESISTANCE in mutations)
				return
			take_damage(BURN, damage)
		if(TOX)
			take_damage(TOX, damage)
		if(OXY)
			take_damage(OXY, damage)
		if(CLONE)
			take_damage(CLONE, damage)
		if(PAIN)
			take_damage(PAIN, damage)
		if(ELECTROCUTE)
			electrocute_act(damage, used_weapon, 1, def_zone)
		if(IRRADIATE)
			take_damage(IRRADIATE, damage)
	return TRUE

/mob/living/apply_radiation(var/damage = 0)
	if(!damage)
		return FALSE

	radiation = max(0, radiation + damage)
	return TRUE

/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/damage_flags = 0)
	if(brute)	apply_damage(brute, BRUTE, def_zone)
	if(burn)	apply_damage(burn, BURN, def_zone)
	if(tox)		apply_damage(tox, TOX, def_zone)
	if(oxy)		apply_damage(oxy, OXY, def_zone)
	if(clone)	apply_damage(clone, CLONE, def_zone)
	if(halloss) apply_damage(halloss, PAIN, def_zone)
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
			take_damage(PAIN, effect * blocked_mult(blocked))
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
