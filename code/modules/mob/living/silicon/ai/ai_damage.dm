/mob/living/silicon/ai/get_handled_damage_types()
	var/static/list/mob_damage_types = list(
		BRUTE,
		BURN,
		OXY
	)
	return mob_damage_types

/mob/living/silicon/ai/get_lethal_damage_types()
	var/static/list/lethal_damage_types = list(
		BRUTE,
		BURN,
		OXY
	)
	return lethal_damage_types

/mob/living/silicon/ai/update_health()
	..()
	if(status_flags & GODMODE)
		clear_damage(OXY)

/mob/living/silicon/ai/rejuvenate()
	..()
	add_ai_verbs(src)

// Returns percentage of AI's remaining backup capacitor charge (max_health - oxyloss).
/mob/living/silicon/ai/proc/backup_capacitor()
	var/current_max_health = get_max_health()
	return ((get_damage(OXY) - current_max_health) / current_max_health) * (-100)
