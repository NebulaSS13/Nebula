/obj/structure/table/standard
	icon_state = "plain_preview"
	color = COLOR_OFF_WHITE
	material_composition = list(DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = COLOR_GRAY40
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = COLOR_GRAY80
	material_composition = list(/decl/material/solid/stone/marble = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = COLOR_OFF_WHITE
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = COLOR_GRAY40
	material_composition = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/plasteel = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1
	material_composition = list(/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = COLOR_DEEP_SKY_BLUE
	alpha = 77 // 0.3 * 255
	material_composition = list(/decl/material/solid/glass = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/glass/pglass
	color = "#8f29a3"
	material_composition = list(/decl/material/solid/glass/borosilicate = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE
	material_composition = list(
		/decl/material/solid/metal/aluminium/holographic = MATTER_AMOUNT_PRIMARY
	)
	
/obj/structure/table/holo_plastictable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE
	material_composition = list(
		/decl/material/solid/plastic/holographic = MATTER_AMOUNT_PRIMARY
	)
	
/obj/structure/table/holo_woodentable
	icon_state = "holo_preview"
	material_composition = list(
		/decl/material/solid/wood/holographic = MATTER_AMOUNT_PRIMARY
	)

//wood wood wood
/obj/structure/table/woodentable
	icon_state = "solid_preview"
	color = WOOD_COLOR_GENERIC
	material_composition = list(
		/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY
	)

/obj/structure/table/woodentable_reinforced
	icon_state = "reinf_preview"
	color = WOOD_COLOR_GENERIC
	material_composition = list(
		/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/plastic = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/woodentable_reinforced/walnut
	icon_state = "reinf_preview"
	color = WOOD_COLOR_CHOCOLATE
	material_composition = list(
		/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/wood/walnut = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/woodentable_reinforced/walnut/maple
	material_composition = list(
		/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/wood/maple = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/woodentable_reinforced/mahogany
	icon_state = "reinf_preview"
	color = WOOD_COLOR_RICH
	material_composition = list(
		/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/wood/mahogany = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/woodentable_reinforced/mahogany/walnut
	material_composition = list(
		/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/wood/mahogany = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/woodentable_reinforced/ebony
	icon_state = "reinf_preview"
	color = WOOD_COLOR_BLACK
	material_composition = list(
		/decl/material/solid/wood/ebony = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/wood/mahogany = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/woodentable_reinforced/ebony/walnut
	material_composition = list(
		/decl/material/solid/wood/ebony = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/wood/walnut = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/table/woodentable/mahogany
	color = WOOD_COLOR_RICH
	material_composition = list(/decl/material/solid/wood/mahogany = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/woodentable/maple
	color = WOOD_COLOR_PALE
	material_composition = list(/decl/material/solid/wood/maple = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/woodentable/ebony
	color = WOOD_COLOR_BLACK
	material_composition = list(/decl/material/solid/wood/ebony = MATTER_AMOUNT_PRIMARY)

/obj/structure/table/woodentable/walnut
	color = WOOD_COLOR_CHOCOLATE
	material_composition = list(/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY)