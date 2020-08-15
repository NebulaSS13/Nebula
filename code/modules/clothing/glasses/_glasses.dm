/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/obj_eyes.dmi'
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = SLOT_EYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1
	var/light_protection = 0

/obj/item/clothing/glasses/get_icon_state(mob/user_mob, slot)
	if(slot in item_state_slots)
		return item_state_slots[slot]
	else
		return icon_state

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()
