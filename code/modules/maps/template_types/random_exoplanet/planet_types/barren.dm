////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/barren
	name          = "barren exoplanet"
	desc          = "A planet that couldn't hold its atmosphere from either low gravity, or the lack of a strong magnetosphere, or even from intense solar winds."
	color         = "#6c6c6c"
	surface_color = "#807d7a"
	water_color   = null

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/barren
	base_area           = /area/exoplanet/barren
	base_turf           = /turf/exterior/barren
	exterior_atmosphere = null //Generate me
	exterior_atmos_temp = null //Generate me
	level_generators    = list(
		/datum/random_map/noise/exoplanet/barren,
		/datum/random_map/noise/ore/rich,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/planet_flora/random/barren
	has_trees = FALSE
/datum/planet_flora/random/barren/New()
	. = ..()
	if(prob(10))
		flora_diversity = 1

////////////////////////////////////////////////////////////////////////////
// Planetoid Data
////////////////////////////////////////////////////////////////////////////

//#FIXME: Barren is kind of a wide encompassing planet type. There's a lot of extremes to take into accounts for a single type..

/datum/planetoid_data/random/barren
	habitability_class             = null
	flora                          = /datum/planet_flora/random/barren
	atmosphere_gen_pressure_min    = 0.01 ATM
	atmosphere_gen_pressure_max    = 0.05 ATM
	atmosphere_gen_temperature_min = -240 CELSIUS //-240c is about the surface temp of pluto for ref
	atmosphere_gen_temperature_max = 450 CELSIUS //450c is the temperature at the surface of mercury for ref
	possible_rock_colors           = list(
		COLOR_BEIGE,
		COLOR_GRAY80,
		COLOR_BROWN
	)

/datum/planetoid_data/random/barren/generate_habitability()
	//Barren worlds should definitely not be habitable by definition
	if(isnull(habitability_class))
		if(prob(30))
			. = HABITABILITY_BAD
		else
			. = HABITABILITY_DEAD
	else
		. = habitability_class
	set_habitability(.)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

///Template for spawning a randomly generated barren exoplanet.
/datum/map_template/planetoid/random/exoplanet/barren
	name                       = "barren exoplanet"
	planetoid_data_type        = /datum/planetoid_data/random/barren
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/barren
	ruin_tags_blacklist        = RUIN_HABITAT|RUIN_WATER
	subtemplate_budget         = 6
	template_parent_type       = /datum/map_template/planetoid/random/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/barren
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/barren,     //surface level
		/datum/level_data/planetoid/exoplanet/underground //bottom level
	)
	template_categories   = list(
		MAP_TEMPLATE_CATEGORY_EXOPLANET
	)
	possible_themes = list(
		/datum/exoplanet_theme/mountains
	)

/datum/map_template/planetoid/random/exoplanet/barren/get_spawn_weight()
	return 50

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

///Generator for fauna and flora spawners for the surface of the barren exoplanet
/datum/random_map/noise/exoplanet/barren
	descriptor           = "barren exoplanet"
	land_type            = /turf/exterior/barren
	flora_prob           = 0.1
	large_flora_prob     = 0
	fauna_prob           = 0
	smoothing_iterations = 4

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

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
