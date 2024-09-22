/obj/item/clothing/suit/straight_jacket
	name = "straitjacket"
	desc = "A suit that completely restrains the wearer."
	icon = 'icons/clothing/suits/straightjacket.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)

/obj/item/clothing/suit/straight_jacket/Initialize()
	. = ..()
	set_extension(src, /datum/extension/resistable/straightjacket)

/obj/item/clothing/suit/straight_jacket/equipped(var/mob/user, var/slot)
	. = ..()
	if(slot == slot_wear_suit_str)
		if(isliving(user))
			var/mob/living/M = user
			var/obj/item/cuffs = M.get_equipped_item(slot_handcuffed_str)
			if(cuffs)
				M.try_unequip(cuffs)
		user.drop_held_items()
