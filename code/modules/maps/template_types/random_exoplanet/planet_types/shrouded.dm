////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/shrouded
	name          = "shrouded exoplanet"
	desc          = "An exoplanet shrouded in a perpetual storm of bizzare, light absorbing particles."
	color         = "#783ca4"
	surface_color = "#3e3960"
	water_color   = "#2b2840"

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/shrouded/get_atmosphere_color()
	return COLOR_BLACK

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/shrouded
	base_area           = /area/exoplanet/shrouded
	base_turf           = /turf/exterior/shrouded
	exterior_atmosphere = null
	exterior_atmos_temp = null
	level_generators    = list(
		/datum/random_map/noise/exoplanet/shrouded,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/flora_generator/shrouded
	flora_diversity = 3
	plant_colors    = list(
		"#3c5434",
		"#2f6655",
		"#0e703f",
		"#495139",
		"#394c66",
		"#1a3b77",
		"#3e3166",
		"#52457c",
		"#402d56",
		"#580d6d"
	)

////////////////////////////////////////////////////////////////////////////
// Fauna Generator
////////////////////////////////////////////////////////////////////////////

/datum/fauna_generator/shrouded
	fauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/royalcrab,
		/mob/living/simple_animal/hostile/retaliate/jelly/alt,
		/mob/living/simple_animal/hostile/retaliate/beast/shantak/alt,
		/mob/living/simple_animal/hostile/leech
	)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/exoplanet/shrouded
	name                       = "shrouded exoplanet"
	flora_generator_type       = /datum/flora_generator/shrouded
	fauna_generator_type       = /datum/fauna_generator/shrouded
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/shrouded
	ruin_tags_blacklist        = RUIN_HABITAT
	surface_light_level_min    = 0.15
	surface_light_level_max    = 0.25
	atmosphere_temperature_min = T0C
	atmosphere_temperature_max = 10 CELSIUS
	atmosphere_pressure_min    = 1 ATM
	atmosphere_pressure_max    = 2.5 ATM
	template_parent_type       = /datum/map_template/planetoid/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/shrouded
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/shrouded,
		/datum/level_data/planetoid/exoplanet/underground
	)
	possible_rock_colors = list(
		COLOR_INDIGO,
		COLOR_DARK_BLUE_GRAY,
		COLOR_NAVY_BLUE
	)
	map_generators = list(
		/datum/random_map/noise/ore/poor
	)

/datum/map_template/planetoid/exoplanet/shrouded/get_spawn_weight()
	return 50

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

/datum/random_map/noise/exoplanet/shrouded
	descriptor           = "shrouded exoplanet"
	smoothing_iterations = 2
	flora_prob           = 5
	large_flora_prob     = 20
	megafauna_spawn_prob = 2 //Remember to change this if more types are added.
	water_level_max      = 3
	water_level_min      = 2
	land_type            = /turf/exterior/shrouded
	water_type           = /turf/exterior/water/tar

/datum/random_map/noise/exoplanet/shrouded/get_additional_spawns(var/value, var/turf/T)
	..()
	if(prob(2))
		new/obj/structure/leech_spawner(T)

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

/area/exoplanet/shrouded
	forced_ambience = list(
		"sound/ambience/spookyspace1.ogg",
		"sound/ambience/spookyspace2.ogg"
	)
	base_turf = /turf/exterior/shrouded
