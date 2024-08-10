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
		var/spreading = round(reagents.total_volume / length(spread_into_neighbors))
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
	return (flooded || (!absolute && check_fluid_depth(lying_mob ? FLUID_OVER_MOB_HEAD : FLUID_DEEP)))

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
		return aquarium.reagents?.total_volume * TANK_WATER_MULTIPLIER
	return reagents?.total_volume || 0

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
	else if(reagents?.total_volume > FLUID_QDEL_POINT)
		ADD_ACTIVE_FLUID(src)

/turf/get_reagents()
	if(!reagents)
		create_reagents(FLUID_MAX_DEPTH)
	return ..()

/turf/add_to_reagents(reagent_type, amount, data, safety = FALSE, defer_update = FALSE)
	if(!reagents)
		create_reagents(FLUID_MAX_DEPTH)
	return ..()

/turf/get_reagent_space()
	if(!reagents)
		create_reagents(FLUID_MAX_DEPTH)
	return ..()

/turf/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && fluids?.total_volume)
		fluids.touch_turf(src)
		for(var/atom/movable/AM as anything in get_contained_external_atoms())
			AM.fluid_act(fluids)

/turf/proc/remove_fluids(var/amount, var/defer_update)
	if(!reagents?.total_liquid_volume)
		return
	remove_any_reagents(amount, defer_update = defer_update, removed_phases = MAT_PHASE_LIQUID)
	if(defer_update && !QDELETED(reagents))
		SSfluids.holders_to_update[reagents] = TRUE

/turf/proc/transfer_fluids_to(var/turf/target, var/amount, var/defer_update = TRUE)
	// No flowing of reagents without liquids, but this proc should not be called if liquids are not present regardless.
	if(!reagents?.total_liquid_volume)
		return
	if(!target.reagents)
		target.create_reagents(FLUID_MAX_DEPTH)

	// We reference total_volume instead of total_liquid_volume here because the maximum volume limits of the turfs still respect solid volumes, and depth is still determined by total volume.
	reagents.trans_to_turf(target, min(reagents.total_volume, min(target.reagents.maximum_volume - target.reagents.total_volume, amount)), defer_update = defer_update)
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
	if(!length(reagents?.reagent_volumes) || !istype(air))
		return
	var/update_air = FALSE
	for(var/rtype in reagents.reagent_volumes)
		var/decl/material/mat = GET_DECL(rtype)
		if(mat.gas_flags & XGM_GAS_FUEL)
			var/moles = round(reagents.reagent_volumes[rtype] / REAGENT_UNITS_PER_GAS_MOLE)
			if(moles > 0)
				air.adjust_gas(rtype, moles, FALSE)
				remove_from_reagents(round(moles * REAGENT_UNITS_PER_GAS_MOLE))
				update_air = TRUE
	if(update_air)
		air.update_values()
		return TRUE
	return FALSE

/turf/on_reagent_change()

	if(!(. = ..()))
		return

	if(reagents?.total_liquid_volume < FLUID_SLURRY)
		dump_solid_reagents()

	if(reagents?.total_volume > FLUID_QDEL_POINT)
		ADD_ACTIVE_FLUID(src)
		var/decl/material/primary_reagent = reagents.get_primary_reagent_decl()
		if(primary_reagent && (REAGENT_VOLUME(reagents, primary_reagent.type) >= primary_reagent.slippery_amount))
			last_slipperiness = primary_reagent.slipperiness
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

	for(var/checkdir in global.cardinal)
		var/turf/neighbor = get_step_resolving_mimic(src, checkdir)
		if(neighbor?.reagents?.total_volume > FLUID_QDEL_POINT)
			ADD_ACTIVE_FLUID(neighbor)

/turf/proc/dump_solid_reagents(datum/reagents/solids)
	if(!istype(solids))
		solids = reagents
	if(LAZYLEN(solids?.solid_volumes))
		var/list/matter_list = list()
		for(var/reagent_type in solids.solid_volumes)
			var/reagent_amount = solids.solid_volumes[reagent_type]
			matter_list[reagent_type] = round(reagent_amount/REAGENT_UNITS_PER_MATERIAL_UNIT)
			solids.remove_reagent(reagent_type, reagent_amount, defer_update = TRUE, removed_phases = MAT_PHASE_SOLID)

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