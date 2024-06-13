/turf/exterior/barren
	name = "ground"
	icon = 'icons/turf/exterior/barren.dmi'
	icon_edge_layer = EXT_EDGE_BARREN
	is_fundament_turf = TRUE

/turf/exterior/barren/airless
	initial_gas = null

/turf/exterior/barren/Initialize()
	if(prob(20))
		LAZYADD(decals, image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))
	. = ..()
