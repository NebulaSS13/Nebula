SUBSYSTEM_DEF(fluids)
	name = "Fluids"
	wait = 1 SECOND
	priority = SS_PRIORITY_FLUIDS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT // So we can flush our queued activity during lobby setup on ocean maps.

	var/tmp/list/water_sources =       list()
	var/tmp/fluid_sources_copied_yet = FALSE
	var/tmp/list/processing_sources

	var/tmp/list/pending_flows =       list()
	var/tmp/flows_copied_yet =         FALSE
	var/tmp/list/processing_flows

	var/tmp/list/holders_to_update =   list()
	var/tmp/holders_copied_yet =       FALSE
	var/tmp/list/processing_holders

	var/tmp/list/active_fluids =       list()
	var/tmp/active_fluids_copied_yet = FALSE
	var/tmp/list/processing_fluids

	var/tmp/list/checked_targets =     list()
	var/tmp/list/gurgles =             list(
		'sound/effects/gurgle1.ogg',
		'sound/effects/gurgle2.ogg',
		'sound/effects/gurgle3.ogg',
		'sound/effects/gurgle4.ogg'
	)

/datum/controller/subsystem/fluids/stat_entry()
	..("A:[active_fluids.len] S:[water_sources.len]")

/datum/controller/subsystem/fluids/fire(resumed = 0)

	// Predeclaring a bunch of vars for performance purposes.
	var/turf/other_fluid_holder        = null
	var/turf/current_fluid_holder      = null
	var/datum/reagents/reagent_holder  = null
	var/list/candidates                = null
	var/turf/neighbor                  = null
	var/turf/lowest_neighbor           = null

	var/removing =                       0
	var/spread_dir =                     0
	var/coming_from =                    0
	var/flow_amount =                    0
	var/current_depth =                  0
	var/current_turf_depth =             0
	var/neighbor_depth =                 0
	var/lowest_neighbor_flow =           0
	var/flooded_a_neighbor =             FALSE
	var/lowest_neighbor_depth =          INFINITY

	if(!resumed)
		active_fluids_copied_yet = FALSE
		holders_copied_yet =       FALSE
		flows_copied_yet =         FALSE
		fluid_sources_copied_yet = FALSE
		checked_targets.Cut()

	if(!fluid_sources_copied_yet)
		fluid_sources_copied_yet = TRUE
		processing_sources = water_sources.Copy()

	while(processing_sources.len)

		current_fluid_holder = processing_sources[processing_sources.len]
		processing_sources.len--

		flooded_a_neighbor = FALSE
		UPDATE_FLUID_BLOCKED_DIRS(current_fluid_holder)
		for(spread_dir in global.cardinal)
			if(current_fluid_holder.fluid_blocked_dirs & spread_dir)
				continue
			neighbor = get_step(current_fluid_holder, spread_dir)
			if(!istype(neighbor) || neighbor.flooded)
				continue
			UPDATE_FLUID_BLOCKED_DIRS(neighbor)
			if((neighbor.fluid_blocked_dirs & global.reverse_dir[spread_dir]) || !neighbor.CanFluidPass(spread_dir) || checked_targets[neighbor])
				continue
			checked_targets[neighbor] = TRUE
			flooded_a_neighbor = TRUE
			neighbor.add_fluid(current_fluid_holder.flooded, FLUID_MAX_DEPTH)

		if(!flooded_a_neighbor)
			REMOVE_ACTIVE_FLUID_SOURCE(current_fluid_holder)

		if (MC_TICK_CHECK)
			return

	if(!active_fluids_copied_yet)
		active_fluids_copied_yet = TRUE
		processing_fluids = active_fluids.Copy()

	while(processing_fluids.len)

		current_fluid_holder = processing_fluids[processing_fluids.len]
		processing_fluids.len--

		REMOVE_ACTIVE_FLUID(current_fluid_holder) // This will be refreshed if our level changes at all in this iteration of the subsystem.

		if(QDELETED(current_fluid_holder))
			continue

		if(!current_fluid_holder.CanFluidPass())
			current_fluid_holder.reagents?.clear_reagents()
			continue

		reagent_holder = current_fluid_holder.reagents
		UPDATE_FLUID_BLOCKED_DIRS(current_fluid_holder)
		current_depth = reagent_holder?.total_volume || 0

		// How is this happening
		if(QDELETED(reagent_holder) || current_depth == -1.#IND || current_depth == 1.#IND)
			continue

		// Evaporation: todo, move liquid into current_fluid_holder.zone air contents if applicable.
		if(current_depth <= FLUID_PUDDLE && prob(60))
			current_fluid_holder.remove_fluids(min(current_depth, 1), defer_update = TRUE)
			current_depth = current_fluid_holder.get_fluid_depth()
		if(current_depth <= FLUID_QDEL_POINT)
			current_fluid_holder.reagents?.clear_reagents()
			continue

		// Wash our turf.
		current_fluid_holder.fluid_act(reagent_holder)

		if(isspaceturf(current_fluid_holder) || istype(current_fluid_holder, /turf/exterior))
			removing = round(current_depth * 0.5)
			if(removing > 0)
				current_fluid_holder.remove_fluids(removing, defer_update = TRUE)
			else
				reagent_holder.clear_reagents()
			current_depth = current_fluid_holder.get_fluid_depth()
			if(current_depth <= FLUID_QDEL_POINT)
				current_fluid_holder.reagents?.clear_reagents()
				continue

		if(!(current_fluid_holder.fluid_blocked_dirs & DOWN) && current_fluid_holder.CanFluidPass(DOWN) && current_fluid_holder.is_open() && current_fluid_holder.has_gravity())
			other_fluid_holder = GetBelow(current_fluid_holder)
			if(other_fluid_holder)
				UPDATE_FLUID_BLOCKED_DIRS(other_fluid_holder)
				if(!(other_fluid_holder.fluid_blocked_dirs & UP) && other_fluid_holder.CanFluidPass(UP))
					if(!QDELETED(other_fluid_holder) && other_fluid_holder.reagents?.total_volume < FLUID_MAX_DEPTH)
						current_fluid_holder.transfer_fluids_to(other_fluid_holder, min(FLOOR(current_depth*0.5), FLUID_MAX_DEPTH - other_fluid_holder.reagents?.total_volume), defer_update = TRUE)
						current_depth = current_fluid_holder.get_fluid_depth()

		if(current_depth <= FLUID_PUDDLE)
			continue

		// Flow into the lowest level neighbor.
		lowest_neighbor_depth = INFINITY
		lowest_neighbor_flow =  0
		candidates = list()
		current_turf_depth = current_depth + current_fluid_holder.get_physical_height()
		for(spread_dir in global.cardinal)
			if(current_fluid_holder.fluid_blocked_dirs & spread_dir)
				continue
			neighbor = get_step(current_fluid_holder, spread_dir)
			if(!neighbor)
				continue
			UPDATE_FLUID_BLOCKED_DIRS(neighbor)
			coming_from = global.reverse_dir[spread_dir]
			if((neighbor.fluid_blocked_dirs & coming_from) || !neighbor.CanFluidPass(coming_from) || neighbor.is_flooded(absolute = TRUE) || !neighbor.CanFluidPass(global.reverse_dir[spread_dir]))
				continue
			other_fluid_holder = neighbor
			neighbor_depth = (other_fluid_holder?.reagents?.total_volume || 0) + neighbor.get_physical_height()
			flow_amount = round((current_turf_depth - neighbor_depth)*0.5)

			if(flow_amount <= FLUID_MINIMUM_TRANSFER)
				continue
			if(neighbor_depth < lowest_neighbor_depth)
				candidates = list(neighbor)
				lowest_neighbor_depth = neighbor_depth
				lowest_neighbor_flow = flow_amount
			else if(neighbor_depth == lowest_neighbor_depth)
				candidates += neighbor

		if(length(candidates))
			lowest_neighbor = pick(candidates)
			current_fluid_holder.transfer_fluids_to(lowest_neighbor, lowest_neighbor_flow, defer_update = TRUE)
			pending_flows[current_fluid_holder] = TRUE

		if(lowest_neighbor_flow >= FLUID_PUSH_THRESHOLD)
			current_fluid_holder.last_flow_strength = lowest_neighbor_flow
			current_fluid_holder.last_flow_dir = get_dir(current_fluid_holder, lowest_neighbor)
		else
			current_fluid_holder.last_flow_strength = 0
			current_fluid_holder.last_flow_dir = 0

		if (MC_TICK_CHECK)
			break

	if(!holders_copied_yet)
		holders_copied_yet = TRUE
		processing_holders = holders_to_update.Copy()

	while(processing_holders.len)
		reagent_holder = processing_holders[processing_holders.len]
		processing_holders.len--
		if(!QDELETED(reagent_holder))
			reagent_holder.handle_update()
		else
			holders_to_update -= reagent_holder
		if(MC_TICK_CHECK)
			return

	if(!flows_copied_yet)
		flows_copied_yet = TRUE
		processing_flows = pending_flows.Copy()

	while(processing_flows.len)
		current_fluid_holder = processing_flows[processing_flows.len]
		processing_flows.len--
		if(!istype(current_fluid_holder) || QDELETED(current_fluid_holder))
			continue
		reagent_holder = current_fluid_holder.reagents
		var/pushed_something = FALSE
		if(reagent_holder.total_volume > FLUID_SHALLOW && current_fluid_holder.last_flow_strength >= 10)
			for(var/atom/movable/AM as anything in current_fluid_holder.get_contained_external_atoms())
				if(AM.is_fluid_pushable(current_fluid_holder.last_flow_strength))
					AM.pushed(current_fluid_holder.last_flow_dir)
					pushed_something = TRUE
		if(pushed_something && prob(1))
			playsound(current_fluid_holder, 'sound/effects/slosh.ogg', 25, 1)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/fluids/StartLoadingMap()
	suspend()

/datum/controller/subsystem/fluids/StopLoadingMap()
	wake()
