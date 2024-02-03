// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER
	matter = null // Don't shove it in the autholathe.
	max_health = ITEM_HEALTH_NO_DAMAGE
	is_spawnable_type = FALSE

/obj/item/stack/material/cyborg/Initialize()
	. = ..()
	if(material)
		if(reinf_material)
			name = "[reinf_material.solid_name]-reinforced [material.solid_name] synthesiser"
			desc = "A device that synthesises [reinf_material.solid_name]-reinforced[material.solid_name]."
		else
			name = "[material.solid_name] synthesiser"
			desc = "A device that synthesises [material.solid_name]."
		matter = null

/obj/item/stack/material/cyborg/plastic
	name = "cyborg plastic synthesiser"
	icon_state = "sheet"
	material = /decl/material/solid/organic/plastic

/obj/item/stack/material/cyborg/steel
	name = "cyborg steel synthesiser"
	icon_state = "sheet"
	material = /decl/material/solid/metal/steel

/obj/item/stack/material/cyborg/plasteel
	name = "cyborg plasteel synthesiser"
	icon_state = "sheet-reinf"
	material = /decl/material/solid/metal/plasteel

/obj/item/stack/material/cyborg/wood
	name = "cyborg wood synthesiser"
	icon_state = "sheet-wood"
	material = /decl/material/solid/organic/wood

/obj/item/stack/material/cyborg/glass
	name = "cyborg glass synthesiser"
	icon_state = "sheet"
	material = /decl/material/solid/glass

/obj/item/stack/material/cyborg/fiberglass
	name = "cyborg fiberglass synthesiser"
	icon_state = "sheet"
	material = /decl/material/solid/fiberglass

/obj/item/stack/material/cyborg/glass/reinforced
	name = "cyborg reinforced glass synthesiser"
	icon_state = "sheet-reinf"
	material = /decl/material/solid/glass
	reinf_material = /decl/material/solid/metal/steel
	charge_costs = list(500, 1000)

/obj/item/stack/material/cyborg/aluminium
	name = "cyborg aluminium synthesiser"
	icon_state = "sheet"
	material = /decl/material/solid/metal/aluminium
