/obj/effect/overmap/visitable/sector/exoplanet/volcanic
	name = "volcanic exoplanet"
	desc = "A tectonically unstable planet, extremely rich in minerals."
	color = "#9c2020"
	planetary_area = /area/exoplanet/volcanic
	rock_colors = list(COLOR_DARK_GRAY)
	plant_colors = list("#a23c05","#3f1f0d","#662929","#ba6222","#7a5b3a","#471429")
	max_themes = 1
	possible_themes = list(
		/datum/exoplanet_theme = 100,
		/datum/exoplanet_theme/robotic_guardians = 10
	)
	map_generators = list(
		/datum/random_map/automata/cave_system/mountains/volcanic, 
		/datum/random_map/noise/exoplanet/volcanic, 
		/datum/random_map/noise/ore/filthy_rich
	)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	surface_color = "#261e19"
	water_color = "#c74d00"
	flora_diversity = 3
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/hostile/retaliate/beast/shantak/lava, /mob/living/simple_animal/hostile/retaliate/beast/charbaby)
	megafauna_types = list(/mob/living/simple_animal/hostile/drake)
	has_trees = FALSE

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/get_atmosphere_color()
	return COLOR_GRAY20

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/generate_habitability()
	habitability_class =  HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/get_target_temperature()
	return T20C + rand(220, 800)

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/adapt_seed(var/datum/seed/S)
	..()
	S.set_trait(TRAIT_REQUIRES_WATER,0)
	S.set_trait(TRAIT_HEAT_TOLERANCE, 1000 + S.get_trait(TRAIT_HEAT_TOLERANCE))

/obj/effect/overmap/visitable/sector/exoplanet/volcanic/adapt_animal(var/mob/living/simple_animal/A)
	..()
	A.heat_damage_per_tick = 0 //animals not hot, no burning in lava

/datum/random_map/noise/exoplanet/volcanic
	descriptor = "volcanic exoplanet"
	smoothing_iterations = 5
	land_type = /turf/exterior/volcanic
	water_type = /turf/exterior/lava
	water_level_min = 5
	water_level_max = 6

	fauna_prob = 1
	flora_prob = 3
	grass_prob = 0
	large_flora_prob = 0

//Squashing most of 1 tile lava puddles
/datum/random_map/noise/exoplanet/volcanic/cleanup()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(noise2value(map[current_cell]) < water_level)
				continue
			var/frendos
			for(var/dx in list(-1,0,1))
				for(var/dy in list(-1,0,1))
					var/tmp_cell = get_map_cell(x+dx,y+dy)
					if(tmp_cell && tmp_cell != current_cell && noise2value(map[tmp_cell]) >= water_level)
						frendos = 1
						break
			if(!frendos)
				map[current_cell] = 1

/area/exoplanet/volcanic
	forced_ambience = list('sound/ambience/magma.ogg')
	base_turf = /turf/exterior/volcanic

/datum/random_map/automata/cave_system/mountains/volcanic
	iterations = 2
	descriptor = "space volcanic mountains"
	wall_type =  /turf/simulated/wall/natural/volcanic
	mineral_turf =  /turf/simulated/wall/natural/random/volcanic
	rock_color = COLOR_DARK_GRAY

/datum/random_map/automata/cave_system/mountains/volcanic/get_additional_spawns(value, var/turf/simulated/wall/natural/T)
	..()
	if(use_area && istype(T))
		T.floor_type = prob(90) ? use_area.base_turf : /turf/exterior/lava
