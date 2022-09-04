#define CLEAR_REAGENTS_FAST_UNSAFE(R)     \
if(R.total_volume) {                      \
	SSfluids.holders_to_update[R] = TRUE; \
	LAZYCLEARLIST(R.reagent_volumes);     \
	LAZYCLEARLIST(R.reagent_data);        \
	R.total_volume = 0                    \
}
#define TRANSFER_REAGENTS_FAST_UNSASFE(R, T, A)                                             \
var/_PART = min(R.total_volume, min(FLUID_MAX_DEPTH - T.total_volume, A)) / R.total_volume; \
for(var/_RTYPE in R.reagent_volumes) {                                                      \
	var/_AMT = REAGENT_VOLUME(R, _RTYPE) * _PART;                                           \
	T.add_reagent(_RTYPE, _AMT, REAGENT_DATA(R, _AMT), defer_update = TRUE);                \
	R.remove_reagent(_RTYPE, _AMT, defer_update = TRUE)                                     \
}                                                                                           \
if(!QDELETED(R)) { SSfluids.holders_to_update[R] = TRUE }                                   \
if(!QDELETED(T)) { SSfluids.holders_to_update[T] = TRUE }

SUBSYSTEM_DEF(fluids)
	name = "Fluids"
	wait = 1 SECOND
	flags = SS_NO_INIT

	var/static/list/gurgles = list(
		'sound/effects/gurgle1.ogg',
		'sound/effects/gurgle2.ogg',
		'sound/effects/gurgle3.ogg',
		'sound/effects/gurgle4.ogg'
	)

	var/tmp/list/holders_to_update =   list()
	var/tmp/holders_copied_yet =       FALSE
	var/tmp/list/processing_holders

	var/tmp/list/active_fluids =       list()
	var/tmp/active_fluids_copied_yet = FALSE
	var/tmp/list/processing_fluids

	var/tmp/list/fluid_images =        list()
	var/tmp/list/checked_targets =     list()

/datum/controller/subsystem/fluids/stat_entry()
	..("A:[active_fluids.len]")

