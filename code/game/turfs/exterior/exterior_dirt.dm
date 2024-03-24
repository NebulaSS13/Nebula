/turf/exterior/dirt
	name = "dirt"
	desc = "A flat expanse of dry, cracked earth."
	icon = 'icons/turf/exterior/dirt.dmi'
	icon_edge_layer = EXT_EDGE_DIRT
	color = "#41311b"
	base_color = "#41311b"
	footstep_type = /decl/footsteps/asteroid
	is_fundament_turf = TRUE

/turf/exterior/dirt/get_diggable_resources()
	return (get_physical_height() <= -(FLUID_DEEP)) ? null : list(/obj/item/stack/material/lump/large/soil = list(3, 2))

/turf/exterior/dirt/fluid_act(var/datum/reagents/fluids)
	SHOULD_CALL_PARENT(FALSE)
	var/turf/new_turf = ChangeTurf(/turf/exterior/mud, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)
	return new_turf.fluid_act(fluids)
