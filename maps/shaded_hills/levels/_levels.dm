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

/datum/level_data/player_level/shaded_hills/grassland/after_generate_level()
	. = ..()
	// Neither of these procs handle laterally linked levels yet.
	SSweather.setup_weather_system(src)
	SSdaycycle.add_linked_levels(get_all_connected_level_ids() | level_id, start_at_night = FALSE, update_interval = 20 MINUTES)

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

/datum/level_data/player_level/shaded_hills/downlands
	name = "Shaded Hills - Downlands"
	level_id = "shaded_hills_downlands"
	level_generators = list(
		/datum/random_map/noise/forage/shaded_hills/grassland
	)
	connected_levels = list(
		"shaded_hills_grassland" = WEST
	)

/datum/level_data/player_level/shaded_hills/downlands/after_generate_level()
	. = ..()
	// Neither of these procs handle laterally linked levels yet.
	SSweather.setup_weather_system(src)
	SSdaycycle.add_linked_levels(get_all_connected_level_ids() | level_id, start_at_night = FALSE, update_interval = 20 MINUTES)

/obj/abstract/level_data_spawner/shaded_hills_grassland
	level_data_type = /datum/level_data/player_level/shaded_hills/grassland

/obj/abstract/level_data_spawner/shaded_hills_swamp
	level_data_type = /datum/level_data/player_level/shaded_hills/swamp

/obj/abstract/level_data_spawner/shaded_hills_woods
	level_data_type = /datum/level_data/player_level/shaded_hills/woods

/obj/abstract/level_data_spawner/shaded_hills_downlands
	level_data_type = /datum/level_data/player_level/shaded_hills/downlands
