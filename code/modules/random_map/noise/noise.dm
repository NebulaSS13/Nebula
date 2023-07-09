// NOTE: Maps generated with this datum as the base are not DIRECTLY compatible with maps generated from
// the automata, building or maze datums, as the noise generator uses 0-255 instead of WALL_CHAR/FLOOR_CHAR.
// TODO: Consider writing a conversion proc for noise-to-regular maps.
/datum/random_map/noise
	descriptor = "distribution map"
	var/cell_range = 255            // These values are used to seed ore values rather than to determine a turf type.
	var/cell_smooth_amt = 5
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
	(x,y+isize)----(x+hsize,y+isize)----(x+size,y+isize)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y+hsize)----(x+hsize,y+hsize)----(x+isize,y)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y)----------(x+hsize,y)----------(x+isize,y)
	*/
	// Central edge values become average of corners.
	map[TRANSLATE_COORD(x+hsize,y+isize)] = round((\
		map[TRANSLATE_COORD(x,y+isize)] +          \
		map[TRANSLATE_COORD(x+isize,y+isize)] \
		)/2)

	map[TRANSLATE_COORD(x+hsize,y)] = round((  \
		map[TRANSLATE_COORD(x,y)] +            \
		map[TRANSLATE_COORD(x+isize,y)]   \
		)/2)

	map[get_map_cell(x,y+hsize)] = round((  \
		map[TRANSLATE_COORD(x,y+isize)] + \
		map[TRANSLATE_COORD(x,y)]              \
		)/2)

	map[TRANSLATE_COORD(x+isize,y+hsize)] = round((  \
		map[TRANSLATE_COORD(x+isize,y+isize)] + \
		map[TRANSLATE_COORD(x+isize,y)]        \
		)/2)

	// Centre value becomes the average of all other values + possible random variance.
	var/current_cell = TRANSLATE_COORD(x+hsize,y+hsize)
	map[current_cell] = round(( \
		map[TRANSLATE_COORD(x+hsize,y+isize)] + \
		map[TRANSLATE_COORD(x+hsize,y)] + \
		map[TRANSLATE_COORD(x,y+hsize)] + \
		map[TRANSLATE_COORD(x+isize,y)] \
		)/4)

	if(prob(random_variance_chance))
		map[current_cell] *= (rand(1,2)==1 ? (1.0-random_element) : (1.0+random_element))
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
		var/list/next_map[limit_x*limit_y]
		// simple box blur from http://amritamaz.net/blog/understanding-box-blur
		// basically: we do two very fast one-dimensional blurs
		var/total
		for(var/y = 1 to limit_y) // for each row
			// init window for x=1
			// for a blur with a radius >1 use a for loop instead and replace 2 with the real count
			var/cellone = map[TRANSLATE_COORD(1, y)]
			var/celltwo = map[TRANSLATE_COORD(2, y)]
			total = cellone + celltwo
			next_map[TRANSLATE_COORD(1, y)] = round(total / 2)
			// hardcoding x=2 also, to lower checks in the loop
			// larger radius would need to also cover all x < 1 + blur_radius
			total += map[TRANSLATE_COORD(3, y)]
			next_map[TRANSLATE_COORD(2, y)] = round(total / 3)
			for(var/x = 3 to limit_x-1) // should technically be 2 + blur_radius to limit_x - blur_radius
				total -= map[TRANSLATE_COORD(x-2, y)] // x - blur_radius - 1
				total += map[TRANSLATE_COORD(x+1, y)] // x + blur_radius
				next_map[TRANSLATE_COORD(x, y)] = round(total / 3) // should technically be 2*blur_radius+1
		// now do the same in the x axis
		for(var/x = 1 to limit_x)
			// see comments above
			var/cellone = map[TRANSLATE_COORD(x, 1)]
			var/celltwo = map[TRANSLATE_COORD(x, 2)]
			total = cellone + celltwo
			next_map[TRANSLATE_COORD(x, 1)] = round(total / 2)
			// hardcoding x=2 also, to lower checks in the loop
			// larger radius would need to also cover all x < 1 + blur_radius
			total += map[TRANSLATE_COORD(x, 3)]
			next_map[TRANSLATE_COORD(x, 2)] = round(total / 3)
			for(var/y = 3 to limit_y-1)
				total -= map[TRANSLATE_COORD(x, y-2)]
				total += map[TRANSLATE_COORD(x, y+1)]
				next_map[TRANSLATE_COORD(x, y)] = round(total / 3)
		map = next_map

	if(smooth_single_tiles)
		var/lonely
		for(var/x in 1 to limit_x - 1)
			for(var/y in 1 to limit_y - 1)
				var/mapcell = get_map_cell(x,y)
				var/list/neighbors = get_neighbors(x, y, TRUE)
				lonely = TRUE
				for(var/cell in neighbors)
					if(get_appropriate_path(map[cell]) == get_appropriate_path(map[mapcell]))
						lonely = FALSE
						break
				if(lonely)
					map[mapcell] = map[pick(neighbors)]

/datum/random_map/noise/proc/get_neighbors(x, y, include_diagonals)
	. = list()
	if(!include_diagonals)
		var/static/list/ortho_offsets = list(list(-1, 0), list(1, 0), list(0, 1), list(0,-1))
		for(var/list/offset in ortho_offsets)
			var/tmp_cell = get_map_cell(x+offset[1],y+offset[2])
			if(tmp_cell)
				. += tmp_cell
	else
		for(var/dx in -1 to 1)
			for(var/dy in -1 to 1)
				var/tmp_cell = get_map_cell(x+dx,y+dy)
				if(tmp_cell)
					. += tmp_cell
		. -= get_map_cell(x,y)