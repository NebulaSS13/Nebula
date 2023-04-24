////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/chlorine
	name          = "chlorine exoplanet"
	desc          = "An exoplanet with a chlorine based ecosystem. Large quantities of liquid chlorine are present."
	color         = "#c9df9f"
	surface_color = "#a3b879"
	water_color   = COLOR_BOTTLE_GREEN

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/chlorine/get_atmosphere_color()
	return "#e5f2bd"

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/chlorine
	base_area           = /area/exoplanet/chlorine
	base_turf           = /turf/exterior/chlorine_sand
	exterior_atmosphere = null
	exterior_atmos_temp = null
	level_generators    = list(
		/datum/random_map/noise/exoplanet/chlorine,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////
// Fauna Generator
////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/exoplanet/chlorine
	name                       = "chlorine exoplanet"
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/chlorine
	flora_generator_type       = /datum/flora_generator/chlorine
	fauna_generator_type       = /datum/fauna_generator/chlorine
	ruin_tags_blacklist        = RUIN_HABITAT|RUIN_WATER
	surface_light_level_min    = 0.65
	surface_light_level_max    = 0.85
	atmosphere_temperature_min = T0C
	atmosphere_temperature_max = T100C
	template_parent_type       = /datum/map_template/planetoid/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/chlorine
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/chlorine,
		/datum/level_data/planetoid/exoplanet/underground
	)
	possible_rock_colors = list(
		COLOR_GRAY80,
		COLOR_PALE_GREEN_GRAY,
		COLOR_PALE_BTL_GREEN
	)
	map_generators = list(
		/datum/random_map/noise/ore/poor,
	)

/datum/map_template/planetoid/exoplanet/chlorine/generate_habitability(datum/planetoid_data/gen_data)
	gen_data.set_habitability(HABITABILITY_BAD)

/datum/map_template/planetoid/exoplanet/chlorine/get_mandatory_gasses()
	return list(/decl/material/gas/chlorine = MOLES_O2STANDARD)

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

/datum/random_map/noise/exoplanet/chlorine
	descriptor           = "chlorine exoplanet"
	land_type            = /turf/exterior/chlorine_sand
	water_type           = /turf/exterior/water/chlorine
	water_level_min      = 2
	water_level_max      = 3
	fauna_prob           = 2
	flora_prob           = 5
	large_flora_prob     = 0
	smoothing_iterations = 3

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

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