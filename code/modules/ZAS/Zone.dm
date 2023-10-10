/*

Overview:
	Each zone is a self-contained area where gas values would be the same if tile-based equalization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air groups would have similar functionality if they didn't break in a stiff breeze.

Class Vars:
	name - A name of the format "Zone [#]", used for debugging.
	invalid - True if the zone has been erased and is no longer eligible for processing.
	needs_update - True if the zone has been added to the update list.
	edges - A list of edges that connect to this zone.
	air - The gas mixture that any turfs in this zone will return. Values are per-tile with a group multiplier.

Class Procs:
	add(turf/T)
		Adds a turf to the contents, sets its zone and merges its air.

	remove(turf/T)
		Removes a turf, sets its zone to null and erases any gas graphics.
		Invalidates the zone if it has no more tiles.

	c_merge(var/zone/into)
		Invalidates this zone and adds all its former contents to into.

	c_invalidate()
		Marks this zone as invalid and removes it from processing.

	rebuild()
		Invalidates the zone and marks all its former tiles for updates.

	add_tile_air(turf/T)
		Adds the air contained in T.air to the zone's air supply. Called when adding a turf.

	tick()
		Called only when the gas content is changed. Archives values and changes gas graphics.

	dbg_data(mob/M)
		Sends M a printout of important figures for the zone.

*/


/zone
	var/name
	var/invalid = 0
	var/list/contents = list()
	var/list/fire_tiles = list()
	var/needs_update = 0
	var/list/edges = list()
	var/datum/gas_mixture/air = new
	var/list/graphic_add = list()
	var/list/graphic_remove = list()
	var/last_air_temperature = TCMB
	var/condensing = FALSE

/zone/New()
	SSair.add_zone(src)
	air.temperature = TCMB
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/zone/proc/add(turf/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone_membership_candidate)
	ASSERT(!TURF_HAS_VALID_ZONE(T))
#endif

	var/datum/gas_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	if(T.fire)
		fire_tiles.Add(T)
		SSair.active_fire_zones |= src
	T.refresh_vis_contents()

/zone/proc/remove(turf/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone_membership_candidate)
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")
#endif
	contents.Remove(T)
	fire_tiles.Remove(T)
	T.zone = null
	T.refresh_vis_contents()
	if(contents.len)
		air.group_multiplier = contents.len
	else
		c_invalidate()

/zone/proc/c_merge(var/zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	for(var/turf/T as anything in contents)
		if(!T.zone_membership_candidate)
			continue
		into.add(T)
		T.refresh_vis_contents()
		#ifdef ZASDBG
		T.dbg(zasdbgovl_merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/connection_edge/E in edges)
		if(E.contains_zone(into))
			continue //don't need to rebuild this edge
		for(var/turf/T in E.connecting_turfs)
			SSair.mark_for_update(T)

/zone/proc/c_invalidate()
	invalid = 1
	SSair.remove_zone(src)
	#ifdef ZASDBG
	for(var/turf/T as anything in contents)
		T.dbg(zasdbgovl_invalid_zone)
	#endif

/zone/proc/rebuild()
	set waitfor = 0
	if(invalid) return //Short circuit for explosions where rebuild is called many times over.
	c_invalidate()
	for(var/turf/T as anything in contents)
		T.refresh_vis_contents()
		T.needs_air_update = 0 //Reset the marker so that it will be added to the list.
		SSair.mark_for_update(T)
		CHECK_TICK

/zone/proc/add_tile_air(datum/gas_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(contents.len)
	air.merge(tile_air)
	air.divide(contents.len+1)
	air.group_multiplier = contents.len+1

/zone/proc/tick()

	// Update fires.
	if(air.temperature >= FLAMMABLE_GAS_FLASHPOINT && !(src in SSair.active_fire_zones) && air.check_combustibility() && contents.len)
		var/turf/T = pick(contents)
		if(istype(T))
			T.create_fire(vsc.fire_firelevel_multiplier)

	// Update gas overlays.
	if(air.check_tile_graphic(graphic_add, graphic_remove))
		for(var/turf/T as anything in contents)
			T.refresh_vis_contents()
			CHECK_TICK
		graphic_add.len = 0
		graphic_remove.len = 0

	// Update connected edges.
	for(var/connection_edge/E in edges)
		if(E.sleeping)
			E.recheck()
			CHECK_TICK

	// Handle condensation from the air.
	if(!condensing)
		handle_condensation()

	// Update atom temperature.
	if(abs(air.temperature - last_air_temperature) >= ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD)
		last_air_temperature = air.temperature
		for(var/turf/T as anything in contents)
			for(var/check_atom in T.contents)
				var/atom/checking = check_atom
				if(checking.simulated)
					queue_temperature_atoms(checking)
			CHECK_TICK

/zone/proc/handle_condensation()
	set waitfor = FALSE
	condensing = TRUE
	for(var/g in air.gas)
		var/decl/material/mat = GET_DECL(g)
		if(!isnull(mat.gas_condensation_point) && (air.temperature <= mat.gas_condensation_point))
			var/condensation_area = air.group_multiplier / length(air.gas)
			while(condensation_area > 0 && length(contents))
				condensation_area--
				var/turf/flooding = pick(contents)
				var/condense_amt = min(air.gas[g], rand(1,3))
				if(condense_amt < 1)
					break
				air.adjust_gas(g, -condense_amt)
				var/obj/effect/fluid/F = locate() in flooding
				if(!F) F = new(flooding)
				F.reagents.add_reagent(g, condense_amt * REAGENT_UNITS_PER_GAS_MOLE)
		CHECK_TICK
	condensing = FALSE

/zone/proc/dbg_data(mob/M)
	to_chat(M, name)
	for(var/g in air.gas)
		var/decl/material/mat = GET_DECL(g)
		to_chat(M, "[capitalize(mat.gas_name)]: [air.gas[g]]")
	to_chat(M, "P: [air.return_pressure()] kPa V: [air.volume]L T: [air.temperature]°K ([air.temperature - T0C]°C)")
	to_chat(M, "O2 per N2: [(air.gas[/decl/material/gas/nitrogen] ? air.gas[/decl/material/gas/oxygen]/air.gas[/decl/material/gas/nitrogen] : "N/A")] Moles: [air.total_moles]")
	to_chat(M, "Simulated: [contents.len] ([air.group_multiplier])")
	to_chat(M, "Edges: [length(edges)]")
	if(invalid) to_chat(M, "Invalid!")
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for(var/connection_edge/E in edges)
		if(E.type == /connection_edge/zone) zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient
			to_chat(M, "[E:air:return_pressure()]kPa")

	to_chat(M, "Zone Edges: [zone_edges]")
	to_chat(M, "Space Edges: [space_edges] ([space_coefficient] connections)")

	//for(var/turf/T in unsimulated_contents)
//		to_chat(M, "[T] at ([T.x],[T.y])")
