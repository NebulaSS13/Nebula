/obj/effect/overmap/visitable/sector/exoplanet/snow
	name = "snow exoplanet"
	desc = "Cold planet with limited plant life."
	color = "#dcdcdc"
	planetary_area = /area/exoplanet/snow
	rock_colors = list(COLOR_DARK_BLUE_GRAY, COLOR_GUNMETAL, COLOR_GRAY80, COLOR_DARK_GRAY)
	plant_colors = list("#d0fef5","#93e1d8","#93e1d8", "#b2abbf", "#3590f3", "#4b4e6d")
	map_generators = list(
		/datum/random_map/automata/cave_system/mountains/snow,
		/datum/random_map/noise/exoplanet/snow, 
		/datum/random_map/noise/ore/poor
	)
	surface_color = "#e8faff"
	water_color = "#b5dfeb"
	fauna_types = list(/mob/living/simple_animal/hostile/retaliate/beast/samak, /mob/living/simple_animal/hostile/retaliate/beast/diyaab, /mob/living/simple_animal/hostile/retaliate/beast/shantak)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/giant_crab)
	water_material = null // Will prevent the weather system causing rainfall.
	weather_system = /decl/state/weather/snow

/obj/effect/overmap/visitable/sector/exoplanet/snow/get_target_temperature()
	return T0C - rand(10, 100)

/datum/random_map/automata/cave_system/mountains/snow
	iterations = 2
	descriptor = "ice mountains"
	wall_type =  /turf/exterior/wall/ice
	mineral_turf = /turf/exterior/wall/random/ice
	rock_color = COLOR_CYAN_BLUE

/datum/random_map/noise/exoplanet/snow
	descriptor = "snow exoplanet"
	smoothing_iterations = 1
	flora_prob = 5
	large_flora_prob = 10
	water_level_max = 3
	land_type = /turf/exterior/snow
	water_type = /turf/exterior/ice

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/exterior/snow/
