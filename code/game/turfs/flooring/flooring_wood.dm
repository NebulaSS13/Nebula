/decl/flooring/wood
	name = "wooden floor"
	desc = "Polished wood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	footstep_type = /decl/footsteps/wood
	color = WOOD_COLOR_GENERIC // TYPE_INITIAL(/decl/material/solid/organic/wood, color)

/decl/flooring/wood/mahogany
	color = WOOD_COLOR_RICH // TYPE_INITIAL(/decl/material/solid/organic/wood/mahogany, color)
	build_type = /obj/item/stack/tile/mahogany

/decl/flooring/wood/maple
	color = WOOD_COLOR_PALE // TYPE_INITIAL(/decl/material/solid/organic/wood/maple, color)
	build_type = /obj/item/stack/tile/maple

/decl/flooring/wood/ebony
	color = WOOD_COLOR_BLACK // TYPE_INITIAL(/decl/material/solid/organic/wood/ebony, color)
	build_type = /obj/item/stack/tile/ebony

/decl/flooring/wood/walnut
	color = WOOD_COLOR_CHOCOLATE // TYPE_INITIAL(/decl/material/solid/organic/wood/walnut, color)
	build_type = /obj/item/stack/tile/walnut

/decl/flooring/wood/bamboo
	color = WOOD_COLOR_PALE2 // TYPE_INITIAL(/decl/material/solid/organic/wood/bamboo, color)
	build_type = /obj/item/stack/tile/bamboo

/decl/flooring/wood/yew
	color = WOOD_COLOR_YELLOW // TYPE_INITIAL(/decl/material/solid/organic/wood/yew, color)
	build_type = /obj/item/stack/tile/yew
