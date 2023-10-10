/turf/CanFluidPass(var/coming_from)
	if(flooded || density)
		return FALSE
	if(isnull(fluid_can_pass))
		fluid_can_pass = TRUE
		for(var/atom/movable/AM in src)
			if(AM.simulated && !AM.CanFluidPass(coming_from))
				fluid_can_pass = FALSE
				break
	return fluid_can_pass

/turf/proc/remove_fluid(var/amount = 0)
	var/obj/effect/fluid/F = locate() in src
	if(F)
		F.reagents.remove_any(amount)

/turf/return_fluid()
	return (locate(/obj/effect/fluid) in contents)

/turf/proc/make_unflooded(var/force)
	if(force || flooded)
		flooded = FALSE
		REMOVE_ACTIVE_FLUID_SOURCE(src)
		remove_vis_contents(src, global.flood_object)
		fluid_update() // We are now floodable, so wake up our neighbors.

/turf/proc/make_flooded(var/force)
	if(force || !flooded)
		flooded = TRUE
		for(var/obj/effect/fluid/fluid in src)
			qdel(fluid)
		ADD_ACTIVE_FLUID_SOURCE(src)
		add_vis_contents(src, global.flood_object)

/turf/is_flooded(var/lying_mob, var/absolute)
	return (flooded || (!absolute && check_fluid_depth(lying_mob ? FLUID_OVER_MOB_HEAD : FLUID_DEEP)))

/turf/check_fluid_depth(var/min)
	. = (get_fluid_depth() >= min)

/turf/proc/get_fluid_name()
	var/obj/effect/fluid/F = return_fluid()
	if(istype(F) && F.reagents?.primary_reagent)
		return F.reagents.get_primary_reagent_name()
	return "liquid"

/turf/get_fluid_depth()
	if(is_flooded(absolute=1))
		return FLUID_MAX_DEPTH
	var/obj/effect/fluid/F = return_fluid()
	if(istype(F))
		return F.reagents.total_volume
	var/obj/structure/glass_tank/aquarium = locate() in contents
	if(aquarium && aquarium.reagents && aquarium.reagents.total_volume)
		return aquarium.reagents.total_volume * TANK_WATER_MULTIPLIER
	return 0

/turf/proc/show_bubbles()
	set waitfor = FALSE
	if(flooded)
		return
	var/obj/effect/fluid/F = locate() in src
	if(istype(F))
		flick("bubbles",F)

/turf/fluid_update(var/ignore_neighbors)
	fluid_blocked_dirs = null
	fluid_can_pass = null
	if(!ignore_neighbors)
		for(var/checkdir in global.cardinal)
			var/turf/T = get_step(src, checkdir)
			if(T)
				T.fluid_update(TRUE)
	if(flooded)
		ADD_ACTIVE_FLUID_SOURCE(src)

/turf/proc/add_fluid(var/fluid_type, var/fluid_amount, var/defer_update)
	var/obj/effect/fluid/F = locate() in src
	if(!F)
		F = new(src)
	if(!QDELETED(F))
		F.reagents.add_reagent(fluid_type, min(fluid_amount, FLUID_MAX_DEPTH - F.reagents.total_volume), defer_update = defer_update)

/turf/proc/get_physical_height()
	return 0

/turf/simulated/floor/get_physical_height()
	return flooring?.height || 0

/turf/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && fluids?.total_volume)
		fluids.touch_turf(src)
		for(var/atom/movable/AM as anything in get_contained_external_atoms())
			AM.fluid_act(fluids)

/turf/proc/remove_fluids(var/amount, var/defer_update)
	var/obj/effect/fluid/F = locate() in src
	if(QDELETED(F) || !F.reagents?.total_volume)
		return
	F.reagents.remove_any(amount, defer_update = defer_update)
	if(defer_update && !QDELETED(F.reagents))
		SSfluids.holders_to_update[F.reagents] = TRUE

/turf/proc/transfer_fluids_to(var/turf/target, var/amount, var/defer_update)
	var/obj/effect/fluid/F = locate() in src
	if(!F || !F.reagents?.total_volume)
		return
	var/obj/effect/fluid/other = locate() in target
	if(!other)
		other = new(target)
	if(!QDELETED(other) && other.reagents)
		F.reagents.trans_to_holder(other.reagents, min(F.reagents.total_volume, min(FLUID_MAX_DEPTH - other.reagents.total_volume, amount)), defer_update = defer_update)
		if(defer_update)
			if(!QDELETED(F.reagents))
				SSfluids.holders_to_update[F.reagents] = TRUE
			if(!QDELETED(other.reagents))
				SSfluids.holders_to_update[other.reagents] = TRUE
