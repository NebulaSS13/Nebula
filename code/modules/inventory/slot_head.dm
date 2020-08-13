/datum/inventory_slot/head
	ui_loc = ui_head
	ui_label = "hair"
	overlay_slot = BP_HEAD
	slot_flags = SLOT_HEAD

/datum/inventory_slot/head/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		if(!thing || (thing.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR|HIDEMASK)))
			H.update_hair(redraw_mob)
			H.update_inv_ears(FALSE)
			H.update_inv_wear_mask(FALSE)
		H.update_inv_head(redraw_mob)
	return H	

/datum/inventory_slot/head/handle_post_unequip(var/mob/living/owner, var/obj/item/unequipped)
	if(iscarbon(owner))
		var/obj/item/mask = owner.get_equipped_item(BP_MOUTH)
		if(!(mask && (mask.item_flags & ITEM_FLAG_AIRTIGHT)))
			var/mob/living/carbon/C = owner
			C.set_internals(null)
	. = ..()