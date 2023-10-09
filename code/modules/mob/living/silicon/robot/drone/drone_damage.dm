//Redefining some drone procs, since drones can't be repaired and really shouldn't take component damage.
/mob/living/silicon/robot/drone/get_handled_damage_types()
	var/static/list/mob_damage_types = list(
		BRUTE = BRUTE,
		BURN  = BURN
	)
	return mob_damage_types
