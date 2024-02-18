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
		reagents.remove_any(amount)

/turf/proc/set_flooded(new_flooded, force = FALSE, skip_vis_contents_update = FALSE, mapload = FALSE)

	// Don't do unnecessary work.
	if(!force && new_flooded == flooded)
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
				add_vis_contents(src, flood_object)
	else if(!mapload)
		REMOVE_ACTIVE_FLUID_SOURCE(src)
		fluid_update() // We are now floodable, so wake up our neighbors.

/turf/is_flooded(var/lying_mob, var/absolute)
	return (flooded || (!absolute && check_fluid_depth(lying_mob ? FLUID_OVER_MOB_HEAD : FLUID_DEEP)))

/turf/check_fluid_depth(var/min)
	. = (get_fluid_depth() >= min)

/turf/proc/get_fluid_name()
	var/decl/material/mat = reagents?.get_primary_reagent_decl()
	return mat?.liquid_name || "liquid"

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
			var/turf/T = get_step(src, checkdir)
			if(T)
				T.fluid_update(TRUE)
	if(flooded)
		ADD_ACTIVE_FLUID_SOURCE(src)

/turf/proc/add_fluid(var/fluid_type, var/fluid_amount, var/defer_update)
	if(!reagents)
		create_reagents(FLUID_MAX_DEPTH)
	reagents.add_reagent(fluid_type, min(fluid_amount, FLUID_MAX_DEPTH - reagents.total_volume), defer_update = defer_update)

/turf/proc/get_physical_height()
	return 0

/turf/simulated/floor/get_physical_height()
	return flooring?.height || 0

/turf/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && fluids?.total_volume)
		fluids.touch_turf(src)
		for(var/atom/movable/AM as anything in get_contained_external_atoms())
			AM.fluid_act(fluids)

/turf/proc/remove_fluids(var/amount, var/defer_update)
	if(!reagents?.total_volume)
		return
	reagents.remove_any(amount, defer_update = defer_update)
	if(defer_update && !QDELETED(reagents))
		SSfluids.holders_to_update[reagents] = TRUE

/turf/proc/transfer_fluids_to(var/turf/target, var/amount, var/defer_update)
	if(!reagents?.total_volume)
		return
	if(!target.reagents)
		target.create_reagents(FLUID_MAX_DEPTH)
	reagents.trans_to_holder(target.reagents, min(reagents.total_volume, min(FLUID_MAX_DEPTH - target.reagents.total_volume, amount)), defer_update = defer_update)
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
				reagents.remove_reagent(round(moles * REAGENT_UNITS_PER_GAS_MOLE))
				update_air = TRUE
	if(update_air)
		air.update_values()
		return TRUE
	return FALSE

/turf/on_reagent_change()

	..()

	if(reagents?.total_volume)
		ADD_ACTIVE_FLUID(src)
		var/decl/material/primary_reagent = reagents.get_primary_reagent_decl()
		if(primary_reagent)
			last_slipperiness = primary_reagent.slipperiness
		if(!fluid_overlay)
			fluid_overlay = new(src, TRUE)
		fluid_overlay.update_icon()
		unwet_floor(FALSE)
	else
		QDEL_NULL(fluid_overlay)
		REMOVE_ACTIVE_FLUID(src)
		SSfluids.pending_flows -= src
		if(last_slipperiness > 0)
			wet_floor(last_slipperiness)

	for(var/checkdir in global.cardinal)
		var/turf/neighbor = get_step(src, checkdir)
		if(neighbor)
			ADD_ACTIVE_FLUID(neighbor)
