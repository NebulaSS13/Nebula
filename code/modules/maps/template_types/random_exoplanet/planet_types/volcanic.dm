////////////////////////////////////////////////////////////////////////////
// Overmap Marker
////////////////////////////////////////////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/volcanic
	name          = "volcanic exoplanet"
	desc          = "A tectonically unstable planet, extremely rich in minerals."
	color         = "#9c2020"
	surface_color = "#261e19"
	water_color   = "#c74d00"

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/volcanic/get_atmosphere_color()
	return COLOR_GRAY20

////////////////////////////////////////////////////////////////////////////
// Level Data
////////////////////////////////////////////////////////////////////////////

/datum/level_data/planetoid/exoplanet/volcanic
	base_area = /area/exoplanet/volcanic
	base_turf = /turf/exterior/volcanic
	exterior_atmosphere = null
	exterior_atmos_temp = null
	level_generators = list(
		/datum/random_map/noise/exoplanet/volcanic,
		/datum/random_map/noise/ore/filthy_rich,
	)

////////////////////////////////////////////////////////////////////////////
// Flora Generator
////////////////////////////////////////////////////////////////////////////

/datum/planet_flora/random/volcanic
	has_trees       = FALSE
	flora_diversity = 3
	plant_colors    = list(
		"#a23c05",
		"#3f1f0d",
		"#662929",
		"#ba6222",
		"#7a5b3a",
		"#471429"
	)
/datum/planet_flora/random/volcanic/adapt_seed(datum/seed/S)
	..()
	S.set_trait(TRAIT_REQUIRES_WATER, 0)
	S.set_trait(TRAIT_HEAT_TOLERANCE, 1000 + S.get_trait(TRAIT_HEAT_TOLERANCE))

////////////////////////////////////////////////////////////////////////////
// Fauna Generator
////////////////////////////////////////////////////////////////////////////

/datum/fauna_generator/volcanic
	fauna_types = list(
		/mob/living/simple_animal/thinbug,
		/mob/living/simple_animal/hostile/retaliate/beast/shantak/lava,
		/mob/living/simple_animal/hostile/retaliate/beast/charbaby
	)
	megafauna_types = list(
		/mob/living/simple_animal/hostile/drake
	)

/datum/fauna_generator/volcanic/generate_template(spawn_type, atmos_temp, list/min_gas, list/max_gas)
	var/datum/generated_fauna_template/Tmpl = ..()
	Tmpl.heat_damage_per_tick = 0 //animals not hot, no burning in lava
	return Tmpl

////////////////////////////////////////////////////////////////////////////
// Planetoid Data
////////////////////////////////////////////////////////////////////////////

/datum/planetoid_data/random/volcanic
	habitability_class             = HABITABILITY_BAD
	atmosphere_gen_temperature_min = 240 CELSIUS
	atmosphere_gen_temperature_max = 820 CELSIUS
	atmosphere_gen_pressure_min    = 10 ATM //It's safe to say a volcanic world probably has a thick gas blanket if it's big enough to hold an atmosphere
	atmosphere_gen_pressure_max    = 90 ATM //Venus is 92.10 atm or 93 bar for reference
	initial_weather_state          = /decl/state/weather/ash
	flora                          = /datum/planet_flora/random/volcanic
	fauna                          = /datum/fauna_generator/volcanic
	possible_rock_colors           = list(
		COLOR_DARK_GRAY
	)

////////////////////////////////////////////////////////////////////////////
// Map Template
////////////////////////////////////////////////////////////////////////////

/datum/map_template/planetoid/random/exoplanet/volcanic
	name                       = "volcanic exoplanet"
	planetoid_data_type        = /datum/planetoid_data/random/volcanic
	overmap_marker_type        = /obj/effect/overmap/visitable/sector/planetoid/exoplanet/volcanic
	max_themes                 = 1
	ruin_tags_blacklist        = RUIN_HABITAT|RUIN_WATER
	template_parent_type       = /datum/map_template/planetoid/random/exoplanet
	level_data_type            = /datum/level_data/planetoid/exoplanet/volcanic
	prefered_level_data_per_z  = list(
		/datum/level_data/planetoid/exoplanet/volcanic,
		/datum/level_data/planetoid/exoplanet/underground
	)
	possible_themes = list(
		/datum/exoplanet_theme/mountains = 100,
		/datum/exoplanet_theme = 90,
		/datum/exoplanet_theme/robotic_guardians = 10
	)

////////////////////////////////////////////////////////////////////////////
// Map Generator Surface
////////////////////////////////////////////////////////////////////////////

/datum/random_map/noise/exoplanet/volcanic
	descriptor           = "volcanic exoplanet"
	smoothing_iterations = 5
	land_type            = /turf/exterior/volcanic
	water_type           = /turf/exterior/lava
	water_level_min      = 5
	water_level_max      = 6
	fauna_prob           = 1
	flora_prob           = 3
	grass_prob           = 0
	large_flora_prob     = 0

//Squashing most of 1 tile lava puddles
/datum/random_map/noise/exoplanet/volcanic/cleanup()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(noise2value(map[current_cell]) < water_level)
				continue
			var/frendos
			for(var/dx in list(-1,0,1))
				for(var/dy in list(-1,0,1))
					var/tmp_cell = get_map_cell(x+dx,y+dy)
					if(tmp_cell && tmp_cell != current_cell && noise2value(map[tmp_cell]) >= water_level)
						frendos = 1
						break
			if(!frendos)
				map[current_cell] = 1

////////////////////////////////////////////////////////////////////////////
// Areas
////////////////////////////////////////////////////////////////////////////

/area/exoplanet/volcanic
	forced_ambience = list('sound/ambience/magma.ogg')
	base_turf       = /turf/exterior/volcanic
