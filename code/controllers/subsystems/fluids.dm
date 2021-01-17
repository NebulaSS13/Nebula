SUBSYSTEM_DEF(fluids)
	name = "Fluids"
	wait = 10
	flags = SS_NO_INIT

	var/next_fluid_act = 0
	var/fluid_act_delay = 15 // A bit longer than machines.

	var/list/active_fluids = list()
	var/list/water_sources = list()
	var/list/hygiene_props = list()

	var/tmp/list/processing_sources
	var/tmp/list/processing_fluids

	var/obj/equalizing_reagent_holder
	var/tmp/active_fluids_copied_yet = FALSE
	var/tmp/fluid_sources_copied_yet = FALSE
	var/af_index = 1
	var/fs_index = 1
	var/list/fluid_images = list()

	var/list/gurgles = list(
		'sound/effects/gurgle1.ogg',
		'sound/effects/gurgle2.ogg',
		'sound/effects/gurgle3.ogg',
		'sound/effects/gurgle4.ogg'
		)

/datum/controller/subsystem/fluids/New(start_timeofday)
	equalizing_reagent_holder = new
	equalizing_reagent_holder.unacidable = TRUE
	equalizing_reagent_holder.atom_flags |= (ATOM_FLAG_NO_TEMP_CHANGE|ATOM_FLAG_OPEN_CONTAINER|ATOM_FLAG_NO_REACT)
	equalizing_reagent_holder.create_reagents(FLUID_MAX_DEPTH * 9 * 3)
	..()

/datum/controller/subsystem/fluids/stat_entry()
	..("A:[active_fluids.len] S:[water_sources.len]")

