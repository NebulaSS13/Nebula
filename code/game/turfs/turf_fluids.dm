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
	if(reagents)
		remove_any_reagents(amount)

/turf/proc/displace_all_reagents()
	UPDATE_FLUID_BLOCKED_DIRS(src)
	var/list/spread_into_neighbors
	var/turf/neighbor
	var/coming_from
	for(var/spread_dir in global.cardinal)
		if(fluid_blocked_dirs & spread_dir)
			continue
		neighbor = get_step(src, spread_dir)
		if(!neighbor)
			continue
		UPDATE_FLUID_BLOCKED_DIRS(neighbor)
		coming_from = global.reverse_dir[spread_dir]
		if((neighbor.fluid_blocked_dirs & coming_from) || !neighbor.CanFluidPass(coming_from) || neighbor.is_flooded(absolute = TRUE) || !neighbor.CanFluidPass(global.reverse_dir[spread_dir]))
			continue
		LAZYDISTINCTADD(spread_into_neighbors, neighbor)
	if(length(spread_into_neighbors))
		var/spreading = round(REAGENT_TOTAL_VOLUME(reagents) / length(spread_into_neighbors))
		if(spreading > 0)
			for(var/turf/spread_into_turf as anything in spread_into_neighbors)
				reagents.trans_to_turf(spread_into_turf, spreading)
	reagents?.clear_reagents()

/turf/proc/set_flooded(new_flooded, force = FALSE, skip_vis_contents_update = FALSE, mapload = FALSE)

	// Don't do unnecessary work.
	if(!simulated || (!force && new_flooded == flooded))
		return

	// Remove our old overlay if necessary.
	if(flooded && new_flooded != flooded && !skip_vis_contents_update)
		var/flood_object = get_flood_overlay(flooded)
		if(flood_object)
			remove_vis_contents(src, flood_object)

	// Set our flood state.
	flooded = new_flooded
	if(flooded)
		QDEL_NULL(reagents)
		ADD_ACTIVE_FLUID_SOURCE(src)
		if(!skip_vis_contents_update)
			var/flood_object = get_flood_overlay(flooded)
			if(flood_object)
				add_vis_contents(flood_object)
	else if(!mapload)
		REMOVE_ACTIVE_FLUID_SOURCE(src)
		fluid_update() // We are now floodable, so wake up our neighbors.

/turf/is_flooded(var/lying_mob, var/absolute)
	if(flooded)
		return TRUE
	if(absolute)
		return FALSE
	var/required_depth = lying_mob ? FLUID_OVER_MOB_HEAD : FLUID_DEEP
	if(get_supporting_platform()) // Increase required depth if we are over the water.
		required_depth -= get_physical_height() // depth is negative, -= to increase required depth.
	return check_fluid_depth(required_depth)

/turf/check_fluid_depth(var/min = 1)
	. = (get_fluid_depth() >= min)

/turf/proc/get_fluid_name()
	var/decl/material/mat = reagents?.get_primary_reagent_decl()
	return mat.get_reagent_name(reagents, MAT_PHASE_LIQUID) || "liquid"

/turf/get_fluid_depth()
	if(is_flooded(absolute=1))
		return FLUID_MAX_DEPTH
	var/obj/structure/glass_tank/aquarium = locate() in contents
	if(aquarium)
		return REAGENT_TOTAL_VOLUME(aquarium.reagents) * TANK_WATER_MULTIPLIER
	return REAGENT_TOTAL_VOLUME(reagents)

/turf/proc/show_bubbles()
	set waitfor = FALSE
	// TODO: make flooding show bubbles.
	if(!flooded && fluid_overlay)
		flick("bubbles", fluid_overlay)

/turf/fluid_update(var/ignore_neighbors)
	fluid_blocked_dirs = null
	fluid_can_pass = null
	if(!ignore_neighbors)
		for(var/checkdir in global.cardinal)
			var/turf/T = get_step_resolving_mimic(src, checkdir)
			if(T)
				T.fluid_update(TRUE)
	if(flooded)
		ADD_ACTIVE_FLUID_SOURCE(src)
	else if(REAGENT_TOTAL_VOLUME(reagents) > FLUID_QDEL_POINT)
		ADD_ACTIVE_FLUID(src)

/turf/get_reagents()
	create_or_update_reagents(FLUID_MAX_DEPTH)
	return ..()

/turf/add_to_reagents(reagent_type, amount, data, safety = FALSE, defer_update = FALSE, phase = null)
	create_or_update_reagents(FLUID_MAX_DEPTH)
	return ..()

/turf/get_reagent_space()
	create_or_update_reagents(FLUID_MAX_DEPTH)
	return ..()

/turf/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && REAGENT_TOTAL_VOLUME(fluids))
		fluids.touch_turf(src, touch_atoms = FALSE) // Handled in fluid_act() below.
		// Wet items that are not supported on a platform or such.
		var/effective_volume = REAGENT_TOTAL_VOLUME(fluids)
		if(get_supporting_platform())
			// Depth is negative height, hence +=. TODO: positive heights? No idea how to handle that.
			effective_volume += get_physical_height()
		if(effective_volume > FLUID_PUDDLE)
			for(var/atom/movable/AM as anything in get_contained_external_atoms())
				if(!AM.submerged())
					continue
				AM.fluid_act(fluids)

