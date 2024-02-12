/datum/random_map/noise/ore
	descriptor = "ore distribution map"
	var/deep_val = 0.8              // Threshold for deep metals, set in new as percentage of cell_range.
	var/rare_val = 0.7              // Threshold for rare metal, set in new as percentage of cell_range.
	var/chunk_size = 4              // Size each cell represents on map
	var/min_surface_ratio = MIN_SURFACE_COUNT_PER_CHUNK
	var/min_rare_ratio = MIN_RARE_COUNT_PER_CHUNK
	var/min_deep_ratio = MIN_DEEP_COUNT_PER_CHUNK

	var/list/surface_metals = list(
		/decl/material/solid/metal/iron =              list(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX),
		/decl/material/solid/metal/aluminium =         list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/gold =              list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/metal/silver =            list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/metal/uranium =           list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
	)
	var/list/rare_metals = list(
		/decl/material/solid/metal/gold =              list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/silver =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/uranium =           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/osmium =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/rutile =          list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
	)
	var/list/deep_metals = list(
		/decl/material/solid/metal/uranium =           list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/gemstone/diamond =        list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/metal/osmium =            list(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX),
		/decl/material/solid/metallic_hydrogen =       list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/rutile =          list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
	)
	var/list/common_resources = list(
		/decl/material/solid/sand =     list(3,5),
		/decl/material/solid/clay =     list(3,5),
		/decl/material/solid/graphite = list(3,5)
	)

/datum/random_map/noise/ore/New(var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/used_area)
	rare_val = cell_range * rare_val
	deep_val = cell_range * deep_val
	..(tx / chunk_size, ty / chunk_size, tz, (tlx / chunk_size), (tly / chunk_size), do_not_apply, do_not_announce)

/datum/random_map/noise/ore/check_map_sanity()

	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++

	var/num_chunks = surface_count + rare_count + deep_count

	// Sanity check.
	if(surface_count < (min_surface_ratio * num_chunks))
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < (min_rare_ratio * num_chunks))
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < (min_deep_ratio * num_chunks))
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

/datum/random_map/noise/ore/apply_to_turf(var/x,var/y)
	. = list()

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	for(var/T in range(locate(tx, ty, origin_z)))
	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T))
				continue

			. += T

			CHECK_TICK
			var/list/resources
			LAZYINITLIST(resources)

			for(var/val in common_resources)
				var/list/ranges = common_resources[val]
				resources[val] = rand(ranges[1], ranges[2])

			var/tmp_cell
			TRANSLATE_AND_VERIFY_COORD(x, y)

			var/spawning
			if(tmp_cell < rare_val)
				spawning = surface_metals
			else if(tmp_cell < deep_val)
				spawning = rare_metals
			else
				spawning = deep_metals

			for(var/val in spawning)
				var/list/ranges = spawning[val]
				resources[val] = rand(ranges[1], ranges[2])
			set_extension(T, /datum/extension/buried_resources, resources)

/datum/random_map/noise/ore/get_map_char(var/value)
	if(value < rare_val)
		return "S"
	else if(value < deep_val)
		return "R"
	else
		return "D"

/datum/random_map/noise/ore/filthy_rich
	deep_val = 0.6
	rare_val = 0.4

/datum/random_map/noise/ore/rich
	deep_val = 0.7
	rare_val = 0.5

/datum/random_map/noise/ore/poor
	deep_val = 0.8
	rare_val = 0.7
	min_rare_ratio = 0.02
	min_rare_ratio = 0.01

/datum/random_map/noise/ore/ice
	surface_metals = list(
		/decl/material/solid/ice/aspium =              list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/lukrite =             list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/rubenium =	           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/trigarite =           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/ediroite =	           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/iron =              list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/aluminium =         list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MIN),
		/decl/material/solid/metal/gold =              list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/metal/silver =            list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/metal/uranium =           list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
	)
	rare_metals = list(
		/decl/material/solid/ice/aspium =              list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/lukrite =	           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/rubenium =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/trigarite =           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/ediroite =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/gold =              list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/silver =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/uranium =           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/osmium =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/rutile =          list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
	)
	deep_metals = list(
		/decl/material/solid/ice/aspium =              list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/lukrite =             list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/rubenium =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/trigarite =           list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/ice/ediroite =            list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/metal/uranium =           list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/gemstone/diamond =        list(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX),
		/decl/material/solid/metal/osmium =            list(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX),
		/decl/material/solid/metallic_hydrogen =       list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX),
		/decl/material/solid/rutile =          list(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
	)