/turf/floor/natural/clay
	name = "clay"
	desc = "Thick, claggy clay."
	icon = 'icons/turf/exterior/mud_light.dmi'
	icon_edge_layer = EXT_EDGE_CLAY
	footstep_type = /decl/footsteps/mud
	is_fundament_turf = TRUE
	material = /decl/material/solid/clay

/turf/floor/natural/clay/drop_diggable_resources()
	if(get_physical_height() >= -(FLUID_DEEP) && prob(15))
		new /obj/item/rock/flint(src)
	return ..()

/turf/floor/natural/clay/flooded
	flooded = /decl/material/liquid/water

/turf/floor/natural/mud
	name = "mud"
	desc = "Thick, waterlogged mud."
	icon = 'icons/turf/exterior/mud_dark.dmi'
	icon_edge_layer = EXT_EDGE_MUD
	footstep_type = /decl/footsteps/mud
	is_fundament_turf = TRUE
	material = /decl/material/solid/soil

/turf/floor/natural/mud/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!reagents?.total_volume)
		ChangeTurf(/turf/floor/natural/dry, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)
		return
	return ..()

/turf/floor/natural/mud/water
	color = COLOR_SKY_BLUE
	reagent_type = /decl/material/liquid/water
	height = -(FLUID_SHALLOW)

/turf/floor/natural/mud/water/deep
	color = COLOR_BLUE
	height = -(FLUID_DEEP)

/turf/floor/natural/mud/flooded
	flooded = /decl/material/liquid/water

/turf/floor/natural/dry
	name = "dry mud"
	desc = "Should have stayed hydrated."
	dirt_color = "#ae9e66"
	icon = 'icons/turf/exterior/seafloor.dmi'
	is_fundament_turf = TRUE
	material = /decl/material/solid/soil

/turf/floor/natural/dry/fluid_act(datum/reagents/fluids)
	SHOULD_CALL_PARENT(FALSE)
	var/turf/new_turf = ChangeTurf(/turf/floor/natural/mud, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)
	return new_turf.fluid_act(fluids)

