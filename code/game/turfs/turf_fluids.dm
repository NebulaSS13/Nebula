/turf
	var/last_flow_strength = 0
	var/last_flow_dir = 0
	var/atom/movable/flood/fluid/fluid_overlay

/turf/Destroy()
	clear_fluid_overlay()
	. = ..()

/turf/proc/clear_fluid_overlay()
	if(fluid_overlay)
		fluid_overlay.forceMove(null)
		global.fluid_overlay_pool += fluid_overlay
		fluid_overlay = null

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

/turf/return_fluids(var/create_if_missing)
	if(!reagents && create_if_missing)
		create_reagents(FLUID_MAX_DEPTH)
	return reagents

/turf/proc/make_unflooded(var/force)
	if(force || flooded)
		flooded = FALSE
		REMOVE_ACTIVE_FLUID_SOURCE(src)
		remove_vis_contents(src, global.flood_object)
		fluid_update() // We are now floodable, so wake up our neighbors.

/turf/proc/make_flooded(var/force)
	if(force || !flooded)
		flooded = TRUE
		ADD_ACTIVE_FLUID_SOURCE(src)
		add_vis_contents(src, global.flood_object)
		if(reagents)
			reagents.clear_reagents()

/turf/is_flooded(var/lying_mob, var/absolute)
	return (flooded || (!absolute && check_fluid_depth(lying_mob ? FLUID_OVER_MOB_HEAD : FLUID_DEEP)))

/turf/check_fluid_depth(var/min)
	. = (get_fluid_depth() >= min)

/turf/get_fluid_depth()
	if(is_flooded(absolute=1))
		return FLUID_MAX_DEPTH
	if(reagents?.total_volume)
		return reagents.total_volume
	var/obj/structure/glass_tank/aquarium = locate() in contents
	if(aquarium && aquarium.reagents && aquarium.reagents.total_volume)
		return aquarium.reagents.total_volume * TANK_WATER_MULTIPLIER
	return 0

/turf/proc/show_bubbles()
	set waitfor = FALSE
	if(!flooded && istype(fluid_overlay))
		flick("bubbles", fluid_overlay)

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

/turf/proc/get_physical_height()
	return 0

/turf/simulated/floor/get_physical_height()
	return flooring?.height || 0

/turf/fluid_act(var/datum/reagents/fluids)
	fluids.touch(src)
	for(var/atom/movable/AM as anything in get_contained_external_atoms())
		AM.fluid_act(fluids)

/turf/airlock_crush()
	if(reagents)
		reagents.clear_reagents()

/turf/on_reagent_change()

	..()

	ADD_ACTIVE_FLUID(src)
	for(var/checkdir in global.cardinal)
		var/turf/neighbor = get_step(src, checkdir)
		if(neighbor)
			ADD_ACTIVE_FLUID(neighbor)

	if(reagents?.total_volume)
		if(!fluid_overlay)
			if(length(global.fluid_overlay_pool))
				fluid_overlay = global.fluid_overlay_pool[global.fluid_overlay_pool.len]
				global.fluid_overlay_pool.len--
				fluid_overlay.forceMove(src)
			else
				fluid_overlay = new(src)
		fluid_overlay.update_lighting = TRUE
		fluid_overlay.update_icon()
	else if(fluid_overlay)
		clear_fluid_overlay()

	if(reagents?.total_volume > 0)
		unwet_floor(FALSE)
	else
		wet_floor()

	if(reagents && reagents.total_volume <= 0)
		QDEL_NULL(reagents)

/turf/proc/wet_floor(var/wet_val = 1, var/overwrite = FALSE)
	return

/turf/proc/unwet_floor(var/check_very_wet = TRUE)
	return
