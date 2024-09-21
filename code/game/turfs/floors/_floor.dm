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
	var/flooring_override
	var/decl/flooring/base_flooring = /decl/flooring/plating
	var/decl/flooring/flooring

	var/const/TRENCH_DEPTH_PER_ACTION = 100

/turf/floor/Initialize(var/ml, var/floortype)

	if(base_flooring)
		base_flooring = GET_DECL(base_flooring)

	. = ..(ml)

	set_turf_materials(floor_material, skip_update = TRUE)

	if(!floortype && ispath(flooring))
		floortype = flooring
	if(floortype)
		set_flooring(GET_DECL(floortype), skip_update = TRUE)

	if(fill_reagent_type && get_physical_height() < 0)
		add_to_reagents(fill_reagent_type, abs(height))

	if(floor_material || flooring || base_flooring)
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

/turf/floor/Destroy()
	set_flooring(null)
	return ..()

/turf/floor/can_climb_from_below(var/mob/climber)
	return TRUE

/turf/floor/is_plating()
	return !istype(flooring) && !density

/turf/floor/get_base_movement_delay(var/travel_dir, var/mob/mover)
	return istype(flooring) ? flooring.get_movement_delay(travel_dir, mover) : ..()

/turf/floor/protects_atom(var/atom/A)
	return (A.level <= LEVEL_BELOW_PLATING && !is_plating()) || ..()

/turf/floor/on_reagent_change()
	. = ..()
	var/my_height = get_physical_height()
	if(!QDELETED(src) && fill_reagent_type && my_height < 0 && !QDELETED(reagents) && reagents.total_volume < abs(my_height))
		add_to_reagents(fill_reagent_type, abs(my_height) - reagents.total_volume)

/turf/floor/proc/set_base_flooring(var/new_base_flooring)
	if(ispath(new_base_flooring))
		new_base_flooring = GET_DECL(new_base_flooring)
	if(base_flooring != new_base_flooring)
		base_flooring = new_base_flooring
	if(!base_flooring)
		base_flooring = initial(base_flooring)
	base_flooring = GET_DECL(base_flooring)
	update_from_flooring(base_flooring)

/turf/floor/proc/get_topmost_flooring()
	if(istype(flooring))
		return flooring
	if(istype(base_flooring))
		return base_flooring

/turf/floor/proc/set_flooring(var/decl/flooring/newflooring, skip_update, place_product)

	if(flooring == newflooring)
		return

	if(istype(flooring))

		LAZYCLEARLIST(decals)
		for(var/obj/effect/decal/writing/W in src)
			qdel(W)

		flooring.on_remove()
		if(flooring.build_type && place_product)
			// If build type uses material stack, check for it
			// Because material stack uses different arguments
			// And we need to use build material to spawn stack
			if(ispath(flooring.build_type, /obj/item/stack/material))
				var/decl/material/M = GET_DECL(flooring.build_material)
				if(!M)
					CRASH("[src] at ([x], [y], [z]) cannot create stack because it has a bad build_material path: '[flooring.build_material]'")
				M.create_object(src, flooring.build_cost, flooring.build_type)
			else
				new flooring.build_type(src)

		if(flooring.has_environment_proc && is_processing)
			STOP_PROCESSING(SSobj, src)

		flooring = null
		set_floor_broken(skip_update = TRUE)
		set_floor_burned()

	flooring = newflooring
	flooring_override = null

	update_from_flooring((istype(flooring) ? flooring : base_flooring), skip_update)

/turf/floor/proc/update_from_flooring(var/decl/flooring/copy_from, skip_update)

	copy_from.update_turf_strings(src)
	layer      = copy_from.layer
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
	if(istype(flooring))
		return flooring.can_engrave
	if(istype(base_flooring))
		return base_flooring.can_engrave
	return can_engrave

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
	else if(istype(flooring))
		break_tile_to_plating()
	else
		physically_destroyed()

/turf/floor/get_footstep_sound(var/mob/caller)
	. = ..()
	if(!.)
		var/decl/flooring/use_flooring = get_topmost_flooring() || base_flooring
		if(istype(use_flooring))
			return get_footstep_for_mob(use_flooring.footstep_type)
		return get_footstep_for_mob(/decl/footsteps/blank)

/turf/floor/get_movable_alpha_mask_state(atom/movable/mover)
	. = ..() || (istype(flooring) ? flooring.get_movable_alpha_mask_state(mover) : null)

/turf/floor/dismantle_turf(devastated, explode, no_product)
	if(is_constructed_floor())
		return ..()
	return !!switch_to_base_turf()

/turf/floor/get_soil_color()
	if(istype(flooring))
		return flooring.dirt_color
	if(istype(base_flooring))
		return base_flooring.dirt_color
	return "#7c5e42"

/turf/floor/get_color()

	if(paint_color)
		return paint_color

	if(istype(flooring))
		if(flooring.color)
			return flooring.color
		var/decl/material/my_material = get_material()
		if(istype(my_material))
			return my_material.color
		return COLOR_WHITE

	if(istype(base_flooring))
		if(base_flooring.color)
			return base_flooring.color
		var/decl/material/my_material = get_material()
		if(istype(my_material))
			return my_material.color
		return COLOR_WHITE

	return color

/turf/floor/Process()
	if(istype(flooring) && flooring.has_environment_proc)
		return flooring.handle_environment_proc(src)
	if(istype(base_flooring) && base_flooring.has_environment_proc)
		return base_flooring.handle_environment_proc(src)
	return PROCESS_KILL

// In case a catwalk or other blocking item is destroyed.
/turf/floor/Exited(atom/movable/AM)
	. = ..()
	if(!is_processing)
		if(istype(flooring) && flooring.has_environment_proc)
			START_PROCESSING(SSobj, src)
		else if(istype(base_flooring) && base_flooring.has_environment_proc)
			START_PROCESSING(SSobj, src)

// In case something of interest enters our turf.
/turf/floor/Entered(atom/movable/AM)
	. = ..()
	if(istype(flooring))
		if(flooring.has_environment_proc)
			if(!is_processing)
				START_PROCESSING(SSobj, src)
			return flooring.handle_environment_proc(src)
	else if(istype(base_flooring) && base_flooring.has_environment_proc)
		if(!is_processing)
			START_PROCESSING(SSobj, src)
		return base_flooring.handle_environment_proc(src)

/turf/floor/get_plant_growth_rate()
	var/decl/flooring/floor = get_topmost_flooring()
	if(floor)
		return floor.growth_value
	return ..()
