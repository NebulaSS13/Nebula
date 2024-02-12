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
	base_area                      = /area/exoplanet/chlorine
	base_turf                      = /turf/exterior/chlorine_sand
	exterior_atmosphere            = null
	exterior_atmos_temp            = null
	level_generators               = list(
		/datum/random_map/noise/exoplanet/chlorine,
		/datum/random_map/noise/ore/poor,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/planet_flora/random/chlorine
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
// Planetoid Data
////////////////////////////////////////////////////////////////////////////
/datum/planetoid_data/random/chlorine
	habitability_class             = null
	forced_atmosphere_gen_gases    = list(/decl/material/gas/chlorine = MOLES_O2STANDARD)
	atmosphere_gen_pressure_min    = 0.01 ATM
	atmosphere_gen_pressure_max    = 0.05 ATM
	atmosphere_gen_temperature_min = T0C
	atmosphere_gen_temperature_max = T100C
	surface_light_gen_level_min    = 0.65
	surface_light_gen_level_max    = 0.85
	flora                          = /datum/planet_flora/random/chlorine
	fauna                          = /datum/fauna_generator/chlorine
	possible_rock_colors           = list(
		COLOR_GRAY80,
		COLOR_PALE_GREEN_GRAY,
		COLOR_PALE_BTL_GREEN
	)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/random/exoplanet/chlorine
	name                       = "chlorine exoplanet"
	planetoid_data_type        = /datum/planetoid_data/random/chlorine
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/chlorine
	ruin_tags_blacklist        = RUIN_HABITAT|RUIN_WATER
	template_parent_type       = /datum/map_template/planetoid/random/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/chlorine
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/chlorine,
		/datum/level_data/planetoid/exoplanet/underground
	)

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