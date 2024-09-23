////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/meat
	name          = "organic exoplanet"
	desc          = "An exoplanet made entirely of organic matter."
	color         = "#ac4653"

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/meat
	base_area           = /area/exoplanet/meat
	base_turf           = /turf/floor/meat
	exterior_atmosphere = null
	exterior_atmos_temp = null
	level_generators    = list(
		/datum/random_map/noise/exoplanet/meat,
		/datum/random_map/noise/ore/poor,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/planet_flora/random/meat
	flora_diversity = 3
	plant_colors    = list(
		"#924585",
		"#f37474",
		"#eb9ee4",
		"#4e348b"
	)

/datum/planet_flora/random/meat/adapt_seed(var/datum/seed/S)
	..()
	S.set_trait(TRAIT_CARNIVOROUS,2)
	if(prob(75))
		S.get_trait(TRAIT_STINGS, 1)

	LAZYSET(S.chems, /decl/material/solid/organic/meat, list(10,30))
	LAZYSET(S.chems, /decl/material/liquid/blood, list(5,10))
	LAZYSET(S.chems, /decl/material/liquid/acid/stomach, list(5,10))

	S.set_trait(TRAIT_PARASITE,1)

	if(prob(40))
		S.set_trait(TRAIT_SPREAD,2)
	else
		S.set_trait(TRAIT_SPREAD,1)

////////////////////////////////////////////////////////////////////////////
// Fauna Generator
////////////////////////////////////////////////////////////////////////////

/datum/fauna_generator/meat
	fauna_types = list(
		/mob/living/simple_animal/hostile/jelly/alt,
		/mob/living/simple_animal/hostile/leech
	)

////////////////////////////////////////////////////////////////////////////
// Planetoid Data
////////////////////////////////////////////////////////////////////////////

/datum/planetoid_data/random/meat
	habitability_class             = null
	atmosphere_gen_temperature_min = 30 CELSIUS
	atmosphere_gen_temperature_max = 40 CELSIUS
	surface_light_gen_level_min    = 0.1
	surface_light_gen_level_max    = 0.7
	flora                          = /datum/planet_flora/random/meat
	fauna                          = /datum/fauna_generator/meat
	strata                         = /decl/strata/sedimentary
	surface_color = "#e2768d"
	water_color   = "#c7c27c"
	possible_rock_colors           = list(
		COLOR_OFF_WHITE,
		"#f3ebd4",
		"#f3d4f0"
	)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/random/exoplanet/meat
	name                       = "organic exoplanet"
	planetoid_data_type        = /datum/planetoid_data/random/meat
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/meat
	template_tags_blacklist    = TEMPLATE_TAG_HABITAT|TEMPLATE_TAG_HUMAN|TEMPLATE_TAG_WATER
	template_parent_type       = /datum/map_template/planetoid/random/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/meat
	prefered_level_data_per_z  = null

/datum/map_template/planetoid/random/exoplanet/meat/get_spawn_weight()
	return 10

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

/datum/random_map/noise/exoplanet/meat
	descriptor           = "meat exoplanet"
	smoothing_iterations = 3
	flora_prob           = 5
	large_flora_prob     = 0
	megafauna_spawn_prob = 2 //Remember to change this if more types are added.
	water_level_max      = 3
	water_level_min      = 2
	land_type            = /turf/floor/meat
	water_type           = /turf/floor/meat/acid

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

/area/exoplanet/meat
	base_turf       = /turf/floor/meat
	forced_ambience = list(
		"sound/ambience/spookyspace1.ogg",
		"sound/ambience/spookyspace2.ogg"
	)

////////////////////////////////////////////////////////////////////////////
// Turfs
////////////////////////////////////////////////////////////////////////////

/turf/floor/meat
	name              = "fleshy ground"
	icon              = 'icons/turf/flooring/flesh.dmi'
	icon_state        = "meat"
	_base_flooring    = /decl/flooring/meat
	floor_material    = /decl/material/solid/organic/meat

/turf/floor/meat/acid
	name              = "juices"
	desc              = "Half-digested chunks of vines are floating in the puddle of some liquid."
	gender            = PLURAL
	fill_reagent_type = /decl/material/liquid/acid/stomach
	height            = -(FLUID_SHALLOW)