/datum/controller/subsystem/fluids/fire(resumed = 0)

	if (!resumed)
		active_fluids_copied_yet = FALSE
		fluid_sources_copied_yet = FALSE
		af_index = 1
		fs_index = 1

	if(!fluid_sources_copied_yet)
		fluid_sources_copied_yet = TRUE
		processing_sources = water_sources.Copy()

	var/list/checked = list()
	while(fs_index <= processing_sources.len)

		var/turf/T = processing_sources[fs_index++]

		var/flooded_a_neighbor
		UPDATE_FLUID_BLOCKED_DIRS(T)
		for(var/spread_dir in GLOB.cardinal)
			if(T.fluid_blocked_dirs & spread_dir) 
				continue
			var/turf/next = get_step(T, spread_dir)
			if(!istype(next) || next.flooded) 
				continue
			UPDATE_FLUID_BLOCKED_DIRS(next)
			if((next.fluid_blocked_dirs & GLOB.reverse_dir[spread_dir]) || !next.CanFluidPass(spread_dir) || checked[next])
				continue
			checked[next] = TRUE
			flooded_a_neighbor = TRUE
			var/obj/effect/fluid/F = locate() in next
			if(!F)
				F = new /obj/effect/fluid(next)
			if(F.reagents.total_volume < FLUID_MAX_DEPTH)
				F.reagents.add_reagent(/decl/material/liquid/water, FLUID_MAX_DEPTH - F.reagents.total_volume)

		if(!flooded_a_neighbor)
			water_sources -= T

		if (MC_TICK_CHECK)
			return

	if (!active_fluids_copied_yet)
		active_fluids_copied_yet = TRUE
		processing_fluids = active_fluids.Copy()

	// We need to iterate through this list a few times, so we're using indexes instead of a while-truncate loop.
	checked.Cut()
	while (af_index <= processing_fluids.len)

		var/obj/effect/fluid/F = processing_fluids[af_index++]
		if(QDELETED(F))
			processing_fluids -= F
			continue

		var/turf/T = F.loc
		checked[T] = TRUE
		if(!T.CanFluidPass() || F.reagents.total_volume <= FLUID_EVAPORATION_POINT)
			qdel(F)
			continue

		if(T.density || isspaceturf(T) || istype(T, /turf/exterior))
			F.reagents.remove_any(max(FLUID_EVAPORATION_POINT-1, round(F.reagents.total_volume * 0.5)))
			if(F.reagents.total_volume <= FLUID_EVAPORATION_POINT)
				qdel(F)
			continue

		REMOVE_ACTIVE_FLUID(F) // This will be refreshed if our level changes at all in this iteration of the subsystem.
		UPDATE_FLUID_BLOCKED_DIRS(T)
		if(!(T.fluid_blocked_dirs & DOWN) && T.is_open() && T.has_gravity())
			var/turf/below = GetBelow(T)
			if(below)
				UPDATE_FLUID_BLOCKED_DIRS(below)
				if(!(below.fluid_blocked_dirs & UP))
					var/obj/effect/fluid/other = locate() in below
					if(!other)
						other = new(below)
					if(other && other.reagents.total_volume < FLUID_MAX_DEPTH)
						F.reagents.trans_to_holder(other.reagents, min(Floor(F.reagents.total_volume*0.5), FLUID_MAX_DEPTH - other.reagents.total_volume))
						continue
		
		if(F.reagents.total_volume > FLUID_PUDDLE)
			for(var/spread_dir in GLOB.cardinal)
				if(T.fluid_blocked_dirs & spread_dir)
					continue
				var/turf/neighbor_turf = get_step(T, spread_dir)
				if(!istype(neighbor_turf) || neighbor_turf.flooded)
					continue
				var/coming_from = GLOB.reverse_dir[spread_dir]
				UPDATE_FLUID_BLOCKED_DIRS(neighbor_turf)
				if((neighbor_turf.fluid_blocked_dirs & coming_from) || checked[neighbor_turf] || !neighbor_turf.CanFluidPass(coming_from))
					continue
				checked[neighbor_turf] = TRUE
				var/obj/effect/fluid/other = locate() in neighbor_turf.contents
				if(!other)
					if(F.reagents.total_volume >= 2)
						other = new /obj/effect/fluid(neighbor_turf)
						F.reagents.trans_to_holder(other.reagents, 1)
					else
						qdel(F)
						break

		if (MC_TICK_CHECK)
			return

	af_index = 1
	while (af_index <= processing_fluids.len)

		var/obj/effect/fluid/F = processing_fluids[af_index++]
		if (QDELETED(F))
			processing_fluids -= F
			continue

		// Equalize across our neighbors. Hardcoded here for performance reasons.
		if(!length(F.neighbors) || F.reagents.total_volume <= FLUID_PUDDLE)
			continue

		var/sufficient_delta = FALSE
		for(var/thing in F.neighbors)
			var/obj/effect/fluid/other = thing
			if(abs(F.reagents.total_volume - other.reagents.total_volume) > FLUID_PUDDLE)
				sufficient_delta = TRUE
				break

		F.last_flow_strength = 0
		var/setting_dir = 0
		if(sufficient_delta)
			equalizing_reagent_holder.reagents.clear_reagents()
			for(var/thing in F.neighbors)
				var/obj/effect/fluid/other = thing
				var/flow_amount = F.reagents.total_volume - other.reagents.total_volume
				if(F.last_flow_strength < flow_amount && flow_amount >= FLUID_PUSH_THRESHOLD)
					F.last_flow_strength = flow_amount
					setting_dir = get_dir(F, other)
				other.reagents.trans_to_holder(equalizing_reagent_holder.reagents, other.reagents.total_volume)
			F.reagents.trans_to_holder(equalizing_reagent_holder.reagents, F.reagents.total_volume)
			
			var/equalize_amt = round(equalizing_reagent_holder.reagents.total_volume / (length(F.neighbors)+1))
			for(var/thing in F.neighbors)
				var/obj/effect/fluid/other = thing
				equalizing_reagent_holder.reagents.trans_to_holder(other.reagents, equalize_amt)
			equalizing_reagent_holder.reagents.trans_to_holder(F.reagents, equalizing_reagent_holder.reagents.total_volume)

		F.set_dir(setting_dir)

		if (MC_TICK_CHECK)
			return 

/datum/controller/subsystem/fluids/StartLoadingMap()
	suspend()

/datum/controller/subsystem/fluids/StopLoadingMap()
	wake()
