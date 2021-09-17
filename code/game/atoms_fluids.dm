/atom/proc/is_flooded(var/lying_mob, var/absolute)
	return

/atom/proc/fluid_act(var/datum/reagents/fluids)
	fluids.touch(src)
	if(reagents && fluids.total_volume >= FLUID_SHALLOW && ATOM_IS_OPEN_CONTAINER(src))
		reagents.trans_to_holder(fluids, reagents.total_volume)
		fluids.trans_to_holder(reagents, min(fluids.total_volume, reagents.maximum_volume))

/atom/proc/return_fluid()
	return null

/atom/proc/check_fluid_depth(var/min)
	return 0

/atom/proc/get_fluid_depth()
	return 0

/atom/proc/CanFluidPass(var/coming_from)
	return TRUE

/atom/movable/proc/is_fluid_pushable(var/amt)
	return simulated && !anchored

/atom/movable/is_flooded(var/lying_mob, var/absolute)
	var/turf/T = get_turf(src)
	return T?.is_flooded(lying_mob)

/atom/proc/submerged(depth)
	if(isnull(depth))
		var/turf/T = get_turf(src)
		if(!istype(T))
			return FALSE
		depth = T.get_fluid_depth()
	if(istype(loc, /mob))
		return depth >= FLUID_SHALLOW
	if(isturf(loc))
		return depth >= 3
	return depth >= FLUID_OVER_MOB_HEAD

/turf/submerged(depth)
	if(isnull(depth))
		depth = get_fluid_depth()
	return depth >= FLUID_OVER_MOB_HEAD

/atom/proc/fluid_update(var/ignore_neighbors)
	var/turf/T = get_turf(src)
	if(istype(T))
		T.fluid_update(ignore_neighbors)

/atom/movable/update_nearby_tiles(var/need_rebuild)
	UNLINT(. = ..(need_rebuild))
	fluid_update()