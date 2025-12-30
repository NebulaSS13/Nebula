/obj/abstract/map_data/shaded_hills
	height = 2

/datum/level_data/main_level/shaded_hills
	use_global_exterior_ambience = FALSE
	base_area = null
	base_turf = /turf/floor/dirt
	abstract_type = /datum/level_data/main_level/shaded_hills
	ambient_light_level = 1
	ambient_light_color = "#f3e6ca"
	strata = /decl/strata/shaded_hills
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	daycycle_type = /datum/daycycle/shaded_hills
	daycycle_id = "daycycle_shaded_hills"
	template_edge_padding = 0 // we use a strictly delineated subarea, no need for this guard

/datum/daycycle/shaded_hills
	cycle_duration = 2 HOURS // 1 hour of daylight, 1 hour of night

// Randomized time of day to start at.
/datum/daycycle/shaded_hills/New()
	time_in_cycle = rand(cycle_duration)
	..()

/datum/level_data/main_level/shaded_hills/grassland
	name = "Shaded Hills - Grassland"
	level_id = "shaded_hills_grassland"
	level_generators = list(
		/datum/random_map/automata/cave_system/shaded_hills,
		/datum/random_map/noise/ore/poor,
		/datum/random_map/noise/forage/shaded_hills/grassland
	)
	connected_levels = list(
		"shaded_hills_woods"     = NORTH,
		"shaded_hills_swamp"     = SOUTH,
		"shaded_hills_downlands" = EAST
	)
	subtemplate_budget = 5
	subtemplate_category = MAP_TEMPLATE_CATEGORY_FANTASY_GRASSLAND
	subtemplate_area = /area/shaded_hills/outside/poi

/datum/level_data/main_level/shaded_hills/grassland/get_mobs_to_populate_level()
	var/static/list/mobs_to_spawn = list(
		list(
			list(
				/mob/living/simple_animal/passive/mouse        = 9,
				/mob/living/simple_animal/passive/rabbit       = 3,
				/mob/living/simple_animal/passive/rabbit/brown = 3,
				/mob/living/simple_animal/passive/rabbit/black = 3,
				/mob/living/simple_animal/opossum              = 5
			),
			/turf/floor/grass,
			10
		)
	)
	return mobs_to_spawn

/datum/level_data/main_level/shaded_hills/swamp
	name = "Shaded Hills - Swamp"
	level_id = "shaded_hills_swamp"
	connected_levels = list(
		"shaded_hills_grassland" = NORTH
	)
	level_generators = list(
		/datum/random_map/noise/shaded_hills/swamp,
		/datum/random_map/noise/forage/shaded_hills/swamp
	)
	subtemplate_budget = 5
	subtemplate_category = MAP_TEMPLATE_CATEGORY_FANTASY_SWAMP
	subtemplate_area = /area/shaded_hills/outside/swamp/poi

/datum/level_data/main_level/shaded_hills/swamp/get_mobs_to_populate_level()
	var/static/list/mobs_to_spawn = list(
		list(
			list(
				/mob/living/simple_animal/passive/mouse        = 6,
				/mob/living/simple_animal/passive/rabbit       = 2,
				/mob/living/simple_animal/passive/rabbit/brown = 2,
				/mob/living/simple_animal/passive/rabbit/black = 2,
				/mob/living/simple_animal/frog                 = 3,
				/mob/living/simple_animal/frog/brown           = 2,
				/mob/living/simple_animal/frog/yellow          = 2,
				/mob/living/simple_animal/frog/purple          = 1
			),
			/turf/floor/grass,
			5
		),
		list(
			list(
				/mob/living/simple_animal/frog                 = 3,
				/mob/living/simple_animal/frog/brown           = 2,
				/mob/living/simple_animal/frog/yellow          = 2,
				/mob/living/simple_animal/frog/purple          = 1
			),
			/turf/floor/mud,
			10
		)
	)
	return mobs_to_spawn

