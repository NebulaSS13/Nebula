/obj/abstract/map_data/ministation
	height = 2

/datum/level_data/main_level/ministation
	use_global_exterior_ambience = FALSE
	base_area = null
	base_turf = /turf/floor/dirt
	abstract_type = /datum/level_data/main_level/ministation
	ambient_light_level = 1
	ambient_light_color = "#f3e6ca"
	//strata = /decl/strata/shaded_hills
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

/obj/abstract/level_data_spawner/ministation
	level_data_type = /datum/level_data/main_level/ministation