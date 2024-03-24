/turf/exterior/clay
	name = "clay"
	desc = "Thick, claggy clay."
	icon = 'icons/turf/exterior/mud_light.dmi'
	icon_edge_layer = EXT_EDGE_CLAY
	footstep_type = /decl/footsteps/mud
	is_fundament_turf = TRUE

/turf/exterior/clay/get_diggable_resources()
	return (get_physical_height() <= -(FLUID_DEEP)) ? null : list(/obj/item/stack/material/lump/large/clay = list(3, 2))

/turf/exterior/clay/drop_diggable_resources()
	if(get_physical_height() >= -(FLUID_DEEP) && prob(15))
		new /obj/item/rock/flint(src)
	return ..()

/turf/exterior/clay/flooded
	flooded = /decl/material/liquid/water

/turf/exterior/mud
	name = "mud"
	desc = "Thick, waterlogged mud."
	icon = 'icons/turf/exterior/mud_dark.dmi'
	icon_edge_layer = EXT_EDGE_MUD
	footstep_type = /decl/footsteps/mud
	is_fundament_turf = TRUE

/turf/exterior/mud/drop_diggable_resources()
	if(get_physical_height() > -(FLUID_DEEP))
		return list(/obj/item/stack/material/lump/large/soil = list(3, 2))
	return ..()

/turf/exterior/mud/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!reagents?.total_volume)
		ChangeTurf(/turf/exterior/dry, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)
		return
	return ..()

/turf/exterior/mud/water
	color = COLOR_SKY_BLUE
	reagent_type = /decl/material/liquid/water
	height = -(FLUID_SHALLOW)

/turf/exterior/mud/water/deep
	color = COLOR_BLUE
	height = -(FLUID_DEEP)

/turf/exterior/mud/flooded
	flooded = /decl/material/liquid/water

/turf/exterior/dry
	name = "dry mud"
	desc = "Should have stayed hydrated."
	dirt_color = "#ae9e66"
	icon = 'icons/turf/exterior/seafloor.dmi'
	is_fundament_turf = TRUE

/turf/exterior/dry/fluid_act(datum/reagents/fluids)
	SHOULD_CALL_PARENT(FALSE)
	var/turf/new_turf = ChangeTurf(/turf/exterior/mud, keep_air = TRUE, keep_air_below = TRUE, keep_height = TRUE)
	return new_turf.fluid_act(fluids)

