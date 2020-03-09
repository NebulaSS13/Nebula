// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER

/obj/item/stack/material/cyborg/Initialize()
	. = ..()
	if(material)
		name = "[material.display_name] synthesiser"
		desc = "A device that synthesises [material.display_name]."

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet"
	material = MAT_PLASTIC

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet"
	material = MAT_STEEL

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-reinf"
	material = MAT_PLASTEEL

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	material = MAT_WOOD

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet"
	material = MAT_GLASS
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-reinf"
	material = MAT_GLASS
	reinf_material = MAT_STEEL
	charge_costs = list(500, 1000)

/obj/item/stack/material/cyborg/aluminium
	icon_state = "sheet"
	material = MAT_ALUMINIUM
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME
