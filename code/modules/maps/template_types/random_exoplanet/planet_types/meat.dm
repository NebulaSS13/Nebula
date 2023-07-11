////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/meat
	name          = "organic exoplanet"
	desc          = "An exoplanet made entirely of organic matter."
	color         = "#ac4653"
	surface_color = "#e2768d"
	water_color   = "#c7c27c"

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/meat
	base_area           = /area/exoplanet/meat
	base_turf           = /turf/exterior/meat
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

	LAZYSET(S.chems, /decl/material/liquid/nutriment/protein, list(10,30))
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
		/mob/living/simple_animal/hostile/retaliate/jelly/alt,
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
	ruin_tags_blacklist        = RUIN_HABITAT|RUIN_HUMAN|RUIN_WATER
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
	land_type            = /turf/exterior/meat
	water_type           = /turf/exterior/water/stomach

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

/area/exoplanet/meat
	base_turf       = /turf/exterior/meat
	forced_ambience = list(
		"sound/ambience/spookyspace1.ogg",
		"sound/ambience/spookyspace2.ogg"
	)

////////////////////////////////////////////////////////////////////////////
// Turfs
////////////////////////////////////////////////////////////////////////////

/turf/exterior/meat
	name          = "fleshy ground"
	icon          = 'icons/turf/exterior/flesh.dmi'
	desc          = "It's disgustingly soft to the touch. And warm. Too warm."
	dirt_color    = "#c40031"
	footstep_type = /decl/footsteps/mud

/turf/exterior/water/stomach
	name         = "juices"
	desc         = "Half-digested chunks of vines are floating in the puddle of some liquid."
	gender       = PLURAL
	icon         = 'icons/turf/exterior/water_still.dmi'
	reagent_type = /decl/material/liquid/acid/stomach
	color        = "#c7c27c"
	base_color   = "#c7c27c"
	dirt_color   = "#c40031"
