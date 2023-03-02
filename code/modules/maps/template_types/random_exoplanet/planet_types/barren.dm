/obj/effect/overmap/visitable/sector/planetoid/exoplanet/barren
	name = "barren exoplanet"
	desc = "An exoplanet that couldn't hold its atmosphere."
	color = "#6c6c6c"
	surface_color = "#807d7a"
	water_color =    null

/datum/level_data/planetoid/exoplanet/barren
	base_area = /area/exoplanet/barren
	base_turf = /turf/exterior/barren
	exterior_atmosphere = null
	exterior_atmos_temp = null

/datum/flora_generator/barren
	has_trees = FALSE
/datum/flora_generator/barren/New()
	. = ..()
	if(prob(10))
		flora_diversity = 1

/datum/map_template/planetoid/exoplanet/barren
	name                  = "barren exoplanet"
	level_data_type       = /datum/level_data/planetoid/exoplanet/barren
	overmap_marker_type   = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/barren
	flora_generator_type  = /datum/flora_generator/barren
	ruin_tags_blacklist   = RUIN_HABITAT|RUIN_WATER
	subtemplate_budget    = 6
	initial_weather_state = null
	template_parent_type  = /datum/map_template/planetoid/exoplanet
	template_categories   = list(
		MAP_TEMPLATE_CATEGORY_EXOPLANET
	)
	possible_rock_colors  = list(
		COLOR_BEIGE,
		COLOR_GRAY80,
		COLOR_BROWN
	)
	possible_themes = list(
		/datum/exoplanet_theme/mountains
	)
	map_generators = list(
		/datum/random_map/noise/exoplanet/barren,
		/datum/random_map/noise/ore/rich
	)

/datum/map_template/planetoid/exoplanet/barren/get_spawn_weight()
	return 50

/datum/map_template/planetoid/exoplanet/barren/get_target_pressure()
	return ONE_ATMOSPHERE * 0.05

/datum/map_template/planetoid/exoplanet/barren/generate_habitability(datum/planetoid_data/gen_data)
	gen_data.set_habitability(HABITABILITY_BAD)

/datum/random_map/noise/exoplanet/barren
	descriptor = "barren exoplanet"
	smoothing_iterations = 4
	land_type = /turf/exterior/barren
	flora_prob = 0.1
	large_flora_prob = 0
	fauna_prob = 0

/area/exoplanet/barren
	name       = "\improper Planetary surface"
	base_turf  = /turf/exterior/barren
	is_outside = OUTSIDE_YES
	ambience   = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/effects/wind/wind_4_2.ogg',
		'sound/effects/wind/wind_5_1.ogg'
	)