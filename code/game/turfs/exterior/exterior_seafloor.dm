/turf/exterior/seafloor
	name = "sea floor"
	desc = "A thick layer of silt and debris from above."
	icon = 'icons/turf/exterior/seafloor.dmi'
	flooded = TRUE
	icon_edge_layer = EXT_EDGE_SEAFLOOR
	var/detail_decal

/turf/exterior/seafloor/non_flooded
	flooded = FALSE

/turf/exterior/seafloor/Initialize()
	. = ..()
	if(isnull(detail_decal) && prob(20))
		detail_decal = "asteroid[rand(0,9)]"
		update_icon()

/turf/exterior/seafloor/on_update_icon()
	. = ..()
	if(detail_decal)
		add_overlay(image(icon = 'icons/turf/mining_decals.dmi', icon_state = detail_decal))
