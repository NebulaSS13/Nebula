// NOTE: Maps generated with this datum as the base are not DIRECTLY compatible with maps generated from
// the automata, building or maze datums, as the noise generator uses 0-255 instead of WALL_CHAR/FLOOR_CHAR.
// TODO: Consider writing a conversion proc for noise-to-regular maps.
/datum/random_map/noise
	descriptor = "distribution map"
	var/cell_range = 255            // These values are used to seed ore values rather than to determine a turf type.
	var/random_variance_chance = 25 // % chance of applying random_element.
	var/random_element = 0.5        // Determines the variance when smoothing out cell values.
	var/cell_base                   // Set in New()
	var/initial_cell_range          // Set in New()
	var/smoothing_iterations = 0
	var/smooth_single_tiles			// Single turfs of different value are not allowed

/datum/random_map/noise/New(var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/used_area)
	initial_cell_range = cell_range/5
	cell_base = cell_range/2
	..()

/datum/random_map/noise/set_map_size()
	// Make sure the grid is a square with limits that are
	// (n^2)+1, otherwise diamond-square won't work.
	if(!IS_POWER_OF_TWO((limit_x-1)))
		limit_x = ROUND_UP_TO_POWER_OF_TWO(limit_x) + 1
	if(!IS_POWER_OF_TWO((limit_y-1)))
		limit_y = ROUND_UP_TO_POWER_OF_TWO(limit_y) + 1
	// Sides must be identical lengths.
	if(limit_x > limit_y)
		limit_y = limit_x
	else if(limit_y > limit_x)
		limit_x = limit_y
	..()

// Diamond-square algorithm.
/datum/random_map/noise/seed_map()
	// Instantiate the grid.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			map[TRANSLATE_COORD(x,y)] = 0

	// Now dump in the actual random data.
	map[TRANSLATE_COORD(1,1)]             = cell_base+rand(initial_cell_range)
	map[TRANSLATE_COORD(1,limit_y)]       = cell_base+rand(initial_cell_range)
	map[TRANSLATE_COORD(limit_x,limit_y)] = cell_base+rand(initial_cell_range)
	map[TRANSLATE_COORD(limit_x,1)]       = cell_base+rand(initial_cell_range)

/datum/random_map/noise/generate_map()
	// Begin recursion.
	subdivide(1,1,1,(limit_y-1))

