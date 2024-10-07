/decl/turf_initializer/maintenance
	var/clutter_probability = 2
	var/oil_probability = 2
	var/vermin_probability = 0
	var/web_probability = 25

/decl/turf_initializer/maintenance/heavy
	clutter_probability = 5
	web_probability = 50
	vermin_probability = 0.5

/decl/turf_initializer/maintenance/space
	clutter_probability = 0
	vermin_probability = 0
	web_probability = 0

/decl/turf_initializer/maintenance/InitializeTurf(var/turf/tile)
	if(!istype(tile) || tile.density || !tile.simulated)
		return
	// Quick and dirty check to avoid placing things inside windows
	if(locate(/obj/structure/grille, tile))
		return

	var/add_dirt = get_dirt_amount()
	// If a neighbor is dirty, then we get dirtier.
	var/how_dirty = dirty_neighbors(tile)
	for(var/i = 0; i < how_dirty; i++)
		add_dirt += rand(0,5)
	tile.add_dirt(add_dirt)

	if(prob(oil_probability))
		new /obj/effect/decal/cleanable/blood/oil(tile)

	if(prob(clutter_probability))
		new /obj/random/junk(tile)

	if(prob(vermin_probability))
		if(prob(80))
			new /mob/living/simple_animal/passive/mouse(tile)
		else
			new /mob/living/simple_animal/lizard(tile)

	if(prob(web_probability))	// Keep in mind that only "corners" get any sort of web
		attempt_web(tile)

/// Returns the number of cardinally adjacent turfs with at least 25 dirt (halfway to visible)
/decl/turf_initializer/maintenance/proc/dirty_neighbors(var/turf/center)
	var/how_dirty = 0
	for(var/turf/neighbour in center.CardinalTurfs())
		// Considered dirty if more than halfway to visible dirt
		if(neighbour.get_dirt() > 25)
			how_dirty++
	return how_dirty

/decl/turf_initializer/maintenance/proc/attempt_web(var/turf/tile)

	if(!istype(tile) || !tile.simulated)
		return

	var/turf/north_turf = get_step(tile, NORTH)
	if(!north_turf || !north_turf.density)
		return

	for(var/dir in list(WEST, EAST)) // For the sake of efficiency, west wins over east in the case of 1-tile valid spots, rather than doing pick()
		var/turf/neighbour = get_step_resolving_mimic(tile, dir)
		if(!neighbour || !neighbour.density)
			continue
		switch(dir)
			if(WEST)
				new /obj/effect/decal/cleanable/cobweb(tile)
			if(EAST)
				new /obj/effect/decal/cleanable/cobweb2(tile)
		if(prob(web_probability))
			var/obj/effect/spider/spiderling/spiderling = new /obj/effect/spider/spiderling/mundane/dormant(tile)
			spiderling.pixel_y = spiderling.shift_range
			spiderling.pixel_x = dir == WEST ? -spiderling.shift_range : spiderling.shift_range

/decl/turf_initializer/maintenance/proc/get_dirt_amount()
	return rand(10, 50) + rand(0, 50)

/decl/turf_initializer/maintenance/heavy/get_dirt_amount()
	return ..() + 10
