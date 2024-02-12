// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "earring"
	desc = "An earring of some kind."
	icon = 'icons/clothing/ears/earring_stud.dmi'
	icon_state = ICON_STATE_WORLD
	gender = PLURAL
	w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/get_associated_equipment_slots()
	. = ..()
	LAZYDISTINCTADD(., global.ear_slots)
