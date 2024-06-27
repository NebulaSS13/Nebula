/turf/floor/natural/barren
	name = "ground"
	icon = 'icons/turf/flooring/barren.dmi'
	icon_edge_layer = EXT_EDGE_BARREN
	is_fundament_turf = TRUE
	material = /decl/material/solid/sand

/turf/floor/natural/barren/airless
	initial_gas = null

/turf/floor/natural/barren/Initialize()
	if(prob(20))
		LAZYADD(decals, image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))
	. = ..()
