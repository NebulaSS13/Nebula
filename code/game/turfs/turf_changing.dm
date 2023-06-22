/turf/proc/ReplaceWithLattice(var/material)
	var/base_turf = get_base_turf_by_area(src)
	if(base_turf && type != base_turf)
		. = ChangeTurf(base_turf)
	else
		. = src
	if(!(locate(/obj/structure/lattice) in .))
		new /obj/structure/lattice(., material)

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

	// Spawning space in the middle of a multiz stack should just spawn an open turf.
	if(ispath(N, /turf/space))
		var/turf/below = GetBelow(src)
		if(istype(below) && !isspaceturf(below))
			var/area/A = get_area(src)
			N = A?.open_turf || open_turf_type || /turf/simulated/open

	if (!(atom_flags & ATOM_FLAG_INITIALIZED))
		return new N(src)

	// Track a number of old values for the purposes of raising
	// state change events after changing the turf to the new type.
	var/old_air =              air
	var/old_fire =             fire
	var/old_above =            above
	var/old_opacity =          opacity
	var/old_density =          density
	var/old_corners =          corners
	var/old_prev_type =        prev_type
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_dynamic_lighting = TURF_IS_DYNAMICALLY_LIT_UNSAFE(src)
	var/old_flooded =          flooded
	var/old_outside =          is_outside
	var/old_is_open =          is_open()
	var/old_affecting_heat_sources = affecting_heat_sources

	var/old_ambience =         ambient_light
	var/old_ambience_mult =    ambient_light_multiplier
	var/old_ambient_light_old_r = ambient_light_old_r
	var/old_ambient_light_old_g = ambient_light_old_g
	var/old_ambient_light_old_b = ambient_light_old_b

	changing_turf = TRUE


	qdel(src)
	. = new N(src)

	var/turf/W = .
	W.above =            old_above     // Multiz ref tracking.
	W.prev_type =        old_prev_type // Shuttle transition turf tracking.

	W.affecting_heat_sources = old_affecting_heat_sources

	if (permit_ao)
		regenerate_ao()

	// Update ZAS, atmos and fire.
	if(keep_air)
		W.air = old_air
	if(old_fire)
		if(istype(W, /turf/simulated))
			W.fire = old_fire
		else if(old_fire)
			qdel(old_fire)

	if(isnull(W.flooded) && old_flooded != W.flooded)
		if(old_flooded && !W.density)
			W.make_flooded()
		else
			W.make_unflooded()

	// Raise appropriate events.
	W.post_change()
	if(tell_universe)
		global.universe.OnTurfChange(W)

	if(W.density != old_density)
		RAISE_EVENT(/decl/observ/density_set, W, old_density, W.density)

	// lighting stuff

	affecting_lights = old_affecting_lights
	corners = old_corners

	lighting_overlay = old_lighting_overlay

	recalc_atom_opacity()

	ambient_light_old_r = old_ambient_light_old_r
	ambient_light_old_g = old_ambient_light_old_g
	ambient_light_old_b = old_ambient_light_old_b

	if (old_ambience != ambient_light || old_ambience_mult != ambient_light_multiplier)
		update_ambient_light(FALSE)

	var/tidlu = TURF_IS_DYNAMICALLY_LIT_UNSAFE(src)
	if ((old_opacity != opacity) || (tidlu != old_dynamic_lighting) || force_lighting_update)
		reconsider_lights()

	if (tidlu != old_dynamic_lighting)
		if (tidlu)
			lighting_build_overlay()
		else
			lighting_clear_overlay()

	// end of lighting stuff

	// we check the var rather than the proc, because area outside values usually shouldn't be set on turfs
	W.last_outside_check = OUTSIDE_UNCERTAIN
	if(W.is_outside != old_outside)
		W.set_outside(old_outside, skip_weather_update = TRUE)
	W.update_weather(force_update_below = W.is_open() != old_is_open)

/turf/proc/transport_properties_from(turf/other)
	if(other.zone)
		if(!air)
			make_air()
		air.copy_from(other.zone.air)
		other.zone.remove(other)
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

/turf/simulated/floor/transport_properties_from(turf/simulated/floor/other)
	if(!..())
		return FALSE

	broken = other.broken
	burnt = other.burnt
	if(broken || burnt)
		queue_icon_update()
	set_flooring(other.flooring)
	return TRUE

/turf/simulated/wall/transport_properties_from(turf/simulated/wall/other)
	if(!..())
		return FALSE

	paint_color = other.paint_color
	stripe_color = other.stripe_color

	material = other.material
	reinf_material = other.material
	girder_material = other.girder_material

	floor_type = other.floor_type
	construction_stage = other.construction_stage

	damage = other.damage

	// Do not set directly to other.can_open since it may be in the WALL_OPENING state.
	if(other.can_open)
		can_open = WALL_CAN_OPEN

	update_material()
	return TRUE

//No idea why resetting the base appearance from New() isn't enough, but without this it doesn't work
/turf/simulated/shuttle/wall/corner/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()
