/turf/floor/natural/dirt
	name = "dirt"
	desc = "A flat expanse of dry, cracked earth."
	icon = 'icons/turf/exterior/dirt.dmi'
	icon_edge_layer = EXT_EDGE_DIRT
	color = "#41311b"
	base_color = "#41311b"
	footstep_type = /decl/footsteps/asteroid
	is_fundament_turf = TRUE
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID

/turf/floor/natural/dirt/get_diggable_resources()
	return (get_physical_height() <= -(FLUID_DEEP)) ? null : list(/obj/item/stack/material/lump/large/soil = list(3, 2))

/turf/floor/natural/dirt/fluid_act(var/datum/reagents/fluids)
	if(fluids?.total_volume < FLUID_SHALLOW)
		return ..()
	var/turf/new_turf = ChangeTurf(/turf/floor/natural/mud, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)
	return new_turf.fluid_act(fluids)
