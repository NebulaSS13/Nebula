/turf/floor/natural/sand
	name = "sand"
	desc = "It's coarse and gets everywhere."
	dirt_color = "#ae9e66"
	footstep_type = /decl/footsteps/sand
	icon = 'icons/turf/flooring/sand.dmi'
	icon_edge_layer = EXT_EDGE_SAND
	possible_states = 4
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID

/turf/floor/natural/sand/get_diggable_resources()
	return (get_physical_height() <= -(FLUID_DEEP)) ? null : list(/obj/item/stack/material/ore/handful/sand = list(3, 2))

/turf/floor/natural/sand/drop_diggable_resources()
	if(get_physical_height() >= -(FLUID_DEEP) && prob(15))
		new /obj/item/rock/flint(src)
	return ..()

/turf/floor/natural/sand/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((temperature > T0C + 1700 && prob(5)) || temperature > T0C + 3000)
		handle_melting()
	return ..()

/turf/floor/natural/sand/water
	color = COLOR_SKY_BLUE
	reagent_type = /decl/material/liquid/water
	height = -(FLUID_SHALLOW)

/turf/floor/natural/sand/water/deep
	color = COLOR_BLUE
	height = -(FLUID_DEEP)

/turf/floor/natural/sand/handle_melting(list/meltable_materials)
	. = ..()
	if(icon_state != "glass")
		SetName("molten silica")
		desc = "A glassed patch of sand."
		icon_state = "glass"
		icon_edge_layer = -1
		clear_diggable_resources()

/turf/floor/natural/sand/can_be_dug()
	return icon_state != "glass" && ..()
