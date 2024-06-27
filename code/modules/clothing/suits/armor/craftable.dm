// Other armour icons: soft_armour, medium_armour, heavy_armour
/obj/item/clothing/suit/armor/crafted
	name = "improvised armour"
	desc = "An improvised set of armour."
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	icon = 'icons/clothing/suits/armor/improvised.dmi'
	material = /decl/material/solid/metal/steel
	armor_degradation_speed = 1
	armor_type = /datum/extension/armor/ablative
	material_armor_multiplier = 1
	valid_accessory_slots = list(ACCESSORY_SLOT_OVER, ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_OVER, ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)

/obj/item/clothing/suit/armor/crafted/set_material(new_material)
	. = ..()
	update_strings()

/obj/item/clothing/suit/armor/crafted/proc/update_strings()
	if(material)
		name = "improvised [material.solid_name] armour"
		desc = "An improvised set of armour. This set is made out of [material.solid_name]."
	else
		name = initial(name)
		desc = initial(desc)

/obj/item/clothing/suit/armor/crafted/cardboard
	material = /decl/material/solid/organic/cardboard
/obj/item/clothing/suit/armor/crafted/leather
	material = /decl/material/solid/organic/leather
/obj/item/clothing/suit/armor/crafted/copper
	material = /decl/material/solid/metal/copper
/obj/item/clothing/suit/armor/crafted/diamond
	material = /decl/material/solid/gemstone/diamond
/obj/item/clothing/suit/armor/crafted/gold
	material = /decl/material/solid/metal/gold
/obj/item/clothing/suit/armor/crafted/supermatter
	material = /decl/material/solid/exotic_matter
