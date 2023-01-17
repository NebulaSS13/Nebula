/turf/exterior/barren
	name = "ground"
	icon = 'icons/turf/exterior/barren.dmi'
	icon_edge_layer = EXT_EDGE_BARREN
	var/decal_state

/turf/exterior/barren/Initialize()
	. = ..()
	if(prob(20))
		decal_state = "asteroid[rand(0,9)]"
