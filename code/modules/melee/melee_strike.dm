// Single-tile melee attack; effectively a fallback for a clickdrag attack.
/decl/melee_attack_profile/strike
	name = "strike"
	usage_desc = "Left click and hold on a nearby turf, then release to perform a strike attack."

/decl/melee_attack_profile/strike/can_perform(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf)
	return ..() && origin_turf == target_turf && target_turf != get_turf(user)

/decl/melee_attack_profile/strike/get_all_candidate_turfs(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf, turf/direction_indicator_turf)
	return list(target_turf)

/decl/melee_attack_profile/strike/can_target_turf(mob/user, turf/candidate, turf/last_turf)
	return ..() && user.Adjacent(candidate)
