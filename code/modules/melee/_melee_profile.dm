/decl/melee_attack_profile
	abstract_type = /decl/melee_attack_profile
	/// A text identifier to display this attack profile.
	var/name
	/// How many turfs this sweep can hit, including the origin.
	var/strike_range = 1
	/// A string describing how to use this attack.
	var/usage_desc
	/// The maximum number of hits that can be performed in one attack before it ends early.
	/// If null or zero, overwritten to strike_range in Initialize.
	var/max_hits = 1

/decl/melee_attack_profile/Initialize()
	max_hits ||= strike_range
	. = ..()

/decl/melee_attack_profile/proc/get_all_candidate_turfs(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf, turf/direction_indicator_turf)
	return

/decl/melee_attack_profile/proc/can_target_turf(mob/user, turf/candidate, turf/last_turf)
	return isnull(last_turf) || candidate.Adjacent(last_turf)

/// Attempts to strike any atom on the turf `striking` using the item `weapon`.
/// Returns the hit atom.
/decl/melee_attack_profile/proc/strike_turf(mob/user, obj/item/weapon, turf/striking, turf/last_turf)
	var/marker_dir = last_turf ? get_dir(last_turf, striking) : get_dir(get_turf(user), striking)
	for(var/atom/movable/thing as anything in striking)
		if(!thing.simulated || !thing.density)
			continue
		if(!ismob(thing) && !(istype(thing, /obj/structure) && !(istype(thing, /obj/machinery))))
			continue
		if(thing.attackby(weapon, user))
			var/obj/effect/melee_marker/hit/marker = new(striking)
			marker.set_dir(marker_dir)
			return thing
	if(striking.density && striking.attackby(weapon, user))
		var/obj/effect/melee_marker/hit/marker = new(striking)
		marker.set_dir(marker_dir)
		return striking
	var/obj/effect/melee_marker/miss/marker = new(striking)
	marker.set_dir(marker_dir)
	return null

/decl/melee_attack_profile/proc/build_strike_turf_list(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf, turf/direction_indicator_turf)
	var/list/candidates = get_all_candidate_turfs(user, weapon, origin_turf, target_turf, direction_indicator_turf)
	if(length(candidates))
		var/turf/last_turf
		for(var/i = 1 to min(length(candidates), strike_range))
			var/turf/candidate = candidates[i]
			if(!can_target_turf(user, candidate, last_turf))
				break
			LAZYDISTINCTADD(., candidate)
			last_turf = candidate

/decl/melee_attack_profile/proc/can_perform(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf)
	return user.Adjacent(target_turf) && (target_turf == origin_turf || user.Adjacent(target_turf))

/decl/melee_attack_profile/proc/perform_attack(mob/user, obj/item/weapon, turf/origin_turf, turf/target_turf)
	if(!can_perform(user, weapon, origin_turf, target_turf))
		return FALSE

	var/list/strike_turfs = build_strike_turf_list(user, weapon, origin_turf, target_turf, weapon.get_melee_direction_indicator_turf())
	if(!length(strike_turfs))
		return FALSE
	var/atoms_hit = 0
	var/atom/last_hit_atom = null
	var/turf/last_turf = get_turf(user)
	for(var/turf/striking as anything in strike_turfs)
		last_hit_atom = strike_turf(user, weapon, striking, last_turf)
		if(last_hit_atom && ++atoms_hit >= max_hits)
			user.face_atom(last_hit_atom)
			return TRUE
		last_turf = striking
	return FALSE