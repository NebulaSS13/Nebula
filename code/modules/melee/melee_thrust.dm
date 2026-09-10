/decl/melee_attack_profile/thrust
	name = "thrust"
	strike_range = 2
	usage_desc = "Left click and drag to a distant turf, then release to perform a thrust attack."

/decl/melee_attack_profile/thrust/can_perform(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf)
	return get_dist(get_turf(user), target_turf) > 1

/decl/melee_attack_profile/thrust/get_all_candidate_turfs(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf, turf/direction_indicator_turf)
	var/sanity = strike_range*2
	var/turf/check_turf = get_turf(user)
	while(check_turf != target_turf)
		check_turf = get_step_towards(check_turf, target_turf)
		if(check_turf)
			LAZYADD(., check_turf)
		else
			break
		sanity--
		if(sanity <= 0)
			return null // Something is potentially busted.
