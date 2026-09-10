/decl/melee_attack_profile/sweep
	name = "sweep"
	strike_range = 8
	usage_desc = "Left click and drag from one nearby turf to another nearby turf, then release to perform a sweep attack."

/decl/melee_attack_profile/sweep/can_perform(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf)
	return ..() && origin_turf != target_turf && get_turf(user) != target_turf && get_turf(user) != origin_turf

/decl/melee_attack_profile/sweep/can_target_turf(mob/user, turf/candidate, turf/last_turf)
	return ..() && get_dist(get_turf(user), candidate) == 1 && user.Adjacent(candidate)

/decl/melee_attack_profile/sweep/get_all_candidate_turfs(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf, turf/direction_indicator_turf)

	var/turf/user_turf = get_turf(user)
	if(!direction_indicator_turf || origin_turf == target_turf || direction_indicator_turf == user_turf || get_dist(user_turf, direction_indicator_turf) != 1 || get_dist(user_turf, origin_turf) != 1 || get_dist(user_turf, target_turf) != 1)
		return null
	if(direction_indicator_turf == target_turf)
		return list(origin_turf, target_turf)

	// Check if we should sweep clockwise or counterclockwise.
	// If someone knows trig/modulo math/etc to do this easier, please do so, we could not work it out.
	var/end_dir           = get_dir(user_turf, target_turf)
	var/check_dir         = get_dir(user_turf, origin_turf)
	var/check_angle       = dir2angle(check_dir)
	var/middle_angle      = dir2angle(get_dir(user_turf, direction_indicator_turf))
	var/end_angle         = dir2angle(end_dir)
	var/start_less_middle = check_angle  < middle_angle
	var/start_less_end    = check_angle  < end_angle
	var/middle_less_end   = middle_angle < end_angle
	var/rot_offset
	if(                                                                \
		(!start_less_middle && !start_less_end && !middle_less_end) || \
		( start_less_middle &&  start_less_end && !middle_less_end) || \
		(!start_less_middle &&  start_less_end &&  middle_less_end)    \
	)
		rot_offset = -45
	else
		rot_offset = 45

	. = list()
	var/sanity = 8 // If we do more than 8 steps, something has broken.
	var/turf/check_turf
	while(check_turf != target_turf)
		check_turf = get_step(user_turf, check_dir)
		if(check_turf)
			. += check_turf
		check_angle += rot_offset
		check_dir = angle2dir(check_angle)
		sanity--
		if(sanity <= 0)
			return null // Something is very busted.
