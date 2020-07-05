// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER
	matter = null // Don't shove it in the autholathe.

/obj/item/stack/material/cyborg/Initialize()
	. = ..()
	if(material)
		name = "[material.solid_name] synthesiser"
		desc = "A device that synthesises [material.solid_name]."
		matter = null

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet"
	material = /decl/material/solid/plastic

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet"
	material = /decl/material/solid/metal/steel

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-reinf"
	material = /decl/material/solid/metal/plasteel

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	material = /decl/material/solid/wood

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet"
	material = /decl/material/solid/glass
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-reinf"
	material = /decl/material/solid/glass
	reinf_material = /decl/material/solid/metal/steel
	charge_costs = list(500, 1000)

/obj/item/stack/material/cyborg/aluminium
	icon_state = "sheet"
	material = /decl/material/solid/metal/aluminium
	material_flags = USE_MATERIAL_COLOR|USE_MATERIAL_SINGULAR_NAME|USE_MATERIAL_PLURAL_NAME
