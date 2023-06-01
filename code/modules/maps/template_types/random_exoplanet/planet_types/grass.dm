////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

///Overmap marker for the grass exoplanet
/obj/effect/overmap/visitable/sector/planetoid/exoplanet/grass
	name = "lush exoplanet"
	desc = "Planet with abundant flora and fauna."
	color = "#407c40"

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/grass/get_surface_color()
	var/datum/planetoid_data/E = SSmapping.planetoid_data_by_id[planetoid_id]
	return E?.get_grass_color()

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

///Surface of a grass exoplanet
/datum/level_data/planetoid/exoplanet/grass
	base_area           = /area/exoplanet/grass
	base_turf           = /turf/exterior/wildgrass
	exterior_atmosphere = null
	exterior_atmos_temp = null
	level_generators    = list(
		/datum/random_map/noise/exoplanet/grass
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

///Flora data for a grass exoplanet
/datum/planet_flora/random/grass
	flora_diversity = 6
	plant_colors    = list(
		"#215a00",
		"#195a47",
		"#5a7467",
		"#9eab88",
		"#6e7248",
		"RANDOM"
	)
/datum/planet_flora/random/grass/adapt_seed(var/datum/seed/S)
	. = ..()
	var/carnivore_prob = rand(100)
	if(carnivore_prob < 30)
		S.set_trait(TRAIT_CARNIVOROUS,2)
		if(prob(75))
			S.get_trait(TRAIT_STINGS, 1)
	else if(carnivore_prob < 60)
		S.set_trait(TRAIT_CARNIVOROUS,1)
		if(prob(50))
			S.get_trait(TRAIT_STINGS)
	if(prob(15) || (S.get_trait(TRAIT_CARNIVOROUS) && prob(40)))
		S.set_trait(TRAIT_BIOLUM,1)
		S.set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))

	if(prob(30))
		S.set_trait(TRAIT_PARASITE,1)
	if(!S.get_trait(TRAIT_LARGE))
		var/vine_prob = rand(100)
		if(vine_prob < 15)
			S.set_trait(TRAIT_SPREAD,2)
		else if(vine_prob < 30)
			S.set_trait(TRAIT_SPREAD,1)

////////////////////////////////////////////////////////////////////////////
// Fauna Generator
////////////////////////////////////////////////////////////////////////////

/datum/fauna_generator/grass
	fauna_types = list(
		/mob/living/simple_animal/yithian,
		/mob/living/simple_animal/tindalos,
		/mob/living/simple_animal/hostile/retaliate/jelly
	)
	megafauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/parrot/space/megafauna,
		/mob/living/simple_animal/hostile/retaliate/goose/dire
	)

////////////////////////////////////////////////////////////////////////////
// Planetoid Data
////////////////////////////////////////////////////////////////////////////

/datum/planetoid_data/random/grass
	habitability_class             = null
	atmosphere_gen_pressure_min    = 0.8 ATM
	atmosphere_gen_pressure_max    = 1.5 ATM
	atmosphere_gen_temperature_min = 20 CELSIUS  //Within liquid water/humanoid "comfort" range. Gets adjusted to default species.
	atmosphere_gen_temperature_max = 50 CELSIUS  //Within liquid water/humanoid "comfort" range. Gets adjusted to default species.
	surface_light_gen_level_min    = 0.25 //give a chance of twilight jungle
	surface_light_gen_level_max    = 0.75
	flora                          = /datum/planet_flora/random/grass
	fauna                          = /datum/fauna_generator/grass
	possible_rock_colors           = list(
		COLOR_ASTEROID_ROCK,
		COLOR_GRAY80,
		COLOR_BROWN
	)

/datum/planetoid_data/random/grass/generate_habitability()
	if(isnull(habitability_class))
		if(prob(10))
			. = HABITABILITY_IDEAL
		else
			. = HABITABILITY_OKAY
	else
		. = habitability_class
	set_habitability(.)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

///Map template for generating a grass exoplanet
/datum/map_template/planetoid/random/exoplanet/grass
	name                       = "lush exoplanet"
	planetoid_data_type        = /datum/planetoid_data/random/grass
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/grass
	template_parent_type       = /datum/map_template/planetoid/random/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/grass
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/grass,
		/datum/level_data/planetoid/exoplanet/underground
	)

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

///Map generator for the grass exoplanet surface
/datum/random_map/noise/exoplanet/grass
	descriptor       = "grass exoplanet"
	land_type        = /turf/exterior/wildgrass
	water_type       = /turf/exterior/water
	coast_type       = /turf/exterior/mud/dark
	water_level_min  = 3
	flora_prob       = 10
	grass_prob       = 50
	large_flora_prob = 30

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

///Area for the grass exoplanet surface
/area/exoplanet/grass
	base_turf = /turf/exterior/wildgrass
	ambience  = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/ambience/eeriejungle2.ogg',
		'sound/ambience/eeriejungle1.ogg'
	)
	forced_ambience = list(
		'sound/ambience/jungle.ogg'
	)