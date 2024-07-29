/atom/proc/is_flooded(var/lying_mob, var/absolute)
	return

/atom/proc/fluid_act(var/datum/reagents/fluids)
	SHOULD_CALL_PARENT(TRUE)
	// TODO: fix food open container behavior jesus christ
	if(reagents && reagents != fluids && fluids?.total_volume >= FLUID_SHALLOW && ATOM_IS_OPEN_CONTAINER(src) && !istype(src, /obj/item/food))
		reagents.trans_to_holder(fluids, reagents.total_volume)
		fluids.trans_to_holder(reagents, min(fluids.total_volume, reagents.maximum_volume))

/atom/proc/check_fluid_depth(var/min = 1)
	return 0

/atom/proc/get_fluid_depth()
	return 0

/atom/proc/CanFluidPass(var/coming_from)
	return TRUE

/atom/movable/proc/is_fluid_pushable(var/amt)
	return simulated && !anchored

/atom/movable/is_flooded(var/lying_mob, var/absolute)
	var/turf/T = get_turf(src)
	return T?.is_flooded(lying_mob, absolute)

/atom/proc/submerged(depth)
	if(isnull(depth))
		var/turf/T = get_turf(src)
		if(!istype(T))
			return FALSE
		depth = T.get_fluid_depth()
	if(ismob(loc))
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
