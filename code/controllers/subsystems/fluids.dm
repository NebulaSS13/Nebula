var/datum/controller/subsystem/fluids/SSfluids

/datum/controller/subsystem/fluids
	name = "Fluids"
	wait = 10
	flags = SS_NO_INIT

	var/next_water_act = 0
	var/water_act_delay = 15 // A bit longer than machines.

	var/list/active_fluids = list()
	var/list/water_sources = list()
	var/list/pushing_atoms = list()
	var/list/hygiene_props = list()

	var/tmp/list/processing_sources
	var/tmp/list/processing_fluids

	var/tmp/active_fluids_copied_yet = FALSE
	var/af_index = 1
	var/list/fluid_images = list()

	var/list/gurgles = list(
		'sound/effects/gurgle1.ogg',
		'sound/effects/gurgle2.ogg',
		'sound/effects/gurgle3.ogg',
		'sound/effects/gurgle4.ogg'
		)

/datum/controller/subsystem/fluids/New()
	NEW_SS_GLOBAL(SSfluids)

/datum/controller/subsystem/fluids/stat_entry()
	..("A:[active_fluids.len] S:[water_sources.len]")

/datum/controller/subsystem/fluids/fire(resumed = 0)
	if (!resumed)
		processing_sources = water_sources.Copy()
		active_fluids_copied_yet = FALSE
		af_index = 1

	var/list/curr_sources = processing_sources
	var/list/checked = list()
	while (curr_sources.len)
		curr_sources.len--
		var/flooded_a_neighbor
		var/turf/T = curr_sources[curr_sources.len]
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
				var/datum/gas_mixture/GM = T.return_air()
				if(GM) F.temperature = GM.temperature
			if(F)
				if(F.fluid_amount < FLUID_MAX_DEPTH)
					SET_FLUID_DEPTH(F, FLUID_MAX_DEPTH)
		if(!flooded_a_neighbor)
			REMOVE_ACTIVE_FLUID_SOURCE(T)
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
		if(!T.CanFluidPass() || F.fluid_amount <= FLUID_EVAPORATION_POINT)
			qdel(F)
			continue

		if(istype(T, /turf/space))
			LOSE_FLUID(F, max(FLUID_EVAPORATION_POINT-1, round(F.fluid_amount * 0.5)))
			if(F.fluid_amount <= FLUID_EVAPORATION_POINT)
				qdel(F)
			continue

		REMOVE_ACTIVE_FLUID(F) // This will be refreshed if our level changes at all in this iteration of the subsystem.
		UPDATE_FLUID_BLOCKED_DIRS(T)
		if(!(T.fluid_blocked_dirs & DOWN) && istype(T, /turf/simulated/open) && has_gravity(F))
			var/turf/below = GetBelow(T)
			if(below)
				UPDATE_FLUID_BLOCKED_DIRS(below)
				if(!(below.fluid_blocked_dirs & UP))
					var/obj/effect/fluid/other = locate() in below
					if(!other)
						other = new(below)
					if(other && other.fluid_amount < FLUID_MAX_DEPTH)
						var/transfer = min(Floor(F.fluid_amount*0.5), FLUID_MAX_DEPTH - other.fluid_amount)
						LOSE_FLUID(F, transfer)
						SET_FLUID_DEPTH(other, other.fluid_amount + transfer)
						continue
		
		if(F.fluid_amount > FLUID_EVAPORATION_POINT)
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
					LOSE_FLUID(F, 1)
					if(F.fluid_amount >= 1)
						other = new /obj/effect/fluid(neighbor_turf)
						SET_FLUID_DEPTH(other, 1)
					else
						qdel(F)
						break
		else
			qdel(F)

		if (MC_TICK_CHECK)
			return

	af_index = 1
	while (af_index <= processing_fluids.len)

		var/obj/effect/fluid/F = processing_fluids[af_index++]
		if (QDELETED(F))
			processing_fluids -= F
			continue

		// Equalize across our neighbors. Hardcoded here for performance reasons.
		if(!length(F.neighbors) || F.fluid_amount <= FLUID_EVAPORATION_POINT)
			continue

		var/sufficient_delta = FALSE
		for(var/thing in F.neighbors)
			var/obj/effect/fluid/other = thing
			if(abs(F.fluid_amount - other.fluid_amount) >= FLUID_EVAPORATION_POINT)
				sufficient_delta = TRUE
				break

		F.last_flow_strength = 0
		var/setting_dir = 0
		if(sufficient_delta)
			var/equalize_avg_depth = F.fluid_amount
			var/equalize_avg_temp = F.temperature
			for(var/thing in F.neighbors)
				var/obj/effect/fluid/other = thing
				equalize_avg_depth += other.fluid_amount
				equalize_avg_temp += other.temperature
				var/flow_amount = F.fluid_amount - other.fluid_amount
				if(F.last_flow_strength < flow_amount && flow_amount >= FLUID_PUSH_THRESHOLD)
					F.last_flow_strength = flow_amount
					setting_dir = get_dir(F, other)
			equalize_avg_depth = Floor(equalize_avg_depth/(length(F.neighbors)+1))
			equalize_avg_temp = Floor(equalize_avg_temp/(length(F.neighbors)+1))
			SET_FLUID_DEPTH(F, equalize_avg_depth)
			for(var/thing in F.neighbors)
				var/obj/effect/fluid/other = thing
				SET_FLUID_DEPTH(other, equalize_avg_depth)
		F.set_dir(setting_dir)

		if (MC_TICK_CHECK)
			return

	af_index = 1
	while (af_index <= processing_fluids.len)
		var/obj/effect/fluid/F = processing_fluids[af_index++]
		if(QDELETED(F))
			processing_fluids -= F
			continue

		if(F.last_flow_strength >= 10)
			if(prob(1))
				playsound(F.loc, 'sound/effects/slosh.ogg', 25, 1)
			for(var/atom/movable/AM in F.loc.contents)
				if(!pushing_atoms[AM] && AM.is_fluid_pushable(F.last_flow_strength))
					pushing_atoms[AM] = TRUE
					step(AM, F.dir)

		if (F.fluid_amount <= FLUID_EVAPORATION_POINT)
			qdel(F)
		else
			F.update_icon()

		if (MC_TICK_CHECK)
			return

	pushing_atoms.Cut()

	// Sometimes, call water_act().
	if(world.time >= next_water_act)
		next_water_act = world.time + water_act_delay
		af_index = 1
		while (af_index <= processing_fluids.len)
			var/obj/effect/fluid/F = processing_fluids[af_index++]
			var/turf/T = get_turf(F)
			if(istype(T) && !QDELETED(F))
				for(var/atom/movable/A in T.contents)
					if(A.simulated && !A.waterproof)
						A.water_act(F.fluid_amount)
			if (MC_TICK_CHECK)
				return
