/turf/proc/switch_to_base_turf(keep_air)
	var/base_turf = get_base_turf_by_area(src)
	if(base_turf && type != base_turf)
		return ChangeTurf(base_turf, keep_air = keep_air)
	return src

/turf/proc/dismantle_turf(devastated, explode, no_product, keep_air = TRUE)
	var/turf/new_turf = switch_to_base_turf(keep_air)
	if(!no_product && istype(new_turf) && !new_turf.is_open() && !(locate(/obj/structure/lattice) in new_turf))
		new /obj/structure/lattice(new_turf)
	return !!new_turf

/turf/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	return dismantle_turf(TRUE)

// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	if (above)
		above.update_mimic()

// Updates open turfs above this one to use its open_turf_type
/turf/proc/update_open_above(var/restrict_type, var/respect_area = TRUE)
	if(!HasAbove(src.z))
		return
	var/turf/above = src
	while ((above = GetAbove(above)))
		if(!above.is_open())
			break
		if(!restrict_type || istype(above, restrict_type))
			if(respect_area)
				var/area/A = get_area(above)
				above.ChangeTurf(A?.open_turf || open_turf_type, keep_air = TRUE, update_open_turfs_above = FALSE)
			else
				above.ChangeTurf(open_turf_type, keep_air = TRUE, update_open_turfs_above = FALSE)

/turf/proc/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE, var/update_open_turfs_above = TRUE, var/keep_height = FALSE)
	if (!N)
		return

	// Spawning space in the middle of a multiz stack should just spawn an open turf.
	if(ispath(N, /turf/space))
		var/turf/below = GetBelow(src)
		if(istype(below) && !isspaceturf(below))
			var/area/A = get_area(src)
			N = A?.open_turf || open_turf_type || /turf/open

	if (!(atom_flags & ATOM_FLAG_INITIALIZED))
		return new N(src)

	// Track a number of old values for the purposes of raising
	// state change events after changing the turf to the new type.
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
	var/old_open_turf_type =   open_turf_type
	var/old_affecting_heat_sources = affecting_heat_sources
	var/old_height =           get_physical_height()
	var/old_alpha_mask_state = get_movable_alpha_mask_state(null)

	var/old_ambience =         ambient_light
	var/old_ambience_mult =    ambient_light_multiplier
	var/old_ambient_light_old_r = ambient_light_old_r
	var/old_ambient_light_old_g = ambient_light_old_g
	var/old_ambient_light_old_b = ambient_light_old_b

	var/old_zone_membership_candidate = zone_membership_candidate

	// Create a copy of the old air value to apply.
	var/datum/gas_mixture/old_air
	if(keep_air)
		// Bypass calling return_air to avoid creating a direct reference to zone air.
		if(zone)
			c_copy_air()
			old_air = air
		else
			old_air = return_air()

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
	if(keep_air && W.can_inherit_air)
		W.air = old_air
	if(old_fire)
		if(W.simulated)
			W.fire = old_fire
		else if(old_fire)
			qdel(old_fire)

	if(old_flooded != W.flooded)
		set_flooded(old_flooded)

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

	// In case the turf isn't marked for update in Initialize (e.g. space), we call this to create any unsimulated edges necessary.
	if(W.zone_membership_candidate != old_zone_membership_candidate)
		SSair.mark_for_update(src)

	// we check the var rather than the proc, because area outside values usually shouldn't be set on turfs
	W.last_outside_check = OUTSIDE_UNCERTAIN
	if(W.is_outside != old_outside)
		// This will check the exterior atmos participation of this turf and all turfs connected by open space below.
		W.set_outside(old_outside, skip_weather_update = TRUE)
	else if(HasBelow(z) && (W.is_open() != old_is_open)) // Otherwise, we do it here if the open status of the turf has changed.
		var/turf/checking = src
		while(HasBelow(checking.z))
			checking = GetBelow(checking)
			if(!isturf(checking))
				break
			checking.update_external_atmos_participation()
			if(!checking.is_open())
				break

	W.update_weather(force_update_below = W.is_open() != old_is_open)

	if(keep_height)
		W.set_physical_height(old_height)

	if(update_open_turfs_above)
		update_open_above(old_open_turf_type)

	if(old_alpha_mask_state != get_movable_alpha_mask_state(null))
		for(var/atom/movable/AM as anything in W)
			AM.update_turf_alpha_mask()

/turf/proc/transport_properties_from(turf/other, transport_air)
	if(transport_air && can_inherit_air && (other.zone || other.air))
		if(!air)
			make_air()
		air.copy_from(other.zone ? other.zone.air : other.air)
		other.zone?.remove(other)
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

/turf/floor/transport_properties_from(turf/floor/other)
	if(!..())
		return FALSE

	set_flooring(other.flooring)
	set_floor_broken(other._floor_broken, TRUE)
	set_floor_burned(other._floor_burned)
	return TRUE

/turf/wall/transport_properties_from(turf/wall/other)
	if(!..())
		return FALSE

	paint_color = other.paint_color
	stripe_color = other.stripe_color

	material = other.material
	reinf_material = other.reinf_material
	girder_material = other.girder_material

	floor_type = other.floor_type
	construction_stage = other.construction_stage

	damage = other.damage

	// Do not set directly to other.can_open since it may be in the WALL_OPENING state.
	if(other.can_open)
		can_open = WALL_CAN_OPEN

	update_material()
	return TRUE
