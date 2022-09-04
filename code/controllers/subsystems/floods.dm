SUBSYSTEM_DEF(flooding)
	name = "Flooding"
	wait = 5 SECONDS
	flags = SS_NO_INIT
	priority = SS_PRIORITY_TURF

	var/tmp/list/water_sources = list()
	var/tmp/fluid_sources_copied_yet = FALSE
	var/tmp/list/processing_sources
	var/tmp/list/checked_targets = list()

/datum/controller/subsystem/flooding/stat_entry()
	..("S:[water_sources.len]")

/datum/controller/subsystem/flooding/fire(resumed = 0)

	if(!resumed)
		fluid_sources_copied_yet = FALSE

	if(!fluid_sources_copied_yet)
		checked_targets.Cut()
		fluid_sources_copied_yet = TRUE
		processing_sources = water_sources.Copy()

	// Local references for speed.
	var/flooded_a_neighbor
	var/turf/neighbor
	var/turf/current_turf
	var/spread_dir = 0

	while(processing_sources.len)

		current_turf = processing_sources[processing_sources.len]
		processing_sources.len--

		flooded_a_neighbor = FALSE
		UPDATE_FLUID_BLOCKED_DIRS(current_turf)
		for(spread_dir in global.cardinal)
			if(current_turf.fluid_blocked_dirs & spread_dir)
				continue
			neighbor = get_step(current_turf, spread_dir)
			if(!istype(neighbor) || neighbor.flooded)
				continue
			UPDATE_FLUID_BLOCKED_DIRS(neighbor)
			if((neighbor.fluid_blocked_dirs & global.reverse_dir[spread_dir]) || !neighbor.CanFluidPass(spread_dir) || checked_targets[neighbor])
				continue
			checked_targets[neighbor] = TRUE
			flooded_a_neighbor = TRUE
			var/datum/reagents/local_fluids = neighbor.return_fluids(create_if_missing = TRUE)
			local_fluids.add_reagent(/decl/material/liquid/water, FLUID_MAX_DEPTH)

		if(!flooded_a_neighbor)
			REMOVE_ACTIVE_FLUID_SOURCE(current_turf)

		if (MC_TICK_CHECK)
			return
