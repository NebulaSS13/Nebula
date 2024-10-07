// Makes indoor areas dirty and spawns webs in corners.
/decl/turf_initializer/spiderwebs
	/// The chance a turf in a corner will attempt to place a web.
	var/web_probability = 25
	/// The chance a dormant spiderling will spawn in a placed web.
	var/spiderling_probability = 5
	/// The maximum amount of dirt added to a turf.
	var/min_base_dirt = 0
	/// The maximum amount of dirt added to a turf.
	var/max_base_dirt = 40
	/// The maximum amount of dirt added to each turf per dirty neighbour turf.
	var/max_dirt_per_turf = 5


/decl/turf_initializer/spiderwebs/proc/get_dirt_amount()
	return rand(min_base_dirt, max_base_dirt)

/decl/turf_initializer/spiderwebs/InitializeTurf(var/turf/tile)
	if(!istype(tile) || tile.density || !tile.simulated)
		return
	// Quick and dirty check to avoid placing things inside windows
	if(locate(/obj/structure/grille, tile))
		return

	var/add_dirt = get_dirt_amount()
	// If a neighbor is dirty, then we get dirtier.
	var/how_dirty = dirty_neighbors(tile)
	for(var/i = 0; i < how_dirty; i++)
		add_dirt += rand(0, max_dirt_per_turf)
	tile.add_dirt(add_dirt)

	if(prob(web_probability))	// Keep in mind that only "corners" get any sort of web
		attempt_web(tile)

/// Returns the number of cardinally adjacent turfs with at least 25 dirt (halfway to visible)
/decl/turf_initializer/spiderwebs/proc/dirty_neighbors(var/turf/center)
	var/how_dirty = 0
	for(var/turf/neighbour in center.CardinalTurfs())
		// Considered dirty if more than halfway to visible dirt
		if(neighbour.get_dirt() > 25)
			how_dirty++
	return how_dirty

/decl/turf_initializer/spiderwebs/proc/attempt_web(var/turf/tile)
	if(!istype(tile) || !tile.simulated)
		return

	var/turf/north_turf = get_step_resolving_mimic(tile, NORTH)
	if(!north_turf || !north_turf.density)
		return

	for(var/dir in list(WEST, EAST))	// For the sake of efficiency, west wins over east in the case of 1-tile valid spots, rather than doing pick()
		var/turf/neighbour = get_step_resolving_mimic(tile, dir)
		if(!neighbour || !neighbour.density)
			continue
		switch(dir)
			if(WEST)
				new /obj/effect/decal/cleanable/cobweb(tile)
			if(EAST)
				new /obj/effect/decal/cleanable/cobweb2(tile)
		if(prob(spiderling_probability))
			var/obj/effect/spider/spiderling/spiderling = new /obj/effect/spider/spiderling/mundane/dormant(tile)
			spiderling.pixel_y = spiderling.shift_range
			spiderling.pixel_x = dir == WEST ? -spiderling.shift_range : spiderling.shift_range
		break // only place one web

/// Spawns random 'kitchen' grime near tables: flour spills, smashed eggs, fruit smudges, etc.
/decl/turf_initializer/kitchen
	/// The probability of attempting to place clutter for a turf.
	var/clutter_probability = 10
	/// Clutter types to pick from when placing clutter on a turf.
	var/list/clutter = list(
		/obj/effect/decal/cleanable/flour,
		/obj/effect/decal/cleanable/tomato_smudge,
		/obj/effect/decal/cleanable/egg_smudge
	)

/decl/turf_initializer/kitchen/InitializeTurf(var/turf/tile)
	if(!istype(tile) || tile.density || !tile.simulated)
		return
	if(!prob(clutter_probability))
		return
	var/adjacent_tables = 0
	for(var/obj/structure/table/table in orange(tile, 1))
		adjacent_tables++
		break
	if(!adjacent_tables)
		return
	if(!prob(adjacent_tables * 25)) // far more likely in table corners with 3 or more tables adjacent
		return
	var/obj/clutter_to_spawn = pick(clutter)
	if(!clutter_to_spawn)
		return
	new clutter_to_spawn(tile)