/turf/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	layer = PLATING_LAYER
	permit_ao = TRUE
	thermal_conductivity = 0.040
	heat_capacity = 10000
	explosion_resistance = 1
	turf_flags = TURF_IS_HOLOMAP_PATH
	initial_gas = GAS_STANDARD_AIRMIX
	zone_membership_candidate = TRUE
	open_turf_type = /turf/open/airless

	// Reagent to use to fill the turf.
	var/fill_reagent_type
	var/can_engrave = TRUE

	// Damage to flooring.
	// These are icon state suffixes, NOT booleans!
	var/_floor_broken
	var/_floor_burned

	// Flooring data.
	var/floor_icon_state_override

	// TODO:
	VAR_PROTECTED/decl/flooring/_base_flooring = /decl/flooring/plating
	VAR_PROTECTED/decl/flooring/_flooring

	var/const/TRENCH_DEPTH_PER_ACTION = 100

/turf/floor/Initialize(var/ml, var/floortype)

	if(_base_flooring)
		set_base_flooring(_base_flooring, skip_update = TRUE)

	. = ..(ml)

	set_turf_materials(floor_material, skip_update = TRUE)

	if(!floortype && ispath(_flooring))
		floortype = _flooring
	if(floortype)
		set_flooring(GET_DECL(floortype), skip_update = TRUE)

	if(fill_reagent_type && get_physical_height() < 0)
		add_to_reagents(fill_reagent_type, abs(height))

	if(floor_material || get_topmost_flooring())
		if(ml)
			queue_icon_update()
		else
			for(var/direction in global.alldirs)
				var/turf/target_turf = get_step_resolving_mimic(src, direction)
				if(istype(target_turf))
					if(TICK_CHECK) // not CHECK_TICK -- only queue if the server is overloaded
						target_turf.queue_icon_update()
					else
						target_turf.update_icon()
			update_icon()

/turf/floor/ChangeTurf(turf/N, tell_universe, force_lighting_update, keep_air, update_open_turfs_above, keep_height)
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/floor/Destroy()
	set_flooring(null)
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/turf/floor/can_climb_from_below(var/mob/climber)
	return TRUE

/turf/floor/proc/has_flooring()
	return istype(_flooring)

/turf/floor/is_plating()
	if(density)
		return FALSE
	var/decl/flooring/flooring = get_topmost_flooring()
	return (!istype(flooring) || flooring == get_base_flooring())

/turf/floor/get_base_movement_delay(var/travel_dir, var/mob/mover)
	var/decl/flooring/flooring = get_topmost_flooring()
	return istype(flooring) ? flooring.get_movement_delay(travel_dir, mover) : ..()

/turf/floor/protects_atom(var/atom/A)
	return (A.level <= LEVEL_BELOW_PLATING && !is_plating()) || ..()

/turf/floor/on_reagent_change()
	. = ..()
	var/my_height = get_physical_height()
	if(!QDELETED(src) && fill_reagent_type && my_height < 0 && !QDELETED(reagents) && reagents.total_volume < abs(my_height))
		add_to_reagents(fill_reagent_type, abs(my_height) - reagents.total_volume)

/turf/floor/proc/set_base_flooring(new_base_flooring, skip_update)
	if(ispath(new_base_flooring, /decl/flooring))
		new_base_flooring = GET_DECL(new_base_flooring)
	else if(!istype(new_base_flooring, /decl/flooring))
		new_base_flooring = null
	if(_base_flooring == new_base_flooring)
		return
	_base_flooring = new_base_flooring
	if(!_base_flooring) // We can never have a null base flooring.
		_base_flooring = GET_DECL(initial(_base_flooring)) || GET_DECL(/decl/flooring/plating)
	update_from_flooring(skip_update)

/turf/floor/proc/get_base_flooring()
	RETURN_TYPE(/decl/flooring)
	return istype(_base_flooring) ? _base_flooring : null

/turf/floor/proc/get_topmost_flooring()
	RETURN_TYPE(/decl/flooring)
	return istype(_flooring) ? _flooring : get_base_flooring()

