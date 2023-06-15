#define NEUTRALIA_SKY_LEVEL_ID     "neutralia_sky"
#define NEUTRALIA_SURFACE_LEVEL_ID "neutralia_surface"

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Atmosphere
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/gas_mixture/atmos_neutralia
	temperature = T20C
	gas = list(
		/decl/material/gas/oxygen   = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD,
	)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Flora
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/planet_flora/random/neutralia
	flora_diversity = 2
	has_trees       = TRUE
	grass_color     = COLOR_GRAY80
	plant_colors    = list(
		COLOR_SURGERY_BLUE,
		COLOR_SILVER,
		COLOR_GRAY80,
		COLOR_OFF_WHITE
	)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Fauna
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/fauna_generator/neutralia
	max_fauna_alive     = 10
	max_megafauna_alive = 0
	fauna_types         = list(
		/mob/living/simple_animal/yithian,
	)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Overmap Marker
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/neutralia
	name         = "Neutralia"
	color        = COLOR_GRAY
	planetoid_id = "neutralia"
	start_x      = 10
	start_y      = 10

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Planetoid Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/planetoid_data/neutralia
	id                  = "neutralia"
	name                = "\improper Neutralia"
	topmost_level_id    = NEUTRALIA_SKY_LEVEL_ID
	surface_level_id    = NEUTRALIA_SURFACE_LEVEL_ID
	habitability_class  = HABITABILITY_OKAY
	atmosphere          = /datum/gas_mixture/atmos_neutralia
	surface_color       = COLOR_GRAY
	water_color         = COLOR_BLUE_GRAY
	rock_color          = COLOR_GRAY40
	has_rings           = TRUE
	ring_color          = COLOR_OFF_WHITE
	ring_type_name      = SKYBOX_PLANET_RING_TYPE_SPARSE
	strata              = /decl/strata/sedimentary
	engraving_generator = /datum/xenoarch_engraving_flavor
	day_duration        = 12 MINUTES
	surface_light_level = 0.5
	surface_light_color = COLOR_OFF_WHITE
	flora               = /datum/planet_flora/random/neutralia
	fauna               = /datum/fauna_generator/neutralia

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Neutralia Template
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/neutralia
	name                  = "Neutralia"
	template_categories   = list(MAP_TEMPLATE_CATEGORY_PLANET)
	template_flags        = TEMPLATE_FLAG_SPAWN_GUARANTEED
	planetoid_data_type   = /datum/planetoid_data/neutralia
	level_data_type       = null //We have our own level_data
	mappaths              = list(
		"maps/planets/test_planet/neutralia-1.dmm",
		"maps/planets/test_planet/neutralia-2.dmm",
		"maps/planets/test_planet/neutralia-3.dmm",
		"maps/planets/test_planet/neutralia-4.dmm",
	)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Areas
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/area/exoplanet/neutralia
	name = "surface"

/area/exoplanet/neutralia/sky
	name = "sky"

/area/exoplanet/underground/neutralia
	name = "underground"

/area/exoplanet/underground/neutralia/bottom
	name = "abyssal depths"

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Level Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/neutralia
	parent_planetoid     = "neutralia"
	level_max_width      = 128
	level_max_height     = 128
	loop_turf_type       = /turf/unsimulated/mimic_edge/transition/loop

/datum/level_data/planetoid/neutralia/sky
	name             = "neutralia sky"
	level_id         = NEUTRALIA_SKY_LEVEL_ID
	base_area        = /area/exoplanet/neutralia/sky
	base_turf        = /turf/exterior/open
	border_filler    = /turf/unsimulated/dark_filler

/datum/level_data/planetoid/neutralia/surface
	name             = "neutralia surface"
	level_id         = NEUTRALIA_SURFACE_LEVEL_ID
	base_area        = /area/exoplanet/neutralia
	base_turf        = /turf/exterior/barren
	border_filler    = /turf/unsimulated/dark_filler

/datum/level_data/planetoid/neutralia/underground
	name             = "neutralia underground"
	level_id         = "neutralia_underground"
	base_area        = /area/exoplanet/underground/neutralia
	base_turf        = /turf/exterior/barren
	border_filler    = /turf/unsimulated/mineral

/datum/level_data/planetoid/neutralia/underground/bottom
	name      = "neutralia abyssal depths"
	level_id  = "neutralia_abyssal_depths"
	base_area = /area/exoplanet/underground/neutralia/bottom
	base_turf = /turf/exterior/volcanic

/obj/abstract/level_data_spawner/neutralia/sky
	level_data_type = /datum/level_data/planetoid/neutralia/sky

/obj/abstract/level_data_spawner/neutralia/surface
	level_data_type = /datum/level_data/planetoid/neutralia/surface

/obj/abstract/level_data_spawner/neutralia/underground
	level_data_type = /datum/level_data/planetoid/neutralia/underground

/obj/abstract/level_data_spawner/neutralia/bottom
	level_data_type = /datum/level_data/planetoid/neutralia/underground/bottom

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Neutralia Map Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/abstract/map_data/neutralia
	height = 4

#undef NEUTRALIA_SKY_LEVEL_ID
#undef NEUTRALIA_SURFACE_LEVEL_ID