/*
Add fingerprints to items when we put them in our hands.
This saves us from having to call add_fingerprint() any time something is put in a human's hands programmatically.
*/
/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			to_chat(H, SPAN_NOTICE("You are not holding anything to equip."))
			return
		if(!H.equip_to_appropriate_slot(I))
			to_chat(H, SPAN_WARNING("You are unable to equip that."))

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for (var/slot in slots)
		if (equip_to_slot_if_possible(W, slots[slot], del_on_fail = 0))
			return slot
	if (del_on_fail)
		qdel(W)
	return null

/mob/living/carbon/human/put_in_hands(var/obj/item/W)
	if(!W)
		return 0
	if(put_in_active_hand(W) || put_in_inactive_hand(W))
		return 1
	return ..()

/mob/living/carbon/human/proc/has_organ(name)
	var/obj/item/organ/external/O = organs_by_name[name]
	return (O && !O.is_stump())

/mob/living/carbon/human/proc/has_organ_for_slot(slot)
	switch(slot)
		if(slot_back_str)
			return has_organ(BP_CHEST)
		if(slot_wear_mask_str)
			return has_organ(BP_HEAD)
		if(slot_handcuffed_str)
			return has_organ(BP_L_HAND) && has_organ(BP_R_HAND)
		if(slot_belt_str)
			return has_organ(BP_CHEST)
		if(slot_wear_id_str)
			// the only relevant check for this is the uniform check
			return 1
		if(slot_l_ear_str)
			return has_organ(BP_HEAD)
		if(slot_r_ear_str)
			return has_organ(BP_HEAD)
		if(slot_glasses_str)
			return has_organ(BP_HEAD)
		if(slot_gloves_str)
			return has_organ(BP_L_HAND) || has_organ(BP_R_HAND)
		if(slot_head_str)
			return has_organ(BP_HEAD)
		if(slot_shoes_str)
			return has_organ(BP_L_FOOT) || has_organ(BP_R_FOOT)
		if(slot_wear_suit_str)
			return has_organ(BP_CHEST)
		if(slot_w_uniform_str)
			return has_organ(BP_CHEST)
		if(slot_l_store_str)
			return has_organ(BP_CHEST)
		if(slot_r_store_str)
			return has_organ(BP_CHEST)
		if(slot_s_store_str)
			return has_organ(BP_CHEST)
		if(slot_in_backpack_str)
			return 1
		if(slot_tie_str)
			return 1
		else
			return has_organ(slot)

