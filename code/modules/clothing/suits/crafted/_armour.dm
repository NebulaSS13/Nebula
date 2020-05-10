// Other armour icons: soft_armour, medium_armour, heavy_armour
/obj/item/clothing/suit/armor/crafted
	name = "improvised armour"
	desc = "An improvised set of armour."
	applies_material_colour = TRUE
	applies_material_name = TRUE
	icon_state = "improvised_armour"
	material = MAT_STEEL
	armor_degradation_speed = 1
	armor_type = /datum/extension/armor/ablative
	material_armor_multiplier = 1

/obj/item/clothing/suit/armor/crafted/set_material(new_material)
	. = ..()
	update_strings()

/obj/item/clothing/suit/armor/crafted/proc/update_strings()
	if(material)
		name = "improvised [material.display_name] armour"
		desc = "An improvised set of armour. This set is made out of [material.display_name]."
	else
		name = initial(name)
		desc = initial(desc)

/obj/item/clothing/suit/armor/crafted/cardboard
	material = MAT_CARDBOARD
/obj/item/clothing/suit/armor/crafted/leather
	material = MAT_LEATHER_GENERIC
/obj/item/clothing/suit/armor/crafted/copper
	material = MAT_COPPER
/obj/item/clothing/suit/armor/crafted/diamond
	material = MAT_DIAMOND
/obj/item/clothing/suit/armor/crafted/gold
	material = MAT_GOLD
/obj/item/clothing/suit/armor/crafted/supermatter
	material = MAT_SUPERMATTER