/datum/random_map/noise/get_map_char(var/value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	return "[val]"

/datum/random_map/noise/proc/noise2value(var/value)
	return min(9,max(0,round((value/cell_range)*10)))

/datum/random_map/noise/proc/subdivide(var/iteration,var/x,var/y,var/input_size)

	var/isize = input_size
	var/hsize = round(input_size/2)

	/*
	(x,y+isize)----(x+hsize,y+isize)----(x+isize,y+isize)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y+hsize)----(x+hsize,y+hsize)----(x+isize,y+hsize)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y)----------(x+hsize,y)----------(x+isize,y)
	*/
	// Pre-halve them to prevent extra divisions.
	var/topleft = map[TRANSLATE_COORD(x,y+isize)]/2
	var/topright = map[TRANSLATE_COORD(x+isize,y+isize)]/2
	var/bottomleft = map[TRANSLATE_COORD(x, y)]/2
	var/bottomright = map[TRANSLATE_COORD(x+isize,y)]/2

	// Central edge values become average of corners.
	map[TRANSLATE_COORD(x+hsize,y+isize)] = round(topleft + topright) // top = topleft + topright
	map[TRANSLATE_COORD(x+hsize,y)] = round(bottomleft + bottomright) // bottom = bottomleft + bottomright
	map[TRANSLATE_COORD(x,y+hsize)] = round(topleft + bottomleft) // left = topleft + bottomleft
	map[TRANSLATE_COORD(x+isize,y+hsize)] = round(topright + bottomright) // right = topright + bottomright

	// Centre value becomes the average of all other values + possible random variance.
	var/current_cell = TRANSLATE_COORD(x+hsize,y+hsize)
	// yes, this is equivalent to the prior averaging. it just avoids more list indexing
	map[current_cell] = round(round(topleft+topright)/4 + round(bottomleft + bottomright)/4 + round(topleft + bottomleft)/4 + round(topright + bottomright)/4)

	if(prob(random_variance_chance))
		map[current_cell] *= (prob(50) ? (1.0-random_element) : (1.0+random_element))
		map[current_cell] = max(0,min(cell_range,map[current_cell]))

 	// Recurse until size is too small to subdivide.
	if(isize>3)
		CHECK_TICK
		iteration++
		subdivide(iteration, x,       y,       hsize)
		subdivide(iteration, x+hsize, y,       hsize)
		subdivide(iteration, x,       y+hsize, hsize)
		subdivide(iteration, x+hsize, y+hsize, hsize)

/datum/random_map/noise/cleanup()
	for(var/i = 1 to smoothing_iterations)
		// var/list/next_map[limit_x*limit_y]
		// simple box blur from http://amritamaz.net/blog/understanding-box-blur
		// basically: we do two very fast one-dimensional blurs
		var/total
		for(var/y = 1 to limit_y) // for each row
			// init window for x=1
			// for a blur with a radius >1 use a for loop instead and replace 2 with the real count
			var/first_coord = TRANSLATE_COORD(1, y)
			var/second_coord = TRANSLATE_COORD(2, y)
			var/cellone = map[first_coord]
			var/celltwo = map[second_coord]
			total = cellone + celltwo
			map[first_coord] = round(total / 2)
			// hardcoding x=2 also, to lower checks in the loop
			// larger radius would need to also cover all x < 1 + blur_radius
			total += map[TRANSLATE_COORD(3, y)]
			map[second_coord] = round(total / 3)
			for(var/x = 3 to limit_x-1) // should technically be 2 + blur_radius to limit_x - blur_radius
				total -= map[TRANSLATE_COORD(x-2, y)] // x - blur_radius - 1
				total += map[TRANSLATE_COORD(x+1, y)] // x + blur_radius
				map[TRANSLATE_COORD(x, y)] = round(total / 3) // should technically be 2*blur_radius+1
		// now do the same in the x axis
		// map = next_map.Copy()
		for(var/x = 1 to limit_x)
			// see comments above
			var/first_coord = TRANSLATE_COORD(x, 1)
			var/second_coord = TRANSLATE_COORD(x, 2)
			var/cellone = map[first_coord]
			var/celltwo = map[second_coord]
			total = cellone + celltwo
			map[first_coord] = round(total / 2)
			// hardcoding x=2 also, to lower checks in the loop
			// larger radius would need to also cover all x < 1 + blur_radius
			total += map[TRANSLATE_COORD(x, 3)]
			map[second_coord] = round(total / 3)
			for(var/y = 3 to limit_y-1)
				total -= map[TRANSLATE_COORD(x, y-2)]
				total += map[TRANSLATE_COORD(x, y+1)]
				map[TRANSLATE_COORD(x, y)] = round(total / 3)
		// map = next_map
		CHECK_TICK

	if(smooth_single_tiles)
		for(var/x in 1 to limit_x - 1)
			for(var/y in 1 to limit_y - 1)
				var/mapcell = TRANSLATE_COORD(x,y)
				if(has_neighbor_with_path(x, y, get_appropriate_path(map[mapcell]), TRUE))
					continue
				map[mapcell] = map[pick(get_neighbors(x, y, TRUE))]
				CHECK_TICK

#define CHECK_NEIGHBOR_FOR_PATH(X, Y) \
	TRANSLATE_AND_VERIFY_COORD(X,Y);\
	if(tmp_cell && (get_appropriate_path(map[tmp_cell]) == path)) {\
		return TRUE;\
	}

/// Checks if the cell at x,y has a neighbor with the given path.
/// Faster than looping over get_neighbors for the same purpose because it doesn't use list ops.
/datum/random_map/noise/proc/has_neighbor_with_path(x, y, path, include_diagonals)
	var/tmp_cell
	CHECK_NEIGHBOR_FOR_PATH(x-1,y)
	CHECK_NEIGHBOR_FOR_PATH(x+1,y)
	CHECK_NEIGHBOR_FOR_PATH(x,y+1)
	CHECK_NEIGHBOR_FOR_PATH(x,y-1)
	if(include_diagonals)
		CHECK_NEIGHBOR_FOR_PATH(x+1,y+1)
		CHECK_NEIGHBOR_FOR_PATH(x+1,y-1)
		CHECK_NEIGHBOR_FOR_PATH(x-1,y-1)
		CHECK_NEIGHBOR_FOR_PATH(x-1,y+1)
	return FALSE

#undef CHECK_NEIGHBOR_FOR_PATH

#define VERIFY_AND_ADD_CELL(X, Y) \
	TRANSLATE_AND_VERIFY_COORD(X,Y);\
	if(tmp_cell) {\
		. += tmp_cell;\
	}

/// Gets the neighbors of the cell at x, y, optionally including diagonals.
/// (x,y) and its neighbors can safely be invalid/not validated before calling.
/datum/random_map/noise/proc/get_neighbors(x, y, include_diagonals)
	. = list()
	var/tmp_cell
	VERIFY_AND_ADD_CELL(x-1,y)
	VERIFY_AND_ADD_CELL(x+1,y)
	VERIFY_AND_ADD_CELL(x,y+1)
	VERIFY_AND_ADD_CELL(x,y-1)
	if(include_diagonals)
		VERIFY_AND_ADD_CELL(x+1,y+1)
		VERIFY_AND_ADD_CELL(x+1,y-1)
		VERIFY_AND_ADD_CELL(x-1,y-1)
		VERIFY_AND_ADD_CELL(x-1,y+1)

#undef VERIFY_AND_ADD_CELL