/decl/ability_targeting
	abstract_type = /decl/ability_targeting
	/// If set, this ability is applied to a square of this radius.
	var/effect_radius         = 0
	/// Set to except the inner space of the spell from target checks.
	var/effect_inner_radius   = -1
	/// If set, user will be excepted from targets.
	var/user_is_immune        = FALSE
	/// If set, this ability will never target our faction.
	var/faction_immune        = FALSE
	/// If set, this ability will only target our faction.
	var/faction_only          = FALSE
	/// If set, this ability will resolve targets to turfs before doing any assessment or targetting.
	var/target_turf           = TRUE
	/// If set along with target turf type, will include dense turfs.
	var/ignore_dense_turfs    = TRUE
	/// If set along target turf type, will include space turfs.
	var/ignore_space_turfs    = FALSE

/decl/ability_targeting/proc/get_effect_radius(mob/user, atom/hit_target, list/metadata)
	return effect_radius

/// This proc exists so that subtypes can override it and take advantage of the speed benefits of `for(var/mob in range())` and similar optimizations.
/// It should ONLY ever be called in get_affected().
/decl/ability_targeting/proc/get_affected_atoms(atom/center, new_effect_radius)
	PROTECTED_PROC(TRUE)
	. = list()
	for(var/atom/target in range(center, new_effect_radius))
		. += target

/decl/ability_targeting/proc/get_affected(mob/user, atom/hit_target, list/metadata, decl/ability/ability, obj/item/projectile/ability/projectile)
	if(effect_radius <= 0)
		return validate_target(user, hit_target, metadata, ability) ? list(hit_target) : null
	var/atom/center = projectile || hit_target
	var/new_effect_radius = get_effect_radius(user, hit_target, metadata)
	var/list/except_atoms = effect_inner_radius >= 0 ? range(effect_inner_radius, center) : null
	var/list/target_candidates = get_affected_atoms(center, new_effect_radius)
	for(var/atom/target in except_atoms ? target_candidates - except_atoms : target_candidates) // sloooooow...
		if(validate_target(user, target, metadata, ability))
			LAZYADD(., target)

/decl/ability_targeting/proc/resolve_initial_target(atom/target)
	if(target_turf)
		return get_turf(target)
	return target

/decl/ability_targeting/proc/validate_initial_target(mob/user, atom/target, list/metadata, decl/ability/ability)
	return validate_target(user, target, metadata, ability)

/decl/ability_targeting/proc/validate_target(mob/user, atom/target, list/metadata, decl/ability/ability)
	if(target == user && !user_is_immune)
		return FALSE
	if(target_turf && !isturf(target))
		return FALSE
	if(user.faction)
		if(faction_immune && ismob(target))
			var/mob/target_mob = target
			if(target_mob.faction == user.faction)
				return FALSE
		if(faction_only)
			if(!ismob(target))
				return FALSE
			var/mob/target_mob = target
			if(target_mob.faction != user.faction)
				return FALSE
	else if(faction_only)
		return FALSE
	if(isturf(target))
		if(ignore_dense_turfs && target.density)
			return FALSE
		if(ignore_space_turfs && istype(target, /turf/space))
			return FALSE
	return TRUE

/decl/ability_targeting/clear_turf
	ignore_dense_turfs = TRUE

/decl/ability_targeting/clear_turf/validate_target(mob/user, atom/target, list/metadata, decl/ability/ability)
	. = ..() && isturf(target)
	if(.)
		var/turf/target_turf = target
		return !target_turf.contains_dense_objects(user)

/decl/ability_targeting/living_mob
	target_turf               = FALSE

/decl/ability_targeting/living_mob/validate_target(mob/user, atom/target, list/metadata, decl/ability/ability)
	. = ..() && isliving(target)
	if(.)
		var/mob/living/victim = target
		return victim.simulated
