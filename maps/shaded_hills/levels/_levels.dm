/obj/abstract/map_data/shaded_hills
	height = 2

/datum/level_data/player_level/shaded_hills
	use_global_exterior_ambience = FALSE
	base_area = null
	abstract_type = /datum/level_data/player_level/shaded_hills
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

	var/submap_budget   = 0
	var/submap_category = null
	var/submap_area
	var/list/mobs_to_spawn = list()

/datum/daycycle/shaded_hills
	cycle_duration = 2 HOURS // 1 hour of daylight, 1 hour of night

// Randomized time of day to start at.
/datum/daycycle/shaded_hills/New()
	time_in_cycle = rand(cycle_duration)
	..()

/datum/level_data/player_level/shaded_hills/get_subtemplate_areas(template_category, blacklist, whitelist)
	return submap_area ? (islist(submap_area) ? submap_area : list(submap_area)) : null

/datum/level_data/player_level/shaded_hills/get_subtemplate_budget()
	return submap_budget

/datum/level_data/player_level/shaded_hills/get_subtemplate_category()
	return submap_category

/datum/level_data/player_level/shaded_hills/after_generate_level()
	. = ..()
	if(length(mobs_to_spawn))
		for(var/list/mob_category in mobs_to_spawn)
			var/list/mob_types = mob_category[1]
			var/mob_turf  = mob_category[2]
			var/mob_count = mob_category[3]
			var/sanity = 1000
			while(mob_count && sanity)
				sanity--
				var/turf/place_mob_at = locate(rand(level_inner_min_x, level_inner_max_x), rand(level_inner_min_y, level_inner_max_y), level_z)
				if(istype(place_mob_at, mob_turf) && !(locate(/mob/living) in place_mob_at))
					var/mob_type = pickweight(mob_types)
					new mob_type(place_mob_at)
					mob_count--
					CHECK_TICK

/datum/level_data/player_level/shaded_hills/grassland
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
	submap_budget = 5
	submap_category = MAP_TEMPLATE_CATEGORY_SH_GRASSLAND
	submap_area = /area/shaded_hills/outside/poi

	mobs_to_spawn = list(
		list(
			list(
				/mob/living/simple_animal/passive/mouse        = 9,
				/mob/living/simple_animal/passive/rabbit       = 3,
				/mob/living/simple_animal/passive/rabbit/brown = 3,
				/mob/living/simple_animal/passive/rabbit/black = 3,
				/mob/living/simple_animal/opossum              = 5
			),
			/turf/floor/natural/grass,
			10
		)
	)


/datum/level_data/player_level/shaded_hills/swamp
	name = "Shaded Hills - Swamp"
	level_id = "shaded_hills_swamp"
	connected_levels = list(
		"shaded_hills_grassland" = NORTH
	)
	level_generators = list(
		/datum/random_map/noise/shaded_hills/swamp,
		/datum/random_map/noise/forage/shaded_hills/swamp
	)
	submap_budget = 5
	submap_category = MAP_TEMPLATE_CATEGORY_SH_SWAMP
	submap_area = /area/shaded_hills/outside/swamp/poi

	mobs_to_spawn = list(
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
			/turf/floor/natural/grass,
			5
		),
		list(
			list(
				/mob/living/simple_animal/frog                 = 3,
				/mob/living/simple_animal/frog/brown           = 2,
				/mob/living/simple_animal/frog/yellow          = 2,
				/mob/living/simple_animal/frog/purple          = 1
			),
			/turf/floor/natural/mud,
			10
		)
	)

/datum/level_data/player_level/shaded_hills/woods
	name = "Shaded Hills - Woods"
	level_id = "shaded_hills_woods"
	connected_levels = list(
		"shaded_hills_grassland" = SOUTH
	)
	level_generators = list(
		/datum/random_map/noise/shaded_hills/woods,
		/datum/random_map/noise/forage/shaded_hills/woods
	)
	submap_budget = 5
	submap_category = MAP_TEMPLATE_CATEGORY_SH_WOODS
	submap_area = /area/shaded_hills/outside/woods/poi

	mobs_to_spawn = list(
		list(
			list(
				/mob/living/simple_animal/passive/mouse        = 6,
				/mob/living/simple_animal/passive/rabbit       = 2,
				/mob/living/simple_animal/passive/rabbit/brown = 2,
				/mob/living/simple_animal/passive/rabbit/black = 2,
				/mob/living/simple_animal/opossum              = 2
			),
			/turf/floor/natural/grass,
			10
		),
		list(
			list(
				/mob/living/simple_animal/passive/deer         = 1
			),
			/turf/floor/natural/grass,
			5
		)
	)

/datum/level_data/player_level/shaded_hills/downlands
	name = "Shaded Hills - Downlands"
	level_id = "shaded_hills_downlands"
	level_generators = list(
		/datum/random_map/noise/shaded_hills/woods,
		/datum/random_map/noise/forage/shaded_hills/grassland
	)
	connected_levels = list(
		"shaded_hills_grassland" = WEST
	)
	submap_budget = 5
	submap_category = MAP_TEMPLATE_CATEGORY_SH_DOWNLANDS
	submap_area = /area/shaded_hills/outside/downlands/poi

/datum/level_data/player_level/shaded_hills/caverns
	name = "Shaded Hills - Caverns"
	level_id = "shaded_hills_caverns"
	connected_levels = list(
		"shaded_hills_dungeon" = EAST
	)
	submap_budget = 5
	submap_category = MAP_TEMPLATE_CATEGORY_SH_CAVERNS
	submap_area = /area/shaded_hills/caves/deep/poi
	level_generators = list(
		/datum/random_map/automata/cave_system/shaded_hills,
		/datum/random_map/noise/ore/rich
	)

/datum/level_data/player_level/shaded_hills/dungeon
	name = "Shaded Hills - Dungeon"
	level_id = "shaded_hills_dungeon"
	connected_levels = list(
		"shaded_hills_caverns" = WEST
	)
	submap_budget = 5
	submap_category = MAP_TEMPLATE_CATEGORY_SH_DUNGEON
	submap_area = /area/shaded_hills/caves/dungeon/poi

/obj/abstract/level_data_spawner/shaded_hills_grassland
	level_data_type = /datum/level_data/player_level/shaded_hills/grassland

/obj/abstract/level_data_spawner/shaded_hills_swamp
	level_data_type = /datum/level_data/player_level/shaded_hills/swamp

/obj/abstract/level_data_spawner/shaded_hills_woods
	level_data_type = /datum/level_data/player_level/shaded_hills/woods

/obj/abstract/level_data_spawner/shaded_hills_downlands
	level_data_type = /datum/level_data/player_level/shaded_hills/downlands

/obj/abstract/level_data_spawner/shaded_hills_caverns
	level_data_type = /datum/level_data/player_level/shaded_hills/caverns

/obj/abstract/level_data_spawner/shaded_hills_dungeon
	level_data_type = /datum/level_data/player_level/shaded_hills/dungeon
