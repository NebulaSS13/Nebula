// Other armour icons: soft_armour, medium_armour, heavy_armour
/obj/item/clothing/suit/armor/crafted
	name = "improvised armour"
	desc = "An improvised set of armour."
	applies_material_colour = TRUE
	applies_material_name = TRUE
	icon = 'icons/clothing/suit/armor/improvised.dmi'
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)
	armor_degradation_speed = 1
	armor_type = /datum/extension/armor/ablative
	material_armor_multiplier = 1
	valid_accessory_slots = list(ACCESSORY_SLOT_OVER, ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_OVER, ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)

/obj/item/clothing/suit/armor/crafted/Initialize()
	. = ..()
	var/decl/material/material = get_primary_material()
	if(material)
		name = "improvised [material.solid_name] armour"
		desc = "An improvised set of armour. This set is made out of [material.solid_name]."
	else
		name = initial(name)
		desc = initial(desc)

/obj/item/clothing/suit/armor/crafted/cardboard
	material_composition = list(/decl/material/solid/cardboard = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/suit/armor/crafted/leather
	material_composition = list(/decl/material/solid/leather = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/suit/armor/crafted/copper
	material_composition = list(/decl/material/solid/metal/copper = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/suit/armor/crafted/diamond
	material_composition = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/suit/armor/crafted/gold
	material_composition = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/suit/armor/crafted/supermatter
	material_composition = list(/decl/material/solid/exotic_matter = MATTER_AMOUNT_PRIMARY)
