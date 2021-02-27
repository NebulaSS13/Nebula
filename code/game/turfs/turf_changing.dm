/turf/proc/ReplaceWithLattice(var/material)
	var base_turf = get_base_turf_by_area(src);
	if(type != base_turf)
		src.ChangeTurf(get_base_turf_by_area(src))
	if(!locate(/obj/structure/lattice) in src)
		new /obj/structure/lattice(src, material)

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)
// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	if (above)
		above.update_mimic()

/turf/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	. = TRUE

/turf/proc/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE)

	if (!N)
		return

	if(ispath(N, /turf/space))
		var/turf/below = GetBelow(src)
		if(istype(below) && !isspaceturf(below))
			N = /turf/simulated/open

	var/old_air =       air
	var/old_fire =      fire
	var/old_above =     above
	var/old_opacity =   opacity
	var/old_density =   density
	var/old_prev_type = prev_type

	changing_turf = TRUE

	qdel(src)
	var/turf/W = new N(src)

	above = old_above
	prev_type = old_prev_type

	if(keep_air)
		W.air = old_air
	if(old_fire)
		if(ispath(N, /turf/simulated))
			W.fire = old_fire
		else if(old_fire)
			qdel(old_fire)

	if(tell_universe)
		GLOB.universe.OnTurfChange(W)

	. = W
	W.post_change()

	GLOB.turf_changed_event.raise_event(W, old_density, W.density, old_opacity, W.opacity)
	if(W.density != old_density)
		GLOB.density_set_event.raise_event(W, old_density, W.density)

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0
	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	if(other.decals)
		src.decals = other.decals.Copy()
		src.update_icon()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1

/turf/simulated/wall/transport_properties_from(turf/simulated/wall/other)
	if(!..())
		return 0
	paint_color = other.paint_color
	return 1

//No idea why resetting the base appearence from New() isn't enough, but without this it doesn't work
/turf/simulated/shuttle/wall/corner/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()
