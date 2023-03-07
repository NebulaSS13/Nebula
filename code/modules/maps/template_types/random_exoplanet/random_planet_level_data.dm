/datum/level_data/planetoid
	level_flags             = (ZLEVEL_PLAYER|ZLEVEL_SEALED)
	border_filler           = /turf/unsimulated/mineral
	loop_turf_type          = /turf/exterior/mimic_edge/transition/loop
	transition_turf_type    = /turf/exterior/mimic_edge/transition
	take_starlight_ambience = FALSE

/datum/level_data/planetoid/exoplanet
	base_area = /area/exoplanet
	base_turf = /turf/exterior/dirt
	ambient_light_level = 0.5

/datum/level_data/planetoid/exoplanet/underground
	base_area = /area/exoplanet/underground
	base_turf = /turf/exterior/volcanic
	ambient_light_level = 0

///Prepare our level for generation/load. And sync with the planet template
/datum/level_data/planetoid/before_template_load(datum/map_template/template, datum/planetoid_data/gen_data)
	. = ..()
	if(!gen_data)
		return //If there's no data from generation, it's fine we'll allow it

	//Apply parent's prefered bounds if we don't have any preferences
	if(!level_max_width && gen_data.width)
		level_max_width = gen_data.width
	if(!level_max_height && gen_data.height)
		level_max_height = gen_data.height

	//Refresh bounds
	setup_level_bounds()

	//override atmosphere
	apply_planet_atmosphere(gen_data)

	//Rename main area and level
	adapt_location_name(gen_data.name)

///If we're getting atmos from our parent planet, decide if we're going to apply it, or ignore it
/datum/level_data/planetoid/proc/apply_planet_atmosphere(var/datum/planetoid_data/P)
	if(istype(exterior_atmosphere))
		return //level atmos takes priority over planet atmos
	exterior_atmosphere = P.atmosphere.Clone()

/datum/level_data/planetoid/adapt_location_name(location_name)
	if(!(. = ..()))
		return