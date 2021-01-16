/obj/effect/overmap/visitable/sector/exoplanet/chlorine
	name = "chlorine exoplanet"
	desc = "An exoplanet with a chlorine based ecosystem. Large quantities of liquid chlorine are present."
	color = "#c9df9f"
	planetary_area = /area/exoplanet/chlorine
	rock_colors = list(COLOR_GRAY80, COLOR_PALE_GREEN_GRAY, COLOR_PALE_BTL_GREEN)
	plant_colors = list("#eba487", "#ceeb87", "#eb879c", "#ebd687", "#f6d6c9", "#f2b3e0")
	map_generators = list(/datum/random_map/noise/exoplanet/chlorine, /datum/random_map/noise/ore/poor)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	surface_color = "#a3b879"
	water_color = COLOR_BOTTLE_GREEN
	has_trees = FALSE
	flora_diversity = 5
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/hostile/retaliate/beast/samak/alt, /mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/retaliate/jelly)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/jelly/mega)

/obj/effect/overmap/visitable/sector/exoplanet/chlorine/generate_habitability()
	habitability_class =  HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/chlorine/get_atmosphere_color()
	return "#e5f2bd"

/obj/effect/overmap/visitable/sector/exoplanet/chlorine/generate_map()
	if(prob(50))
		lightlevel = rand(7,10)/10 //It could be night.
	else
		lightlevel = 0.1
	..()

/obj/effect/overmap/visitable/sector/exoplanet/chlorine/get_target_temperature()
	return T0C - rand(0, 100)

/obj/effect/overmap/visitable/sector/exoplanet/chlorine/get_mandatory_gasses()
	return list(/decl/material/gas/chlorine = MOLES_O2STANDARD)

/datum/random_map/noise/exoplanet/chlorine
	descriptor = "chlorine exoplanet"
	smoothing_iterations = 3
	land_type = /turf/exterior/chlorine_sand
	water_type = /turf/exterior/water/chlorine
	water_level_min = 2
	water_level_max = 3
	fauna_prob = 2
	flora_prob = 5
	large_flora_prob = 0

/area/exoplanet/chlorine
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/exterior/chlorine_sand
