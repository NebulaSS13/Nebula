#define CRAFTED_ARMOR_DIVISOR 2
#define BASIC_ARMOUR_VALUES list(melee = ARMOR_MELEE_MAJOR, bullet = ARMOR_BALLISTIC_RESISTANT, laser = ARMOR_LASER_RIFLES, energy = ARMOR_ENERGY_STRONG, bomb = ARMOR_BOMB_RESISTANT,rad  = ARMOR_RAD_RESISTANT)

// Other armour icons: soft_armour, medium_armour, heavy_armour
/obj/item/clothing/suit/armor/crafted
	name = "improvised armour"
	desc = "An improvised set of armour."
	applies_material_colour = TRUE
	applies_material_name = TRUE
	icon_state = "improvised_armour"
	material = MAT_STEEL
	gender = PLURAL
	armor = BASIC_ARMOUR_VALUES
	armor_degradation_speed = 1
	armor_type = /datum/extension/armor/ablative

/obj/item/clothing/suit/armor/crafted/set_material(new_material)
	. = ..()
	update_strings()
	update_armour_values()

/obj/item/clothing/suit/armor/crafted/proc/update_strings()
	if(material)
		name = "improvised [material.display_name] armour"
		desc = "An improvised set of armour. This set is made out of [material.display_name]."
	else
		name = initial(name)
		desc = initial(desc)

/obj/item/clothing/suit/armor/crafted/proc/update_armour_values()
	armor = BASIC_ARMOUR_VALUES
	armor_degradation_speed = initial(armor_degradation_speed)
	if(material.is_brittle())
		armor_degradation_speed = 10
	else
		armor_degradation_speed = max(0.1, 200-(material.integrity/200))
	for(var/val in list("melee", "bullet", "bomb"))
		if(armor[val])
			armor[val] *= (material.hardness/100)
	for(var/val in list("laser", "energy", "rad"))
		if(armor[val])
			armor[val] *= (material.reflectiveness/100)
	var/set_armour
	if(LAZYLEN(armor))
		for(var/val in armor)
			if(armor[val])
				set_armour = TRUE
				set_extension(src, armor_type, armor, armor_degradation_speed)
				break
	if(!set_armour)
		remove_extension(src, armor_type)

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

#undef CRAFTED_ARMOR_DIVISOR
#undef BASIC_ARMOUR_VALUES