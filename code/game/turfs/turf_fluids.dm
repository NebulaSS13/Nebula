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

/turf/proc/make_flooded()
	if(!flooded)
		flooded = TRUE
		for(var/obj/effect/fluid/F in src)
			qdel(F)
		update_icon()
		fluid_update()

/turf/is_flooded(var/lying_mob, var/absolute)
	return (flooded || (!absolute && check_fluid_depth(lying_mob ? FLUID_OVER_MOB_HEAD : FLUID_DEEP)))

/turf/check_fluid_depth(var/min)
	. = (get_fluid_depth() >= min)

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
	set waitfor = 0

	if(flooded)
		if(istype(flood_object))
			flick("ocean-bubbles", flood_object)
		return

	var/obj/effect/fluid/F = locate() in src
	if(istype(F))
		flick("bubbles",F)

/turf/fluid_update(var/ignore_neighbors)

	fluid_blocked_dirs = null
	fluid_can_pass = null

	// Wake up our neighbors.
	if(!ignore_neighbors)
		for(var/checkdir in GLOB.cardinal)
			var/turf/T = get_step(src, checkdir)
			if(T) T.fluid_update(1)

	// Wake up ourself!
	if(flooded)
		ADD_ACTIVE_FLUID_SOURCE(src)
		for(var/obj/effect/fluid/F in src)
			qdel(F)
	else
		REMOVE_ACTIVE_FLUID_SOURCE(src)
		for(var/obj/effect/fluid/F in src)
			ADD_ACTIVE_FLUID(F)
