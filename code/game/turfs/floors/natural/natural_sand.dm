/turf/floor/natural/sand
	name = "sand"
	desc = "It's coarse and gets everywhere."
	dirt_color = "#ae9e66"
	footstep_type = /decl/footsteps/sand
	icon = 'icons/turf/flooring/sand.dmi'
	icon_edge_layer = EXT_EDGE_SAND
	icon_has_corners = TRUE
	possible_states = 4
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	material = /decl/material/solid/sand
	is_fundament_turf = TRUE

/turf/floor/natural/sand/get_plant_growth_rate()
	return 0.5

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
		set_turf_materials(/decl/material/solid/glass, skip_update = TRUE)
		SetName("molten silica")
		desc = "A glassed patch of sand."
		icon_state = "glass"
		icon_edge_layer = -1
		clear_diggable_resources()
