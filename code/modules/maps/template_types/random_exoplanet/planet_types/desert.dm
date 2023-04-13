////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/desert
	name          = "desert exoplanet"
	desc          = "An arid exoplanet with sparse biological resources but rich mineral deposits underground."
	color         = "#a08444"
	surface_color = "#d6cca4"
	water_color   = null

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/desert
	base_turf           = /turf/exterior/sand
	base_area           = /area/exoplanet/desert
	exterior_atmosphere = null
	exterior_atmos_temp = null
	level_generators    = list(
		/datum/random_map/noise/exoplanet/desert
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/flora_generator/desert
	has_trees       = FALSE
	flora_diversity = 4
	plant_colors    = list(
		"#efdd6f",
		"#7b4a12",
		"#e49135",
		"#ba6222",
		"#5c755e",
		"#701732"
	)

/datum/flora_generator/desert/adapt_seed(var/datum/seed/S)
	..()
	if(prob(90))
		S.set_trait(TRAIT_REQUIRES_WATER,0)
	else
		S.set_trait(TRAIT_REQUIRES_WATER,1)
		S.set_trait(TRAIT_WATER_CONSUMPTION,1)
	if(prob(75))
		S.set_trait(TRAIT_STINGS,1)
	if(prob(75))
		S.set_trait(TRAIT_CARNIVOROUS,2)
	S.set_trait(TRAIT_SPREAD,0)

////////////////////////////////////////////////////////////////////////////
// Fauna Generator
////////////////////////////////////////////////////////////////////////////

/datum/fauna_generator/desert
	fauna_types           = list(
		/mob/living/simple_animal/thinbug,
		/mob/living/simple_animal/tindalos,
		/mob/living/simple_animal/hostile/slug,
		/mob/living/simple_animal/hostile/antlion,
	)
	megafauna_types = list(
		/mob/living/simple_animal/hostile/antlion/mega,
	)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/exoplanet/desert
	name                       = "desert exoplanet"
	flora_generator_type       = /datum/flora_generator/desert
	fauna_generator_type       = /datum/fauna_generator/desert
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/desert
	initial_weather_state      = null //#TODO: Make desert weather stuff
	surface_light_level_min    = 0.5
	surface_light_level_max    = 0.95
	atmosphere_temperature_min = 40 CELSIUS
	atmosphere_temperature_max = 120 CELSIUS
	template_parent_type       = /datum/map_template/planetoid/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/desert
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/desert,
		/datum/level_data/planetoid/exoplanet/underground
	)
	possible_rock_colors = list(
		COLOR_BEIGE,
		COLOR_PALE_YELLOW,
		COLOR_GRAY80,
		COLOR_BROWN
	)
	map_generators = list(
		/datum/random_map/noise/ore/rich,
	)

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

/datum/random_map/noise/exoplanet/desert
	descriptor           = "desert exoplanet"
	land_type            = /turf/exterior/sand
	flora_prob           = 5
	grass_prob           = 2
	large_flora_prob     = 0
	smoothing_iterations = 4

/datum/random_map/noise/exoplanet/desert/get_additional_spawns(var/value, var/turf/T)
	..()
	var/v = noise2value(value)
	if(v > 6 && prob(10))
		new/obj/effect/quicksand(T)

/datum/random_map/noise/exoplanet/desert/get_appropriate_path(var/value)
	. = ..()
	if(noise2value(value) > 6)
		return /turf/exterior/dry

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

/area/exoplanet/desert
	ambience = list(
		'sound/effects/wind/desert0.ogg',
		'sound/effects/wind/desert1.ogg',
		'sound/effects/wind/desert2.ogg',
		'sound/effects/wind/desert3.ogg',
		'sound/effects/wind/desert4.ogg',
		'sound/effects/wind/desert5.ogg'
	)
	base_turf = /turf/exterior/sand