/datum/level_data/main_level/shaded_hills/woods
	name = "Shaded Hills - Woods"
	level_id = "shaded_hills_woods"
	connected_levels = list(
		"shaded_hills_grassland" = SOUTH
	)
	level_generators = list(
		/datum/random_map/noise/shaded_hills/woods,
		/datum/random_map/noise/forage/shaded_hills/woods
	)
	subtemplate_budget = 5
	subtemplate_category = MAP_TEMPLATE_CATEGORY_FANTASY_WOODS
	subtemplate_area = /area/shaded_hills/outside/woods/poi

/datum/level_data/main_level/shaded_hills/woods/get_mobs_to_populate_level()
	var/static/list/mobs_to_spawn = list(
		list(
			list(
				/mob/living/simple_animal/passive/mouse        = 6,
				/mob/living/simple_animal/passive/rabbit       = 2,
				/mob/living/simple_animal/passive/rabbit/brown = 2,
				/mob/living/simple_animal/passive/rabbit/black = 2,
				/mob/living/simple_animal/opossum              = 2
			),
			/turf/floor/grass,
			10
		),
		list(
			list(
				/mob/living/simple_animal/passive/deer         = 1
			),
			/turf/floor/grass,
			5
		)
	)
	return mobs_to_spawn

/datum/level_data/main_level/shaded_hills/downlands
	name = "Shaded Hills - Downlands"
	level_id = "shaded_hills_downlands"
	level_generators = list(
		/datum/random_map/noise/shaded_hills/woods,
		/datum/random_map/noise/forage/shaded_hills/grassland
	)
	connected_levels = list(
		"shaded_hills_grassland" = WEST
	)
	subtemplate_budget = 5
	subtemplate_category = MAP_TEMPLATE_CATEGORY_FANTASY_DOWNLANDS
	subtemplate_area = /area/shaded_hills/outside/downlands/poi

/datum/level_data/main_level/shaded_hills/caverns
	name = "Shaded Hills - Caverns"
	level_id = "shaded_hills_caverns"
	connected_levels = list(
		"shaded_hills_dungeon" = EAST
	)
	subtemplate_budget = 5
	subtemplate_category = MAP_TEMPLATE_CATEGORY_FANTASY_CAVERNS
	subtemplate_area = /area/shaded_hills/caves/deep/poi
	level_generators = list(
		/datum/random_map/automata/cave_system/shaded_hills,
		/datum/random_map/noise/ore/rich
	)
	base_turf = /turf/floor/rock/basalt

/datum/level_data/main_level/shaded_hills/dungeon
	name = "Shaded Hills - Dungeon"
	level_id = "shaded_hills_dungeon"
	connected_levels = list(
		"shaded_hills_caverns" = WEST
	)
	subtemplate_budget = 5
	subtemplate_category = MAP_TEMPLATE_CATEGORY_FANTASY_DUNGEON
	subtemplate_area = /area/shaded_hills/caves/dungeon/poi
	base_turf = /turf/floor/rock/basalt

/obj/abstract/level_data_spawner/shaded_hills_grassland
	level_data_type = /datum/level_data/main_level/shaded_hills/grassland

/obj/abstract/level_data_spawner/shaded_hills_swamp
	level_data_type = /datum/level_data/main_level/shaded_hills/swamp

/obj/abstract/level_data_spawner/shaded_hills_woods
	level_data_type = /datum/level_data/main_level/shaded_hills/woods

/obj/abstract/level_data_spawner/shaded_hills_downlands
	level_data_type = /datum/level_data/main_level/shaded_hills/downlands

/obj/abstract/level_data_spawner/shaded_hills_caverns
	level_data_type = /datum/level_data/main_level/shaded_hills/caverns

/obj/abstract/level_data_spawner/shaded_hills_dungeon
	level_data_type = /datum/level_data/main_level/shaded_hills/dungeon
