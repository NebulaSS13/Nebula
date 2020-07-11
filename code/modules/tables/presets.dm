/obj/structure/table/standard
	icon_state = "plain_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_FURNITURE_MATERIAL

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = COLOR_GRAY40
	material = /decl/material/solid/metal/steel

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = COLOR_GRAY80
	material = /decl/material/solid/stone/marble

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_FURNITURE_MATERIAL
	reinf_material = /decl/material/solid/metal/steel

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = COLOR_GRAY40
	material = /decl/material/solid/metal/steel
	reinf_material = /decl/material/solid/metal/steel

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1
	material = /decl/material/solid/wood/walnut

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = COLOR_DEEP_SKY_BLUE
	alpha = 77 // 0.3 * 255
	material = /decl/material/solid/glass

/obj/structure/table/glass/pglass
	color = "#8f29a3"
	material = /decl/material/solid/glass/borosilicate

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE

/obj/structure/table/holotable/Initialize()
	material = /decl/material/solid/metal/aluminium/holographic
	. = ..()

/obj/structure/table/holo_plastictable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE

/obj/structure/table/holo_plastictable/Initialize()
	material = /decl/material/solid/plastic/holographic
	. = ..()

/obj/structure/table/holo_woodentable
	icon_state = "holo_preview"

/obj/structure/table/holo_woodentable/Initialize()	
	material = /decl/material/solid/wood/holographic
	. = ..()

//wood wood wood
/obj/structure/table/woodentable
	icon_state = "solid_preview"
	color = WOOD_COLOR_GENERIC
	material = /decl/material/solid/wood

/obj/structure/table/woodentable_reinforced
	icon_state = "reinf_preview"
	color = WOOD_COLOR_GENERIC
	material = /decl/material/solid/wood
	reinf_material = /decl/material/solid/wood

/obj/structure/table/woodentable_reinforced/walnut
	icon_state = "reinf_preview"
	color = WOOD_COLOR_CHOCOLATE
	material = /decl/material/solid/wood/walnut
	reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/woodentable_reinforced/walnut/maple
	reinf_material = /decl/material/solid/wood/maple

/obj/structure/table/woodentable_reinforced/mahogany
	icon_state = "reinf_preview"
	color = WOOD_COLOR_RICH
	material = /decl/material/solid/wood/mahogany
	reinf_material = /decl/material/solid/wood/mahogany

/obj/structure/table/woodentable_reinforced/mahogany/walnut
	reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/woodentable_reinforced/ebony
	icon_state = "reinf_preview"
	color = WOOD_COLOR_BLACK
	material = /decl/material/solid/wood/ebony
	reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/woodentable_reinforced/ebony/walnut
	reinf_material = /decl/material/solid/wood/walnut

/obj/structure/table/woodentable/mahogany
	color = WOOD_COLOR_RICH
	material = /decl/material/solid/wood/mahogany

/obj/structure/table/woodentable/maple
	color = WOOD_COLOR_PALE
	material = /decl/material/solid/wood/maple

/obj/structure/table/woodentable/ebony
	color = WOOD_COLOR_BLACK
	material = /decl/material/solid/wood/ebony

/obj/structure/table/woodentable/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = /decl/material/solid/wood/walnut