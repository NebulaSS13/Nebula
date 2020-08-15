/turf/exterior/barren
	name = "ground"
	icon = 'icons/turf/exterior/barren.dmi'
	icon_edge_layer = EXT_EDGE_BARREN

/turf/exterior/barren/on_update_icon()
	. = ..()
	if(prob(20))
		add_overlay(image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))

/turf/exterior/barren/Initialize()
	. = ..()
	update_icon()