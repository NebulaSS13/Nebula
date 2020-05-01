GLOBAL_LIST_INIT(weighted_minerals_sparse, \
	list(                   \
		MAT_PITCHBLENDE =  8, \
		MAT_PLATINUM =     8, \
		MAT_HEMATITE =    35, \
		MAT_GRAPHITE =    35, \
		MAT_DIAMOND =      5, \
		MAT_GOLD =         8, \
		MAT_SILVER =       8, \
		MAT_PHORON =      10, \
		MAT_QUARTZ =       3, \
		MAT_PYRITE =       3, \
		MAT_SPODUMENE =    3, \
		MAT_CINNABAR =     3, \
		MAT_PHOSPHORITE =  3, \
		MAT_ROCK_SALT =    3, \
		MAT_POTASH =       3, \
		MAT_BAUXITE =      3, \
		MAT_RUTILE = 		3
	))

GLOBAL_LIST_INIT(weighted_minerals_rich, \
	list(                   \
		MAT_PITCHBLENDE = 10, \
		MAT_PLATINUM =    10, \
		MAT_HEMATITE =    20, \
		MAT_GRAPHITE =    20, \
		MAT_DIAMOND =      5, \
		MAT_GOLD =        10, \
		MAT_SILVER =      10, \
		MAT_PHORON =      20, \
		MAT_QUARTZ =       1, \
		MAT_PYRITE =       1, \
		MAT_SPODUMENE =    1, \
		MAT_CINNABAR =     1, \
		MAT_PHOSPHORITE =  1, \
		MAT_ROCK_SALT =    1, \
		MAT_POTASH =       1, \
		MAT_BAUXITE =      1, \
		MAT_RUTILE = 		1
	))

/datum/random_map/automata/cave_system
	iterations = 5
	descriptor = "moon caves"
	wall_type =  /turf/simulated/mineral
	floor_type = /turf/simulated/floor/asteroid
	target_turf_type = /turf/unsimulated/mask

	var/mineral_turf = /turf/simulated/mineral/random
	var/list/ore_turfs = list()
	var/list/minerals_sparse
	var/list/minerals_rich

/datum/random_map/automata/cave_system/New()
	if(!minerals_sparse) minerals_sparse = GLOB.weighted_minerals_sparse
	if(!minerals_rich)   minerals_rich =   GLOB.weighted_minerals_rich
	..()

/datum/random_map/automata/cave_system/get_appropriate_path(var/value)
	switch(value)
		if(DOOR_CHAR, EMPTY_CHAR)
			return mineral_turf
		if(FLOOR_CHAR)
			return floor_type
		if(WALL_CHAR)
			return wall_type

/datum/random_map/automata/cave_system/get_map_char(var/value)
	switch(value)
		if(DOOR_CHAR)
			return "x"
		if(EMPTY_CHAR)
			return "X"
	return ..(value)

// Create ore turfs.
/datum/random_map/automata/cave_system/cleanup()
	var/tmp_cell
	for (var/x = 1 to limit_x)
		for (var/y = 1 to limit_y)
			tmp_cell = TRANSLATE_COORD(x, y)
			if (CELL_ALIVE(map[tmp_cell]))
				ore_turfs += tmp_cell

	game_log("ASGEN", "Found [ore_turfs.len] ore turfs.")
	var/ore_count = round(map.len/20)
	var/door_count = 0
	var/empty_count = 0
	while((ore_count>0) && (ore_turfs.len>0))

		if(!priority_process)
			CHECK_TICK

		var/check_cell = pick(ore_turfs)
		ore_turfs -= check_cell
		if(prob(75))
			map[check_cell] = DOOR_CHAR  // Mineral block
			door_count += 1
		else
			map[check_cell] = EMPTY_CHAR // Rare mineral block.
			empty_count += 1
		ore_count--

	game_log("ASGEN", "Set [door_count] turfs to random minerals.")
	game_log("ASGEN", "Set [empty_count] turfs to high-chance random minerals.")
	return 1

/datum/random_map/automata/cave_system/proc/is_valid_turf(var/turf/T)
	return T && target_turf_type && istype(T, target_turf_type)

/datum/random_map/automata/cave_system/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1

	var/tmp_cell
	var/new_path
	var/num_applied = 0
	for (var/thing in block(locate(origin_x, origin_y, origin_z), locate(limit_x, limit_y, origin_z)))
		var/turf/T = thing
		new_path = null
		if (!is_valid_turf(T))
			continue

		tmp_cell = TRANSLATE_COORD(T.x, T.y)

		var/minerals
		switch (map[tmp_cell])
			if(DOOR_CHAR)
				new_path = mineral_turf
				minerals = pickweight(minerals_sparse)
			if(EMPTY_CHAR)
				new_path = mineral_turf
				minerals = pickweight(minerals_rich)
			if(FLOOR_CHAR)
				new_path = floor_type
			if(WALL_CHAR)
				new_path = wall_type

		if (!new_path)
			continue

		num_applied += 1
		T.ChangeTurf(new_path, minerals)
		get_additional_spawns(map[tmp_cell], T)
		after_assign_turf(T)
		CHECK_TICK

	game_log("ASGEN", "Applied [num_applied] turfs.")

/datum/random_map/automata/cave_system/proc/after_assign_turf(var/turf/T)