/turf/floor/proc/set_flooring(var/decl/flooring/newflooring, skip_update, place_product)

	if(ispath(newflooring, /decl/flooring))
		newflooring = GET_DECL(newflooring)
	else if(!istype(newflooring, /decl/flooring))
		newflooring = null

	if(_flooring == newflooring)
		return FALSE

	if(istype(_flooring))

		LAZYCLEARLIST(decals)
		for(var/obj/effect/decal/writing/W in src)
			qdel(W)

		_flooring.on_remove()
		if(_flooring.build_type && place_product)
			// If build type uses material stack, check for it
			// Because material stack uses different arguments
			// And we need to use build material to spawn stack
			if(ispath(_flooring.build_type, /obj/item/stack/material))
				var/decl/material/M = GET_DECL(_flooring.build_material)
				if(!M)
					CRASH("[src] at ([x], [y], [z]) cannot create stack because it has a bad build_material path: '[_flooring.build_material]'")
				M.create_object(src, _flooring.build_cost, _flooring.build_type)
			else
				new _flooring.build_type(src)

		if(_flooring.has_environment_proc && is_processing)
			STOP_PROCESSING(SSobj, src)

		_flooring = null
		set_floor_broken(skip_update = TRUE)
		set_floor_burned()

	else if(is_processing)

		STOP_PROCESSING(SSobj, src)

	_flooring = newflooring
	floor_icon_state_override = null
	update_from_flooring(skip_update)

	return TRUE

/turf/floor/proc/update_from_flooring(skip_update)


	var/decl/flooring/copy_from = get_topmost_flooring()
	if(!istype(copy_from))
		return // this should never be the case

	update_floor_strings()

	layer      = copy_from.floor_layer
	turf_flags = copy_from.turf_flags
	z_flags    = copy_from.z_flags

	if(copy_from.turf_light_range || copy_from.turf_light_power || copy_from.turf_light_color)
		set_light(copy_from.turf_light_range, copy_from.turf_light_power, copy_from.turf_light_color)
	else
		set_light(0)

	if(z_flags & ZM_MIMIC_BELOW)
		enable_zmimic(z_flags)
	else
		disable_zmimic()

	if(copy_from.has_environment_proc && !is_processing)
		START_PROCESSING(SSobj, src)

	levelupdate()

	if(!skip_update)
		update_icon()
		for(var/dir in global.alldirs)
			var/turf/neighbor = get_step_resolving_mimic(src, dir)
			if(istype(neighbor))
				neighbor.update_icon()

/turf/floor/can_engrave()
	var/decl/flooring/flooring = get_topmost_flooring()
	return flooring ? flooring.can_engrave : can_engrave

/turf/floor/shuttle_ceiling
	name = "hull plating"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced_light"
	initial_gas = null

/turf/floor/shuttle_ceiling/air
	initial_gas = GAS_STANDARD_AIRMIX

/turf/floor/is_floor()
	return !density && !is_open()

/turf/floor/handle_universal_decay()
	if(!is_floor_burned())
		burn_tile()
	else if(has_flooring())
		break_tile_to_plating()
	else
		physically_destroyed()

/turf/floor/get_footstep_sound(var/mob/caller)
	. = ..()
	if(!.)
		var/decl/flooring/use_flooring = get_topmost_flooring()
		if(istype(use_flooring))
			return get_footstep_for_mob(use_flooring.footstep_type)
		return get_footstep_for_mob(/decl/footsteps/blank)

/turf/floor/get_movable_alpha_mask_state(atom/movable/mover)
	. = ..()
	if(!.)
		var/decl/flooring/flooring = get_topmost_flooring()
		return flooring?.get_movable_alpha_mask_state(mover)

/turf/floor/dismantle_turf(devastated, explode, no_product)
	if(is_constructed_floor())
		return ..()
	return !!switch_to_base_turf()

/turf/floor/get_soil_color()
	var/decl/flooring/flooring = get_topmost_flooring()
	return flooring ? flooring.dirt_color : "#7c5e42"

/turf/floor/get_color()
	if(paint_color)
		return paint_color
	var/decl/flooring/flooring = get_topmost_flooring()
	if(istype(flooring) && !isnull(flooring.color))
		return flooring.color
	var/decl/material/my_material = get_material()
	if(istype(my_material))
		return my_material.color
	return color

/turf/floor/proc/get_all_flooring()
	. = list()
	if(istype(_flooring))
		. += _flooring
	if(istype(_base_flooring))
		. += _base_flooring

/turf/floor/Process()
	for(var/decl/flooring/flooring in get_all_flooring())
		if(flooring.has_environment_proc)
			return flooring.handle_environment_proc(src)
	return PROCESS_KILL

// In case a catwalk or other blocking item is destroyed.
/turf/floor/Exited(atom/movable/AM)
	. = ..()
	if(!is_processing)
		for(var/decl/flooring/flooring in get_all_flooring())
			if(flooring.has_environment_proc)
				START_PROCESSING(SSobj, src)
				break

// In case something of interest enters our turf.
/turf/floor/Entered(atom/movable/AM)
	. = ..()
	for(var/decl/flooring/flooring in get_all_flooring())
		if(flooring.has_environment_proc)
			if(!is_processing)
				START_PROCESSING(SSobj, src)
			flooring.handle_environment_proc(src)
			break

/turf/floor/get_plant_growth_rate()
	var/decl/flooring/flooring = get_topmost_flooring()
	return flooring ? flooring.growth_value : ..()
