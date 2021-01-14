/obj/item/clothing/head/bandana/familiarband
	name = "familiar's headband"
	desc = "It's a simple headband made of leather."
	icon = 'icons/clothing/head/familiar.dmi'

/obj/item/clothing/under/familiargarb
	name = "familiar's garb"
	desc = "It looks like a cross between Robin Hood's tunic and some patchwork leather armor. Whoever put this together must have been in a hurry."
	icon = 'icons/clothing/under/tunic_familiar.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES, 
		laser = ARMOR_LASER_MINOR, 
		energy = ARMOR_ENERGY_SMALL
	)
	bodytype_restricted = list(BODYTYPE_HUMANOID)

/obj/item/clothing/under/familiargarb/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_w_uniform_str, -3)