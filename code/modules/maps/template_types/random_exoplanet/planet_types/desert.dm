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
		/datum/random_map/noise/exoplanet/desert,
		/datum/random_map/noise/ore/rich,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/planet_flora/random/desert
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

/datum/planet_flora/random/desert/adapt_seed(var/datum/seed/S)
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
// Planetoid Data
////////////////////////////////////////////////////////////////////////////

/datum/planetoid_data/random/desert
	habitability_class             = null //Generate randomly
	atmosphere_gen_temperature_min = 40 CELSIUS
	atmosphere_gen_temperature_max = 120 CELSIUS
	surface_light_gen_level_min    = 0.5
	surface_light_gen_level_max    = 0.95
	flora                          = /datum/planet_flora/random/desert
	fauna                          = /datum/fauna_generator/desert
	possible_rock_colors           = list(
		COLOR_BEIGE,
		COLOR_PALE_YELLOW,
		COLOR_GRAY80,
		COLOR_BROWN
	)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/random/exoplanet/desert
	name                       = "desert exoplanet"
	planetoid_data_type        = /datum/planetoid_data/random/desert
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/desert
	template_parent_type       = /datum/map_template/planetoid/random/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/desert
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/desert,
		/datum/level_data/planetoid/exoplanet/underground
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
