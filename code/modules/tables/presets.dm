/obj/structure/table/standard
	icon_state = "plain_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_FURNITURE_MATERIAL

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = COLOR_GRAY40
	material = MAT_STEEL

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = COLOR_GRAY80
	material = MAT_MARBLE

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_FURNITURE_MATERIAL
	reinf_material = MAT_STEEL

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = COLOR_GRAY40
	material = MAT_STEEL
	reinf_material = MAT_STEEL

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1
	material = MAT_WALNUT

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = COLOR_DEEP_SKY_BLUE
	alpha = 77 // 0.3 * 255
	material = MAT_GLASS

/obj/structure/table/glass/pglass
	color = "#8f29a3"
	material = MAT_PHORON_GLASS

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE

/obj/structure/table/holotable/Initialize()
	material = MAT_ALUMINIUM_HOLOGRAPHIC
	. = ..()

/obj/structure/table/holo_plastictable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE

/obj/structure/table/holo_plastictable/Initialize()
	material = MAT_PLASTIC_HOLOGRAPHIC
	. = ..()

/obj/structure/table/holo_woodentable
	icon_state = "holo_preview"

/obj/structure/table/holo_woodentable/Initialize()	
	material = MAT_WOOD_HOLOGRAPHIC
	. = ..()

//wood wood wood
/obj/structure/table/woodentable
	icon_state = "solid_preview"
	color = WOOD_COLOR_GENERIC
	material = MAT_WOOD

/obj/structure/table/woodentable_reinforced
	icon_state = "reinf_preview"
	color = WOOD_COLOR_GENERIC
	material = MAT_WOOD
	reinf_material = MAT_WOOD

/obj/structure/table/woodentable_reinforced/walnut
	icon_state = "reinf_preview"
	color = WOOD_COLOR_CHOCOLATE
	material = MAT_WALNUT
	reinf_material = MAT_WALNUT

/obj/structure/table/woodentable_reinforced/walnut/maple
	reinf_material = MAT_MAPLE

/obj/structure/table/woodentable_reinforced/mahogany
	icon_state = "reinf_preview"
	color = WOOD_COLOR_RICH
	material = MAT_MAHOGANY
	reinf_material = MAT_MAHOGANY

/obj/structure/table/woodentable_reinforced/mahogany/walnut
	reinf_material = MAT_WALNUT

/obj/structure/table/woodentable_reinforced/ebony
	icon_state = "reinf_preview"
	color = WOOD_COLOR_BLACK
	material = MAT_EBONY
	reinf_material = MAT_WALNUT

/obj/structure/table/woodentable_reinforced/ebony/walnut
	reinf_material = MAT_WALNUT

/obj/structure/table/woodentable/mahogany
	color = WOOD_COLOR_RICH
	material = MAT_MAHOGANY

/obj/structure/table/woodentable/maple
	color = WOOD_COLOR_PALE
	material = MAT_MAPLE

/obj/structure/table/woodentable/ebony
	color = WOOD_COLOR_BLACK
	material = MAT_EBONY

/obj/structure/table/woodentable/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = MAT_WALNUT