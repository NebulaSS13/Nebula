/datum/inventory_slot/face
	ui_loc = ui_mask
	ui_label = "mask"
	overlay_slot = BP_MOUTH
	slot_flags = SLOT_FACE

/datum/inventory_slot/face/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		if(!thing || (thing.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR)))
			H.update_hair(FALSE)
			H.update_inv_ears(FALSE)
		H.update_inv_wear_mask(redraw_mob)
	return H

/datum/inventory_slot/face/handle_post_unequip(var/mob/living/owner, var/obj/item/unequipped)
	if(iscarbon(owner))
		var/obj/item/head = owner.get_equipped_item(BP_HEAD)
		if(!(head && (head.item_flags & ITEM_FLAG_AIRTIGHT)))
			var/mob/living/carbon/C = owner
			C.set_internals(null)
	. = ..()