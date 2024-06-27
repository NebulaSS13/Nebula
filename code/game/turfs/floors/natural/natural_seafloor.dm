/turf/floor/natural/seafloor
	name = "sea floor"
	gender = NEUTER
	desc = "A thick layer of silt and debris from above."
	icon = 'icons/turf/flooring/seafloor.dmi'
	icon_edge_layer = EXT_EDGE_SEAFLOOR
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	material = /decl/material/solid/sand
	is_fundament_turf = TRUE

/turf/floor/natural/seafloor/get_plant_growth_rate()
	return 0.8

/turf/floor/natural/seafloor/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/floor/natural/seafloor/Initialize()
	if(prob(20))
		LAZYADD(decals, image("asteroid[rand(0,9)]", 'icons/turf/mining_decals.dmi'))
	. = ..()
