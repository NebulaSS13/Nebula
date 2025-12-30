/turf/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	layer = PLATING_LAYER
	permit_ao = TRUE
	thermal_conductivity = 0.040
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

	var/const/TRENCH_DEPTH_PER_ACTION = 100

/turf/floor/Initialize(var/ml, var/floortype)

	if(_base_flooring)
		set_base_flooring(_base_flooring, skip_update = TRUE)

	. = ..(ml)

	set_turf_materials(material, skip_update = TRUE)

	if(istext(_flooring))
		_flooring = resolve_decl_uid_list(cached_json_decode(_flooring))
		if(!length(_flooring))
			_flooring = null

	if(!floortype && (ispath(_flooring) || islist(_flooring)))
		floortype = _flooring
	else
		floortype = null
	if(floortype)
		_flooring = null
		set_flooring(floortype, skip_update = TRUE)

	fill_to_zero_height() // try to refill turfs that act as fluid sources

	if(material || get_topmost_flooring())
		update_from_flooring(skip_update = ml)
		if(ml) // We skipped the update above to avoid updating our neighbors, but we need to update ourselves.
			lazy_update_icon()

/turf/floor/ChangeTurf(turf/N, tell_universe, force_lighting_update, keep_air, update_open_turfs_above, keep_height)
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/floor/Destroy()
	clear_flooring()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

/turf/floor/proc/fill_to_zero_height()
	var/my_height = get_physical_height()
	if(fill_reagent_type && my_height < 0 && (!reagents || !QDELING(reagents)) && REAGENT_TOTAL_VOLUME(reagents) < abs(my_height))
		var/reagents_to_add = abs(my_height) - REAGENT_TOTAL_VOLUME(reagents)
		add_to_reagents(fill_reagent_type, reagents_to_add, phase = MAT_PHASE_LIQUID)

/turf/floor/can_climb_from_below(var/mob/climber)
	return TRUE

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
	if(!QDELETED(src))
		fill_to_zero_height()
		update_floor_strings()

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

/turf/floor/get_footstep_sound(var/mob/stepper)
	var/decl/flooring/use_flooring = get_topmost_flooring()
	if(istype(use_flooring))
		return get_footstep_for_mob(use_flooring.footstep_type, stepper)
	return ..()

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

/turf/floor/Process()
	for(var/decl/flooring/flooring in get_all_flooring())
		if(flooring.has_environment_proc)
			return flooring.handle_environment_proc(src)
	return PROCESS_KILL

// In case a catwalk or other blocking item is destroyed.
/turf/floor/Exited(atom/movable/AM, atom/new_loc)
	. = ..()
	if(!is_processing)
		for(var/decl/flooring/flooring in get_all_flooring())
			if(flooring.has_environment_proc)
				START_PROCESSING(SSobj, src)
				break
	var/decl/flooring/print_flooring = get_topmost_flooring()
	print_flooring?.turf_exited(src, AM, new_loc)

// In case something of interest enters our turf.
/turf/floor/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	for(var/decl/flooring/flooring in get_all_flooring())
		if(flooring.has_environment_proc)
			if(!is_processing)
				START_PROCESSING(SSobj, src)
			flooring.handle_environment_proc(src)
			break
	var/decl/flooring/print_flooring = get_topmost_flooring()
	print_flooring?.turf_entered(src, AM, old_loc)

/turf/floor/get_plant_growth_rate()
	var/decl/flooring/flooring = get_topmost_flooring()
	return flooring ? flooring.growth_value : ..()

/turf/floor/Crossed(atom/movable/AM)
	var/decl/flooring/flooring = get_topmost_flooring()
	flooring?.turf_crossed(AM)
	return ..()

/turf/floor/can_show_coating_footprints(decl/material/contaminant = null)
	return ..() && get_topmost_flooring()?.can_show_coating_footprints(src, contaminant)
