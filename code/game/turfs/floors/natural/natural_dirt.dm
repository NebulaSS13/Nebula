/turf/floor/natural/dirt
	name = "dirt"
	desc = "A flat expanse of dry, cracked earth."
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_edge_layer = EXT_EDGE_DIRT
	color = "#41311b"
	base_color = "#41311b"
	footstep_type = /decl/footsteps/asteroid
	is_fundament_turf = TRUE
	material = /decl/material/solid/soil
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID

/turf/floor/natural/dirt/get_plant_growth_rate()
	return 1

/turf/floor/natural/dirt/fluid_act(var/datum/reagents/fluids)
	if(fluids?.total_volume < FLUID_PUDDLE)
		return ..()
	var/turf/new_turf = ChangeTurf(/turf/floor/natural/mud, keep_air = TRUE, keep_height = TRUE)
	return new_turf.fluid_act(fluids)

/turf/floor/natural/dirt/drop_diggable_resources()
	if(get_physical_height() > -(FLUID_DEEP) && prob(10))
		new /obj/item/food/worm(src)
	return ..()
