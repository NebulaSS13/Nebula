/datum/inventory_slot/body
	ui_loc = ui_oclothing
	ui_label = "suit"
	overlay_slot = BP_BODY
	slot_flags = SLOT_OVER_BODY

/datum/inventory_slot/body/handle_post_unequip(var/mob/living/owner, var/obj/item/unequipped)
	var/mob/living/carbon/human/H = owner
	if(istype(H) && H.s_store)
		H.drop_from_inventory(H.s_store)
	. = ..()

/datum/inventory_slot/body/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		if(!thing)
			H.update_inv_shoes(FALSE)
			H.update_inv_gloves(FALSE)
			H.update_inv_w_uniform(FALSE)
		else
			if(thing.flags_inv & HIDESHOES)
				H.update_inv_shoes(FALSE)
			if(thing.flags_inv & HIDEGLOVES)
				H.update_inv_gloves(FALSE)
			if(thing.flags_inv & HIDEJUMPSUIT)
				H.update_inv_w_uniform(FALSE)
		H.update_inv_wear_suit(redraw_mob)
	return H
