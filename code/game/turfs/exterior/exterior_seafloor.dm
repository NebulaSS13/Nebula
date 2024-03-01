/turf/exterior/seafloor
	name = "sea floor"
	icon = 'icons/turf/flooring/seafloor.dmi'
	icon_state = "seafloor"
	flooring_layers = /decl/flooring/seafloor
	var/detail_decal

/decl/flooring/seafloor
	name = "sea floor"
	desc = "A thick layer of silt and debris from above."
	icon = 'icons/turf/flooring/seafloor.dmi'
	icon_base = "seafloor"
	icon_edge_layer = EXT_EDGE_SEAFLOOR
	diggable_resources = list(/obj/item/stack/material/ore/sand = list(3, 2))

/turf/exterior/seafloor/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/exterior/seafloor/Initialize()
	if(prob(20))
		LAZYADD(decals, image("asteroid[rand(0,9)]", 'icons/turf/mining_decals.dmi'))
	. = ..()
