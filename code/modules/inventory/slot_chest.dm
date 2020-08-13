/datum/inventory_slot/chest
	ui_loc = ui_iclothing
	ui_label = "center"
	overlay_slot = BP_CHEST
	slot_flags = SLOT_UPPER_BODY

/datum/inventory_slot/chest/handle_icon_updates(var/mob/living/owner, var/obj/item/thing, var/redraw_mob)
	var/mob/living/carbon/human/H = ..()
	if(H)
		if(!thing || (thing.flags_inv & HIDESHOES))
			H.update_inv_shoes(FALSE)
		H.update_inv_w_uniform(redraw_mob)
	return H

/datum/inventory_slot/chest/handle_post_unequip(var/mob/living/owner, var/obj/item/unequipped)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.r_store)
			H.drop_from_inventory(H.r_store)
		if(H.l_store)
			H.drop_from_inventory(H.l_store)
	var/obj/item/id = owner.get_equipped_item(BP_NECK)
	if(id)
		owner.drop_from_inventory(id)
	var/obj/item/belt = owner.get_equipped_item(BP_GROIN)
	if(belt)
		owner.drop_from_inventory(belt)
	. = ..()