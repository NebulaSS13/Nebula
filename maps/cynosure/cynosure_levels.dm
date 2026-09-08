/obj/machinery/alarm/cold/sif

/obj/abstract/map_data/cynosure
	height = 3

/datum/level_data/main_level/cynosure
	abstract_type = /datum/level_data/main_level/cynosure
	use_global_exterior_ambience = FALSE
	ambient_light_level = 0.7
	ambient_light_color = "#8497ec"
	base_turf = /turf/floor/dirt
	exterior_atmosphere = alist(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	exterior_atmos_temp = T20C - 25 // roughly -5C, not certain how cold it was on original map
	strata = /decl/strata/sedimentary
	daycycle_id = "cynosure"
	daycycle_type = /datum/daycycle/cynosure
	base_area = null

/datum/level_data/main_level/cynosure/get_subtemplate_areas(template_category, blacklist, whitelist)
	switch(template_category)
		if(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_PLAINS)
			return list(/area/surface/outside/plains/normal)
		if(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_WILDERNESS)
			return list(/area/surface/outside/wilderness/normal)
		if(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_DEEP_WILDERNESS)
			return list(/area/surface/outside/wilderness/deep)
		if(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS)
			return list(/area/surface/cave/unexplored/normal)
		if(/datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS_DEEP)
			return list(/area/surface/cave/unexplored/deep)

/datum/daycycle/cynosure
	cycle_duration = 2 HOURS // 1 hour of daylight, 1 hour of night

/datum/daycycle/cynosure/New()
	time_in_cycle = rand(cycle_duration)
	..()

/datum/level_data/main_level/cynosure/caves
	name = "Cynosure - Underground"
	level_id = "cynosure_underground"
	level_generators = list(
		/datum/random_map/automata/cave_system,
		/datum/random_map/noise/sif/underground,
		/datum/random_map/noise/ore
	)

/datum/level_data/main_level/cynosure/caves/place_subtemplates()
	spawn_subtemplates(75, /datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS)
	spawn_subtemplates(75, /datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_MOUNTAINS_DEEP)

/datum/level_data/main_level/cynosure/station
	name = "Cynosure - Station Ground Level"
	level_id = "cynosure_station"
	connected_levels = list("cynosure_wilderness" = NORTH)
	level_generators = list(/datum/random_map/noise/sif)

/datum/level_data/main_level/cynosure/station/place_subtemplates()
	spawn_subtemplates(100, /datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_PLAINS)

/datum/level_data/main_level/cynosure/upper
	name = "Cynosure - Station Upper Level"
	level_id = "cynosure_upper"

/datum/level_data/main_level/cynosure/wilderness
	name = "Cynosure - Wilderness"
	level_id = "cynosure_wilderness"
	connected_levels = list("cynosure_station" = SOUTH)
	level_generators = list(/datum/random_map/noise/sif/forest)

/datum/level_data/main_level/cynosure/wilderness/place_subtemplates()
	spawn_subtemplates(75, /datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_WILDERNESS)
	spawn_subtemplates(75, /datum/map/cynosure::MAP_TEMPLATE_CATEGORY_CYNOSURE_DEEP_WILDERNESS)

/obj/abstract/level_data_spawner/cynosure_caves
	level_data_type = /datum/level_data/main_level/cynosure/caves

/obj/abstract/level_data_spawner/cynosure_station
	level_data_type = /datum/level_data/main_level/cynosure/station

/obj/abstract/level_data_spawner/cynosure_upper
	level_data_type = /datum/level_data/main_level/cynosure/upper

/obj/abstract/level_data_spawner/cynosure_wilderness
	level_data_type = /datum/level_data/main_level/cynosure/wilderness
