////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/snow
	name          = "snow exoplanet"
	desc          = "Cold planet with limited plant life."
	color         = "#dcdcdc"
	surface_color = "#e8faff"
	water_color   = "#b5dfeb"

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/snow
	base_area = /area/exoplanet/snow
	base_turf = /turf/exterior/snow
	exterior_atmosphere = null
	exterior_atmos_temp = null
	level_generators = list(
		/datum/random_map/noise/exoplanet/snow,
		/datum/random_map/noise/ore/poor,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/planet_flora/random/snow
	plant_colors = list(
		"#d0fef5",
		"#93e1d8",
		"#93e1d8",
		"#b2abbf",
		"#3590f3",
		"#4b4e6d"
	)

////////////////////////////////////////////////////////////////////////////
// Fauna Generator
////////////////////////////////////////////////////////////////////////////

/datum/fauna_generator/snow
	fauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/beast/samak,
		/mob/living/simple_animal/hostile/retaliate/beast/diyaab,
		/mob/living/simple_animal/hostile/retaliate/beast/shantak
	)
	megafauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/giant_crab
	)

////////////////////////////////////////////////////////////////////////////
// Planetoid Data
////////////////////////////////////////////////////////////////////////////

/datum/planetoid_data/random/snow
	habitability_class             = null
	atmosphere_gen_temperature_min = -120 CELSIUS // a bit lower than arctic temperatures
	atmosphere_gen_temperature_max = -10 CELSIUS
	initial_weather_state          = /decl/state/weather/snow
	flora                          = /datum/planet_flora/random/snow
	fauna                          = /datum/fauna_generator/snow
	possible_rock_colors           = list(
		COLOR_DARK_BLUE_GRAY,
		COLOR_GUNMETAL,
		COLOR_GRAY80,
		COLOR_DARK_GRAY
	)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/random/exoplanet/snow
	name                       = "snow exoplanet"
	planetoid_data_type        = /datum/planetoid_data/random/snow
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/snow
	template_parent_type       = /datum/map_template/planetoid/random/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/snow
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/snow,
		/datum/level_data/planetoid/exoplanet/underground
	)
	//#TODO: Do weather stuff to init properly
	//water_material  = null // Will prevent the weather system causing rainfall.

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

/datum/random_map/noise/exoplanet/snow
	descriptor           = "snow exoplanet"
	flora_prob           = 5
	large_flora_prob     = 10
	water_level_max      = 3
	land_type            = /turf/exterior/snow
	water_type           = /turf/exterior/ice
	smoothing_iterations = 1

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

/area/exoplanet/snow
	base_turf = /turf/exterior/snow
	ambience  = list(
		'sound/effects/wind/tundra0.ogg',
		'sound/effects/wind/tundra1.ogg',
		'sound/effects/wind/tundra2.ogg',
		'sound/effects/wind/spooky0.ogg',
		'sound/effects/wind/spooky1.ogg'
	)
