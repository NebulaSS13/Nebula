/turf/floor/natural/clay
	name = "clay"
	desc = "Thick, claggy clay."
	icon = 'icons/turf/flooring/mud_light.dmi'
	icon_edge_layer = EXT_EDGE_CLAY
	footstep_type = /decl/footsteps/mud
	is_fundament_turf = TRUE
	material = /decl/material/solid/clay
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID

/turf/floor/natural/clay/drop_diggable_resources()
	if(get_physical_height() >= -(FLUID_DEEP) && prob(15))
		new /obj/item/rock/flint(src)
	return ..()

// the internet tells me clay holds water well and is full of nutrients plants crave
/turf/floor/natural/clay/get_plant_growth_rate()
	return 1.2

/turf/floor/natural/clay/flooded
	flooded = /decl/material/liquid/water

/turf/floor/natural/mud
	name = "mud"
	desc = "Thick, waterlogged mud."
	icon = 'icons/turf/flooring/mud_dark.dmi'
	icon_edge_layer = EXT_EDGE_MUD
	footstep_type = /decl/footsteps/mud
	is_fundament_turf = TRUE
	material = /decl/material/solid/soil
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID

/turf/floor/natural/mud/drop_diggable_resources()
	if(get_physical_height() > -(FLUID_DEEP) && prob(15))
		new /obj/item/food/worm(src)
	return ..()

/turf/floor/natural/mud/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	// scaling taken from /turf/floor/natural/grass/wild/fire_act
	// smoothly scale between 1/5 chance to scorch at the boiling point of water and 100% chance to scorch at boiling point * 4
	if(!reagents?.total_volume && temperature >= /decl/material/liquid/water::boiling_point && prob(20 + temperature * 80 / (/decl/material/liquid/water::boiling_point * 4)))
		ChangeTurf(/turf/floor/natural/dry, keep_air = TRUE, keep_height = TRUE)
		return
	return ..()

/turf/floor/natural/mud/get_plant_growth_rate()
	return 1.1

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
	icon = 'icons/turf/flooring/seafloor.dmi'
	is_fundament_turf = TRUE
	material = /decl/material/solid/soil

// Just wet the damn dirt first!!
/turf/floor/natural/dry/get_plant_growth_rate()
	return 0.0

/turf/floor/natural/dry/fluid_act(datum/reagents/fluids)
	if(fluids?.total_volume < FLUID_PUDDLE)
		return ..()
	var/turf/new_turf = ChangeTurf(/turf/floor/natural/mud, keep_air = TRUE, keep_height = TRUE)
	return new_turf.fluid_act(fluids)