/mob/living/carbon/human/u_equip(obj/W)
	. = ..()
	if(!.)
		. = TRUE
		if (W == wear_suit)
			if(s_store)
				drop_from_inventory(s_store)
			wear_suit = null
			update_inv_wear_suit()
		else if (W == w_uniform)
			if (r_store)
				drop_from_inventory(r_store)
			if (l_store)
				drop_from_inventory(l_store)
			if (wear_id)
				drop_from_inventory(wear_id)
			if (belt)
				drop_from_inventory(belt)
			w_uniform = null
			update_inv_w_uniform()
		else if (W == gloves)
			gloves = null
			update_inv_gloves()
		else if (W == glasses)
			glasses = null
			update_inv_glasses()
		else if (W == head)
			head = null
			if(istype(W, /obj/item))
				var/obj/item/I = W
				if(I.flags_inv & (HIDEMASK|BLOCKHAIR|BLOCKHEADHAIR))
					update_hair(0)	//rebuild hair
					update_inv_ears(0)
					update_inv_wear_mask(0)
			if(src)
				var/obj/item/clothing/mask/wear_mask = src.get_equipped_item(slot_wear_mask_str)
				if(!(wear_mask && (wear_mask.item_flags & ITEM_FLAG_AIRTIGHT)))
					set_internals(null)
			update_inv_head()
		else if (W == l_ear)
			l_ear = null
			if(r_ear == W) //check for items that get equipped to both ear slots
				r_ear = null
			update_inv_ears()
		else if (W == r_ear)
			r_ear = null
			if(l_ear == W)
				l_ear = null
			update_inv_ears()
		else if (W == shoes)
			shoes = null
			update_inv_shoes()
		else if (W == belt)
			belt = null
			update_inv_belt()
		else if (W == wear_mask)
			wear_mask = null
			if(istype(W, /obj/item))
				var/obj/item/I = W
				if(I.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
					update_hair(0)	//rebuild hair
					update_inv_ears(0)
			var/obj/item/clothing/mask/head = src.get_equipped_item(slot_head_str)
			if(!(head && (head.item_flags & ITEM_FLAG_AIRTIGHT)))
				set_internals(null)
			update_inv_wear_mask()
		else if (W == wear_id)
			wear_id = null
			update_inv_wear_id()
		else if (W == r_store)
			r_store = null
			update_inv_pockets()
		else if (W == l_store)
			l_store = null
			update_inv_pockets()
		else if (W == s_store)
			s_store = null
			update_inv_s_store()
		else if (W == back)
			back = null
			update_inv_back()
		else if (W == handcuffed)
			handcuffed = null
			if(buckled && buckled.buckle_require_restraints)
				buckled.unbuckle_mob()
			update_inv_handcuffed()
		else
			. = FALSE
	if(.)
		update_action_buttons()

//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
//set redraw_mob to 0 if you don't wish the hud to be updated - if you're doing it manually in your own proc.

// Hands rewrite note July 2020 - prior to this commit, slot is always numerical (using the slot_blah constants)
// but I need to pass it arbitrary bodypart flags for use in the new held items system. If slot is not a number, 
// we assume it is expecting to map to a held item inventory slot. The explicit isnum() check is there because if
// we go ahead and let it try to evaluate a number, the associative list will try to use it as a numerical index
// and will runtime out the ass. 
// Post hands rewrite I plan to conver the rest of the inventory system to a string-based inventory slot system
// so at that point the numerical flags will be removed and this proc (and the rest of the chain) can be rewritten.

/mob/living/carbon/human/equip_to_slot(obj/item/W, slot, redraw_mob = 1)

	. = ..()
	if(!. || !has_organ_for_slot(slot))
		return

	// TODO: unify this block with below when inventory
	// is rewritten to remove boilerplate horseshit.
	u_equip(W)
	var/obj/item/old_item = get_equipped_item(slot)
	if(!isnum(slot))
		var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
		if(inv_slot && !inv_slot.holding)
			W.forceMove(src)
			inv_slot.holding = W
			W.screen_loc = inv_slot.ui_loc
			W.hud_layerise()
			W.equipped(src, slot)
			W.update_held_icon()
			update_inv_hands(redraw_mob)
			if(W.action_button_name)
				update_action_buttons()
			if(old_item)
				qdel(old_item)
			return TRUE
	// End boilerplate.

	if(!species || !species.hud || !(slot in species.hud.equip_slots)) 
		return
	W.forceMove(src)

	switch(slot)
		if(slot_back_str)
			src.back = W
			W.equipped(src, slot)
			update_inv_back(redraw_mob)
		if(slot_wear_mask_str)
			src.wear_mask = W
			if(wear_mask.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
				update_hair(redraw_mob)	//rebuild hair
				update_inv_ears(0)
			W.equipped(src, slot)
			update_inv_wear_mask(redraw_mob)
		if(slot_handcuffed_str)
			src.handcuffed = W
			drop_held_items()
			update_inv_handcuffed(redraw_mob)
		if(slot_belt_str)
			src.belt = W
			W.equipped(src, slot)
			update_inv_belt(redraw_mob)
		if(slot_wear_id_str)
			src.wear_id = W
			W.equipped(src, slot)
			update_inv_wear_id(redraw_mob)
		if(slot_l_ear_str)
			src.l_ear = W
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(slot_r_ear_str)
			src.r_ear = W
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
		if(slot_glasses_str)
			src.glasses = W
			W.equipped(src, slot)
			update_inv_glasses(redraw_mob)
		if(slot_gloves_str)
			src.gloves = W
			W.equipped(src, slot)
			update_inv_gloves(redraw_mob)
		if(slot_head_str)
			src.head = W
			if(head.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR|HIDEMASK))
				update_hair(redraw_mob)	//rebuild hair
				update_inv_ears(0)
				update_inv_wear_mask(0)
			if(istype(W,/obj/item/clothing/head/kitty))
				W.update_icon(src)
			W.equipped(src, slot)
			update_inv_head(redraw_mob)
		if(slot_shoes_str)
			src.shoes = W
			W.equipped(src, slot)
			update_inv_shoes(redraw_mob)
		if(slot_wear_suit_str)
			src.wear_suit = W
			if(wear_suit.flags_inv & HIDESHOES)
				update_inv_shoes(0)
			if(wear_suit.flags_inv & HIDEGLOVES)
				update_inv_gloves(0)
			if(wear_suit.flags_inv & HIDEJUMPSUIT)
				update_inv_w_uniform(0)
			W.equipped(src, slot)
			update_inv_wear_suit(redraw_mob)
		if(slot_w_uniform_str)
			src.w_uniform = W
			if(w_uniform.flags_inv & HIDESHOES)
				update_inv_shoes(0)
			W.equipped(src, slot)
			update_inv_w_uniform(redraw_mob)
		if(slot_l_store_str)
			src.l_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(slot_r_store_str)
			src.r_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
		if(slot_s_store_str)
			src.s_store = W
			W.equipped(src, slot)
			update_inv_s_store(redraw_mob)
		if(slot_in_backpack_str)
			if(src.get_active_hand() == W)
				src.remove_from_mob(W)
			W.forceMove(src.back)
		if(slot_tie_str)
			var/obj/item/clothing/under/uniform = src.w_uniform
			if(uniform)
				uniform.attackby(W,src)
		else
			to_chat(src, SPAN_WARNING("You are trying to equip this item to an unsupported inventory slot. If possible, please write a ticket with steps to reproduce. Slot was: [slot]"))
			return

	W.hud_layerise()
	for(var/s in species.hud.gear)
		var/list/gear = species.hud.gear[s]
		if(gear["slot"] == slot)
			W.screen_loc = gear["loc"]
	if(W.action_button_name)
		update_action_buttons()

	// if we replaced an item, delete the old item. do this at the end to make the replacement seamless
	if(old_item)
		qdel(old_item)

	return 1

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/living/carbon/human/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	var/obj/item/covering = null
	var/check_flags = 0

	switch(slot)
		if(slot_wear_mask_str)
			covering = src.head
			check_flags = SLOT_FACE
		if(slot_glasses_str)
			covering = src.head
			check_flags = SLOT_EYES
		if(slot_gloves_str, slot_w_uniform_str)
			covering = src.wear_suit
		if(slot_l_ear_str, slot_r_ear_str)
			covering = src.head
			check_flags = SLOT_EARS

	if(covering && (covering.body_parts_covered & (I.body_parts_covered|check_flags)))
		to_chat(user, SPAN_WARNING("\The [covering] is in the way."))
		return 0
	return 1

/mob/living/carbon/human/get_equipped_item(var/slot)

	switch(slot)
		if(slot_back_str)       return back
		if(slot_handcuffed_str) return handcuffed
		if(slot_l_store_str)    return l_store
		if(slot_r_store_str)    return r_store
		if(slot_wear_mask_str)  return wear_mask
		if(slot_wear_id_str)    return wear_id
		if(slot_glasses_str)    return glasses
		if(slot_gloves_str)     return gloves
		if(slot_head_str)       return head
		if(slot_shoes_str)      return shoes
		if(slot_belt_str)       return belt
		if(slot_wear_suit_str)  return wear_suit
		if(slot_w_uniform_str)  return w_uniform
		if(slot_s_store_str)    return s_store
		if(slot_l_ear_str)      return l_ear
		if(slot_r_ear_str)      return r_ear
	. = ..()

/mob/living/carbon/human/get_equipped_items(var/include_carried = 0)
	. = ..()
	if(belt)      . += belt
	if(l_ear)     . += l_ear
	if(r_ear)     . += r_ear
	if(glasses)   . += glasses
	if(gloves)    . += gloves
	if(head)      . += head
	if(shoes)     . += shoes
	if(wear_id)   . += wear_id
	if(wear_suit) . += wear_suit
	if(w_uniform) . += w_uniform

	if(include_carried)
		if(l_store)    . += l_store
		if(r_store)    . += r_store
		if(handcuffed) . += handcuffed
		if(s_store)    . += s_store

//Same as get_covering_equipped_items, but using target zone instead of bodyparts flags
/mob/living/carbon/human/proc/get_covering_equipped_item_by_zone(var/zone)
	var/obj/item/organ/external/O = get_organ(zone)
	if(O)
		return get_covering_equipped_item(O.body_part)

/mob/living/carbon/human/has_held_item_slot()
	for(var/bp in held_item_slots)
		var/obj/item/organ/external/E = organs_by_name[bp]
		if(E && !E.is_stump())
			return TRUE
	return FALSE
