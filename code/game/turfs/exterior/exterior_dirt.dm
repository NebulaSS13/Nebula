/turf/exterior/dirt
	name = "dirt"
	desc = "A flat expanse of dry, cracked earth."
	icon = 'icons/turf/exterior/dirt.dmi'
	icon_edge_layer = EXT_EDGE_DIRT
	color = "#41311b"
	base_color = "#41311b"
	footstep_type = /decl/footsteps/asteroid
	is_fundament_turf = TRUE

/turf/exterior/dirt/fluid_act(var/datum/reagents/fluids)
	SHOULD_CALL_PARENT(FALSE)
	var/turf/new_turf = ChangeTurf(/turf/exterior/mud, keep_air = TRUE, keep_air_below = TRUE)
	return new_turf.fluid_act(fluids)


/turf/exterior/wall/dirt
	material = /decl/material/solid/soil
	color = "#41311b"

