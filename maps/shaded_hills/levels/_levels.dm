/datum/level_data/player_level/shaded_hills
	use_global_exterior_ambience = FALSE
	base_area = null
	abstract_type = /datum/level_data/player_level/shaded_hills

/datum/level_data/player_level/shaded_hills/embark
	name = "Embark"
	ambient_light_level = 1
	ambient_light_color = "#f3e6ca"
	strata = /decl/strata/shaded_hills
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	level_generators = list(
		/datum/random_map/automata/cave_system/shaded_hills,
		/datum/random_map/noise/ore/poor,
		/datum/random_map/noise/forage
	)

/datum/level_data/player_level/shaded_hills/embark/after_generate_level()
	. = ..()
	SSweather.setup_weather_system(src)
	SSdaycycle.add_linked_levels(get_all_connected_level_ids() | level_id, start_at_night = FALSE, update_interval = 20 MINUTES)

/obj/abstract/level_data_spawner/shaded_hills
	level_data_type = /datum/level_data/player_level/shaded_hills/embark
