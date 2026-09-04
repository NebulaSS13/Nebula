#define CELL_ALIVE(VAL) (VAL == cell_live_value)
#define KILL_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_dead_value;
#define REVIVE_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_live_value;

/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 55
	var/iterations = 0               // Number of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this value.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 5           // Cell becomes alive with this many live neighbors.

// Automata-specific procs and processing.
// we make a map slightly larger than we need in order to avoid needing to check edges
/datum/random_map/automata/New(var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/used_area)
	..(tx, ty, tz, tlx+2, tly+2, do_not_apply, do_not_announce, used_area)

/datum/random_map/automata/seed_map()
	// we skip the edges here because they're just for indexing purposes
	for(var/x in 2 to limit_x - 1)
		for(var/y in 2 to limit_y - 1)
			var/current_cell = TRANSLATE_COORD(x,y)
			if(prob(initial_wall_cell))
				map[current_cell] = WALL_CHAR
			else
				map[current_cell] = initial_cell_char

/datum/random_map/automata/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1

	// adjust for automata map bounds weirdness
	// this means that x=2 will be origin_x, which is good
	// and that we only apply 2 to n-1, which is also good
	origin_x -= 1
	origin_y -= 1
	for(var/x in 2 to limit_x-1)
		for(var/y in 2 to limit_y-1)
			CHECK_TICK
			apply_to_turf(x,y)

/datum/random_map/automata/generate_map()
	var/list/map = src.map
	// Instead of allocating a new next_map every iteration,
	// we just flip the next_map and map lists.
	var/list/next_map = new /list(length(map))
	var/temp // used to swap the maps
	// do a running count to save on repeated accesses
	// this reduces us from 9 checks per tile to just 3
	var/bottom_count = 0
	var/middle_count = 0
	var/top_count = 0
	for(var/iter = 1 to iterations)
		// we have a 1 tile buffer on both sides so go from 2 to lim-1
		for (var/x in 2 to limit_x - 1)
			bottom_count = 0
			middle_count = CELL_ALIVE(map[TRANSLATE_COORD(x-1, 1)]) + CELL_ALIVE(map[TRANSLATE_COORD(x, 1)]) + CELL_ALIVE(map[TRANSLATE_COORD(x+1, 1)])
			top_count = CELL_ALIVE(map[TRANSLATE_COORD(x-1, 2)]) + CELL_ALIVE(map[TRANSLATE_COORD(x, 2)]) + CELL_ALIVE(map[TRANSLATE_COORD(x+1, 2)])
			for (var/y in 2 to limit_y - 1)
				var/i = TRANSLATE_COORD(x, y)
				// shift everything down a row
				bottom_count = middle_count
				middle_count = top_count
				top_count = CELL_ALIVE(map[i + limit_x - 1]) + CELL_ALIVE(map[i + limit_x]) + CELL_ALIVE(map[i + limit_x + 1])
				if((bottom_count + middle_count + top_count) >= cell_threshold)
					REVIVE_CELL(i, next_map)
				else	// Nope. Can't be alive. Kill it.
					KILL_CELL(i, next_map)
				CHECK_TICK
		// end iteration
		temp = map // save this to use as our next slate
		map = next_map
		next_map = temp // restore our next_map slate
	src.map = map

/datum/random_map/automata/get_additional_spawns(value, turf/T)
	return

#undef KILL_CELL
#undef REVIVE_CELL