/turf/proc/remove_fluids(var/amount, var/defer_update)
	if(!REAGENT_TOTAL_LIQUID_VOLUME(reagents))
		return
	remove_any_reagents(amount, defer_update = defer_update, removed_phases = MAT_PHASE_LIQUID)
	if(defer_update && !QDELETED(reagents))
		SSfluids.holders_to_update[reagents] = TRUE

/turf/proc/transfer_fluids_to(var/turf/target, var/amount, var/defer_update = TRUE)
	// No flowing of reagents without liquids, but this proc should not be called if liquids are not present regardless.
	if(!REAGENT_TOTAL_LIQUID_VOLUME(reagents))
		return
	target.create_or_update_reagents(FLUID_MAX_DEPTH)

	// We reference total_volume instead of total_liquid_volume here because the maximum volume limits of the turfs still respect solid volumes, and depth is still determined by total volume.
	reagents.trans_to_turf(target, min(REAGENT_TOTAL_VOLUME(reagents), min(REAGENT_MAXIMUM_VOLUME(target.reagents) - REAGENT_TOTAL_VOLUME(target.reagents), amount)), defer_update = defer_update)
	if(defer_update)
		if(!QDELETED(reagents))
			SSfluids.holders_to_update[reagents] = TRUE
		if(!QDELETED(target.reagents))
			SSfluids.holders_to_update[target.reagents] = TRUE

/turf/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	if(exposed_temperature >= FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE)
		vaporize_fuel(air)

/turf/proc/vaporize_fuel(datum/gas_mixture/air)
	if(!length(REAGENT_VOLUMES(reagents)) || !istype(air))
		return
	var/update_air = FALSE
	for(var/decl/material/reagent as anything in REAGENT_VOLUMES(reagents))
		if(reagent.gas_flags & XGM_GAS_FUEL)
			var/moles = round(REAGENT_VOLUME(reagents, reagent) / REAGENT_UNITS_PER_GAS_MOLE)
			if(moles > 0)
				air.adjust_gas(reagent.type, moles, FALSE)
				remove_from_reagents(reagent, round(moles * REAGENT_UNITS_PER_GAS_MOLE))
				update_air = TRUE
	if(update_air)
		air.update_values()
		return TRUE
	return FALSE

/turf/on_reagent_change()

	if(!(. = ..()))
		return

	if(REAGENT_TOTAL_LIQUID_VOLUME(reagents) < FLUID_SLURRY)
		dump_solid_reagents()

	if(REAGENT_TOTAL_VOLUME(reagents) > FLUID_QDEL_POINT)
		ADD_ACTIVE_FLUID(src)
		var/decl/material/primary_reagent = reagents.get_primary_reagent_decl()
		if(primary_reagent && (REAGENT_VOLUME(reagents, primary_reagent) >= primary_reagent.slippery_amount))
			last_slipperiness = primary_reagent.slipperiness
		else
			last_slipperiness = 0
		if(!fluid_overlay)
			fluid_overlay = new(src, TRUE)
		fluid_overlay.update_icon()
		unwet_floor(FALSE)
	else
		QDEL_NULL(fluid_overlay)
		reagents?.clear_reagents()
		REMOVE_ACTIVE_FLUID(src)
		SSfluids.pending_flows -= src
		if(last_slipperiness > 0)
			wet_floor(last_slipperiness)
		last_slipperiness = 0

	for(var/checkdir in global.cardinal)
		var/turf/neighbor = get_step_resolving_mimic(src, checkdir)
		if(REAGENT_TOTAL_VOLUME(neighbor?.reagents) > FLUID_QDEL_POINT)
			ADD_ACTIVE_FLUID(neighbor)

/turf/proc/dump_solid_reagents(datum/reagents/solids)
	if(!istype(solids))
		solids = reagents
	var/solid_volumes = REAGENT_SOLID_VOLUMES(solids)
	if(LAZYLEN(solid_volumes))
		var/list/matter_list = list()
		for(var/decl/material/reagent as anything in REAGENT_SOLID_VOLUMES(solid_volumes))
			var/reagent_amount = SOLID_VOLUME(solids, reagent)
			matter_list[reagent.type] = round(reagent_amount/REAGENT_UNITS_PER_MATERIAL_UNIT)
			solids.remove_reagent(reagent, reagent_amount, defer_update = TRUE, removed_phases = MAT_PHASE_SOLID)

		var/obj/item/debris/scraps/chemical/scraps = locate() in contents
		if(!istype(scraps) || scraps.get_total_matter() >= MAX_SCRAP_MATTER)
			scraps = new(src)
		if(!LAZYLEN(scraps.matter))
			scraps.matter = matter_list
		else
			for(var/mat_type in matter_list)
				scraps.matter[mat_type] += matter_list[mat_type]

		scraps.update_primary_material()
		solids.handle_update()