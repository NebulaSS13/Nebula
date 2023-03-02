/obj/effect/overmap/visitable/sector/planetoid/exoplanet/chlorine
	name          = "chlorine exoplanet"
	desc          = "An exoplanet with a chlorine based ecosystem. Large quantities of liquid chlorine are present."
	color         = "#c9df9f"
	surface_color = "#a3b879"
	water_color   = COLOR_BOTTLE_GREEN

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/chlorine/get_atmosphere_color()
	return "#e5f2bd"

/datum/level_data/planetoid/exoplanet/chlorine
	base_area = /area/exoplanet/chlorine
	base_turf = /turf/exterior/chlorine_sand
	exterior_atmosphere = null
	exterior_atmos_temp = null

/datum/flora_generator/chlorine
	has_trees       = FALSE
	flora_diversity = 5
	plant_colors    = list(
		"#eba487",
		"#ceeb87",
		"#eb879c",
		"#ebd687",
		"#f6d6c9",
		"#f2b3e0"
	)

/datum/fauna_generator/chlorine
	fauna_types = list(
		/mob/living/simple_animal/thinbug,
		/mob/living/simple_animal/hostile/retaliate/beast/samak/alt,
		/mob/living/simple_animal/yithian,
		/mob/living/simple_animal/tindalos,
		/mob/living/simple_animal/hostile/retaliate/jelly,
	)
	megafauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/jelly/mega,
	)

/datum/map_template/planetoid/exoplanet/chlorine
	name                 = "chlorine exoplanet"
	level_data_type      = /datum/level_data/planetoid/exoplanet/chlorine
	overmap_marker_type  = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/desert
	flora_generator_type = /datum/flora_generator/chlorine
	fauna_generator_type = /datum/fauna_generator/chlorine
	ruin_tags_blacklist  = RUIN_HABITAT|RUIN_WATER
	template_parent_type = /datum/map_template/planetoid/exoplanet
	possible_rock_colors = list(
		COLOR_GRAY80,
		COLOR_PALE_GREEN_GRAY,
		COLOR_PALE_BTL_GREEN
	)
	map_generators       = list(
		/datum/random_map/noise/exoplanet/chlorine,
		/datum/random_map/noise/ore/poor,
	)

/datum/map_template/planetoid/exoplanet/chlorine/generate_habitability(datum/planetoid_data/gen_data)
	gen_data.set_habitability(HABITABILITY_BAD)

/datum/map_template/planetoid/exoplanet/chlorine/get_target_temperature()
	return T0C - rand(0, 100)

/datum/map_template/planetoid/exoplanet/chlorine/get_mandatory_gasses()
	return list(/decl/material/gas/chlorine = MOLES_O2STANDARD)

/datum/map_template/planetoid/exoplanet/chlorine/generate_daycycle(datum/planetoid_data/gen_data, datum/level_data/surface_level)
	if(prob(50))
		surface_level.ambient_light_level = rand(7,10)/10 //It could be night.
	else
		surface_level.ambient_light_level = 0.1
	. = ..()

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
	ambience = list(
		'sound/effects/wind/desert0.ogg',
		'sound/effects/wind/desert1.ogg',
		'sound/effects/wind/desert2.ogg',
		'sound/effects/wind/desert3.ogg',
		'sound/effects/wind/desert4.ogg',
		'sound/effects/wind/desert5.ogg'
	)
	base_turf = /turf/exterior/chlorine_sand