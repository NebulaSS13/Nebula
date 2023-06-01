/////////////////////////////////////////////////////////////////////////
// Planetoid
/////////////////////////////////////////////////////////////////////////

///Overmap marker for a planet-like entity.
/obj/effect/overmap/visitable/sector/planetoid
	name         = "planetoid"
	icon         = 'icons/obj/overmap.dmi'
	icon_state   = "globe"
	free_landing = TRUE
	sector_flags = 0 //By default, can't space walk over there
	color        = "#4e3570"

	///ID of the associated planetoid data id for lookup.
	var/planetoid_id
	///The icon file to use for this planetoid's skybox image
	var/icon/skybox_icon = 'icons/skybox/planet.dmi'
	///Skybox background image when floating in space above this sector. Generated at runtime
	var/tmp/image/skybox_image
	///Color of the primary layer of the skybox image
	var/surface_color = COLOR_ASTEROID_ROCK
	///Color of the secondary layer of the skybox image. Is usually water-like features.
	var/water_color = "#436499"

/obj/effect/overmap/visitable/sector/planetoid/Initialize(mapload)
	. = ..()
	if(length(planetoid_id))
		var/datum/planetoid_data/P = get_planetoid_data()
		P.set_overmap_marker(src)

///Returns the /datum/planetoid_data associated with planet this overmap marker represents.
/obj/effect/overmap/visitable/sector/planetoid/proc/get_planetoid_data()
	return LAZYACCESS(SSmapping.planetoid_data_by_id, planetoid_id)

///Returns the planetoid's atmosphere if there's any
/obj/effect/overmap/visitable/sector/planetoid/proc/get_atmosphere()
	var/datum/planetoid_data/P = get_planetoid_data()
	return P.atmosphere

///Returns the /area atom for the surface of the planetoid
/obj/effect/overmap/visitable/sector/planetoid/proc/get_surface_area()
	var/datum/planetoid_data/P = get_planetoid_data()
	return P.surface_area

///Returns the strata associated to the planetoid we represent
/obj/effect/overmap/visitable/sector/planetoid/proc/get_strata()
	var/datum/planetoid_data/P = get_planetoid_data()
	return P.strata

///Update our name, and refs to match the planetoid we're representing
/obj/effect/overmap/visitable/sector/planetoid/proc/update_from_data(var/datum/planetoid_data/P)
	SetName("[P.name], \a [name]")
	planetoid_id  = P.id
	surface_color = P.surface_color
	water_color   = P.water_color

/obj/effect/overmap/visitable/sector/planetoid/get_scan_data(mob/user)
	. = ..()
	. += "<br>"
	var/datum/gas_mixture/atmosphere = get_atmosphere()
	if(atmosphere)
		if(user.skill_check(SKILL_SCIENCE, SKILL_EXPERT) || user.skill_check(SKILL_ATMOS, SKILL_EXPERT))
			var/list/gases = list()
			for(var/g in atmosphere.gas)
				if(atmosphere.gas[g] > atmosphere.total_moles * 0.05)
					var/decl/material/mat = GET_DECL(g)
					gases += mat.gas_name
			. += "Atmosphere composition: [english_list(gases)]<br>"
			var/inaccuracy = rand(8,12)/10
			. += "Atmosphere pressure [atmosphere.return_pressure()*inaccuracy] kPa, temperature [atmosphere.temperature*inaccuracy] K<br>"
		else if(user.skill_check(SKILL_SCIENCE, SKILL_BASIC) || user.skill_check(SKILL_ATMOS, SKILL_BASIC))
			. += "Atmosphere present<br>"
		. += "<br>"

	var/datum/planetoid_data/E = get_planetoid_data()
	for(var/datum/exoplanet_theme/T in E.themes)
		if(T.get_sensor_data())
			. += jointext(T.get_sensor_data(), "<br>")
	. += "<br>"
