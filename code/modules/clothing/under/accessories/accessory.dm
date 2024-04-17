/obj/item/clothing/accessory
	abstract_type = /obj/item/clothing/accessory
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	accessory_slot = ACCESSORY_SLOT_DECOR
	accessory_removable = TRUE

/obj/item/clothing/accessory/get_fallback_slot(var/slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_tie_str

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user)
	if(istype(loc, /obj/item/clothing))
		if(storage && user.check_dexterity((DEXTERITY_HOLD_ITEM|DEXTERITY_EQUIP_ITEM), TRUE))
			add_fingerprint(user)
			storage.open(user)
			return TRUE
		return FALSE //we aren't an object on the ground so don't call parent
	return ..()

/obj/item/clothing/accessory/get_pressure_weakness(pressure,zone)
	if(body_parts_covered & zone)
		return ..()
	return 1

//Necklaces
/obj/item/clothing/accessory/necklace
	name = "necklace"
	desc = "A simple necklace."
	icon = 'icons/clothing/accessories/jewelry/necklace.dmi'
	slot_flags = SLOT_FACE | SLOT_TIE

//Misc
/obj/item/clothing/accessory/kneepads
	name = "kneepads"
	desc = "A pair of synthetic kneepads. Doesn't provide protection from more than arthritis."
	icon = 'icons/clothing/accessories/armor/kneepads.dmi'

//Scarves
/obj/item/clothing/accessory/scarf
	name = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon = 'icons/clothing/accessories/clothing/scarf.dmi'

/obj/item/clothing/accessory/scarf/purple
	color = COLOR_PURPLE

/obj/item/clothing/accessory/scarf/red
	color = COLOR_RED

/obj/item/clothing/accessory/scarf/lightblue
	color = COLOR_LIGHT_CYAN

/obj/item/clothing/accessory/scarf/christmas
	name = "\improper Christmas scarf"
	icon = 'icons/clothing/accessories/clothing/scarf_christmas.dmi'


//Bracelets
/obj/item/clothing/accessory/bracelet
	name = "bracelet"
	desc = "A simple bracelet with a clasp."
	icon = 'icons/clothing/accessories/jewelry/bracelet.dmi'