/datum/controller/subsystem/fluids/fire(resumed = 0)

	// Predeclaring a bunch of vars for performance purposes.
	var/datum/reagents/target_reagents
	var/datum/reagents/reagent_holder
	var/list/candidates
	var/turf/below
	var/turf/current_turf
	var/turf/neighbor
	var/turf/lowest_neighbor

	var/removing = 0
	var/spread_dir = 0
	var/coming_from = 0
	var/flow_amount = 0
	var/current_turf_depth = 0
	var/neighbor_depth = 0
	var/lowest_neighbor_flow = 0
	var/lowest_neighbor_depth = INFINITY

	if(!resumed)
		active_fluids_copied_yet = FALSE
		holders_copied_yet =       FALSE
		checked_targets.Cut()

	if(!active_fluids_copied_yet)
		active_fluids_copied_yet = TRUE
		processing_fluids = active_fluids.Copy()

	while(processing_fluids.len)

		current_turf = processing_fluids[processing_fluids.len]
		processing_fluids.len--

		REMOVE_ACTIVE_FLUID(current_turf) // This will be refreshed if our level changes at all in this iteration of the subsystem.

		reagent_holder = current_turf.reagents
		if(!reagent_holder?.total_volume)
			continue

		if(!current_turf.CanFluidPass())
			CLEAR_REAGENTS_FAST_UNSAFE(reagent_holder)
			continue

		UPDATE_FLUID_BLOCKED_DIRS(current_turf)

		// How is this happening
		if(isNaN(reagent_holder.total_volume))
			CLEAR_REAGENTS_FAST_UNSAFE(reagent_holder)
			continue

		// Evaporation: todo, move liquid into current_turf.zone air contents if applicable.
		if(reagent_holder.total_volume <= FLUID_MINIMUM_TRANSFER && prob(15))
			reagent_holder.remove_any(min(reagent_holder.total_volume, 1), defer_update = FALSE)
			if(!QDELETED(reagent_holder))
				holders_to_update[reagent_holder] = TRUE

		if(reagent_holder.total_volume <= FLUID_QDEL_POINT)
			CLEAR_REAGENTS_FAST_UNSAFE(reagent_holder)
			continue

		if(isspaceturf(current_turf) || istype(current_turf, /turf/exterior))
			removing = round(reagent_holder.total_volume * 0.5)
			if(removing <= 0)
				CLEAR_REAGENTS_FAST_UNSAFE(reagent_holder)
				continue

			reagent_holder.remove_any(removing, defer_update = TRUE)
			if(!QDELETED(reagent_holder))
				SSfluids.holders_to_update[reagent_holder] = TRUE

			if(reagent_holder.total_volume <= FLUID_QDEL_POINT)
				CLEAR_REAGENTS_FAST_UNSAFE(reagent_holder)
				continue

		if(!(current_turf.fluid_blocked_dirs & DOWN) && current_turf.CanFluidPass(DOWN) && current_turf.is_open() && current_turf.has_gravity())
			below = GetBelow(current_turf)
			if(below)
				UPDATE_FLUID_BLOCKED_DIRS(below)
				if(!(below.fluid_blocked_dirs & UP) && below.CanFluidPass(UP))
					target_reagents = below.reagents || below.create_reagents(FLUID_MAX_DEPTH)
					if(target_reagents.total_volume < FLUID_MAX_DEPTH)
						TRANSFER_REAGENTS_FAST_UNSASFE(reagent_holder, target_reagents, FLOOR(reagent_holder.total_volume*0.5))

		if(reagent_holder.total_volume <= FLUID_PUDDLE)
			continue

		// Flow into the lowest level neighbor.
		lowest_neighbor_depth = INFINITY
		lowest_neighbor_flow =  0
		candidates = list()
		current_turf_depth = reagent_holder.total_volume + current_turf.get_physical_height()
		for(spread_dir in global.cardinal)
			if(current_turf.fluid_blocked_dirs & spread_dir)
				continue
			neighbor = get_step(current_turf, spread_dir)
			if(!neighbor)
				continue
			UPDATE_FLUID_BLOCKED_DIRS(neighbor)
			coming_from = global.reverse_dir[spread_dir]
			if((neighbor.fluid_blocked_dirs & coming_from) || !neighbor.CanFluidPass(coming_from) || neighbor.is_flooded(absolute = TRUE) || !neighbor.CanFluidPass(global.reverse_dir[spread_dir]))
				continue
			neighbor_depth = (neighbor.reagents?.total_volume || 0) + neighbor.get_physical_height()
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
			target_reagents = lowest_neighbor.reagents || lowest_neighbor.create_reagents(FLUID_MAX_DEPTH)
			TRANSFER_REAGENTS_FAST_UNSASFE(reagent_holder, target_reagents, lowest_neighbor_flow)
			SSflows.pending_flows[current_turf] = TRUE

		if(lowest_neighbor_flow >= FLUID_PUSH_THRESHOLD)
			current_turf.last_flow_strength = lowest_neighbor_flow
			current_turf.last_flow_dir = get_dir(current_turf, lowest_neighbor)
		else
			current_turf.last_flow_strength = 0
			current_turf.last_flow_dir = 0

		if (MC_TICK_CHECK)
			break

	if(!holders_copied_yet)
		holders_copied_yet = TRUE
		processing_holders = holders_to_update.Copy()

	while(processing_holders.len)
		reagent_holder = processing_holders[processing_holders.len]
		processing_holders.len--
		if(!QDELETED(reagent_holder))
			// Inlining to avoid some proc overhead.
			reagent_holder.update_total()
			HANDLE_REACTIONS(reagent_holder)
			if(reagent_holder.my_atom && !reagent_holder.updating_holder_reagent_state)
				reagent_holder.updating_holder_reagent_state = TRUE
				reagent_holder.my_atom.on_reagent_change()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/fluids/StartLoadingMap()
	suspend()

/datum/controller/subsystem/fluids/StopLoadingMap()
	wake()

#undef CLEAR_REAGENTS_FAST_UNSAFE
#undef TRANSFER_REAGENTS_FAST_UNSASFE