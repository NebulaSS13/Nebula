// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER
	material_composition = null // Don't shove it in the autholathe.

/obj/item/stack/material/cyborg/Initialize()
	. = ..()
	var/decl/material/material = get_primary_material()
	if(material)
		name = "[material.solid_name] synthesiser"
		desc = "A device that synthesises [material.solid_name]."
		set_material_composition(null)

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet"
	material_composition = list(/decl/material/solid/plastic = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet"
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-reinf"
	material_composition = list(/decl/material/solid/metal/plasteel = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	material_composition = list(/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY)

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet"
	material_composition = list(/decl/material/solid/glass = MATTER_AMOUNT_PRIMARY)
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-reinf"
	material_composition = list(
		/decl/material/solid/glass = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)
	charge_costs = list(500, 1000)

/obj/item/stack/material/cyborg/aluminium
	icon_state = "sheet"
	material_composition = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY)
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME
