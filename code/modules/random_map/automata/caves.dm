/datum/random_map/automata/cave_system
	iterations = 5
	descriptor = "moon caves"
	wall_type =  /turf/wall/natural
	floor_type = /turf/floor/natural/barren
	target_turf_type = /turf/unsimulated/mask

	var/sparse_mineral_turf = /turf/wall/natural/random
	var/rich_mineral_turf   = /turf/wall/natural/random/high_chance
	var/list/ore_turfs      = list()

/datum/random_map/automata/cave_system/get_appropriate_path(var/value)
	switch(value)
		if(DOOR_CHAR)
			return sparse_mineral_turf
		if(EMPTY_CHAR)
			return rich_mineral_turf
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

/datum/random_map/automata/cave_system/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1
	var/tmp_cell
	var/new_path
	var/num_applied = 0
	for (var/turf/T as anything in block(origin_x, origin_y, origin_z, limit_x, limit_y, origin_z))
		if (!T || (target_turf_type && !istype(T, target_turf_type)))
			continue
		tmp_cell = TRANSLATE_COORD(T.x, T.y)
		new_path = get_appropriate_path(map[tmp_cell])
		if (!new_path)
			continue
		num_applied += 1
		T.ChangeTurf(new_path)
		get_additional_spawns(map[tmp_cell], T)
		CHECK_TICK
	game_log("ASGEN", "Applied [num_applied] turfs.")