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
			to_chat(H, SPAN_WARNING("You are not holding anything to equip."))
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
		if(BP_SHOULDERS)
			return has_organ(BP_CHEST)
		if(slot_handcuffed_str)
			return has_organ(BP_L_HAND) && has_organ(BP_R_HAND)
		if(slot_legcuffed_str)
			return has_organ(BP_L_FOOT) && has_organ(BP_R_FOOT)
		if(BP_GROIN)
			return has_organ(BP_CHEST)
		if(BP_NECK)
			// the only relevant check for this is the uniform check
			return 1
		if(BP_L_EAR)
			return has_organ(BP_HEAD)
		if(BP_R_EAR )
			return has_organ(BP_HEAD)
		if(slot_gloves_str)
			return has_organ(BP_L_HAND) || has_organ(BP_R_HAND)
		if(slot_shoes_str)
			return has_organ(BP_L_FOOT) || has_organ(BP_R_FOOT)
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

		if(BP_MOUTH)
			return has_organ(BP_HEAD)
		if(BP_EYES)
			return has_organ(BP_HEAD)
		if(BP_BODY)
			return has_organ(BP_CHEST)

		else
			return has_organ(slot)

/mob/living/carbon/human/u_equip(obj/W)
	. = ..()
	if(!.)
		. = TRUE
		if (W == gloves)
			gloves = null
			update_inv_gloves()
		else if (W == shoes)
			shoes = null
			update_inv_shoes()
		else if (W == r_store)
			r_store = null
			update_inv_pockets()
		else if (W == l_store)
			l_store = null
			update_inv_pockets()
		else if (W == s_store)
			s_store = null
			update_inv_s_store()
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
		var/datum/inventory_slot/inv_slot = LAZYACCESS(inventory_slots, slot)
		if(inv_slot && !inv_slot.holding)
			W.forceMove(src)
			inv_slot.holding = W
			W.screen_loc = inv_slot.ui_loc
			W.hud_layerise()
			W.equipped(src, slot)
			W.update_held_icon()
			inv_slot.handle_icon_updates(src, W, redraw_mob)
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
		if(slot_handcuffed_str)
			src.handcuffed = W
			drop_held_items()
			update_inv_handcuffed(redraw_mob)
		if(slot_gloves_str)
			src.gloves = W
			W.equipped(src, slot)
			update_inv_gloves(redraw_mob)
		if(slot_shoes_str)
			src.shoes = W
			W.equipped(src, slot)
			update_inv_shoes(redraw_mob)
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
			var/obj/item/backpack = get_equipped_item(BP_SHOULDERS)
			if(backpack)
				if(src.get_active_hand() == W)
					src.remove_from_mob(W)
				W.forceMove(backpack)
		if(slot_tie_str)
			var/obj/item/clothing/under/uniform = get_equipped_item(BP_CHEST)
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
	var/obj/item/covering
	var/check_flags = 0
	switch(slot)
		if(BP_MOUTH)
			covering = get_equipped_item(BP_HEAD)
			check_flags = SLOT_FACE
		if(BP_EYES)
			covering = get_equipped_item(BP_HEAD)
			check_flags = SLOT_EYES
		if(BP_L_EAR, BP_R_EAR)
			covering = get_equipped_item(BP_HEAD)
		if(slot_gloves_str, BP_CHEST)
			covering = get_equipped_item(BP_BODY)
		if(BP_L_EAR, BP_R_EAR)
			covering = get_equipped_item(BP_HEAD)
			check_flags = SLOT_EARS

	if(covering && (covering.body_parts_covered & (I.body_parts_covered|check_flags)))
		to_chat(user, SPAN_WARNING("\The [covering] is in the way."))
		return 0
	return 1

/mob/living/carbon/human/get_equipped_item(var/slot)
	switch(slot)
		if(slot_handcuffed_str) return handcuffed
		if(slot_l_store_str)    return l_store
		if(slot_r_store_str)    return r_store
		if(slot_gloves_str)     return gloves
		if(slot_shoes_str)      return shoes
		if(slot_s_store_str)    return s_store
	. = ..()

/mob/living/carbon/human/get_equipped_items(var/include_carried = 0)
	. = ..()
	if(gloves)    . += gloves
	if(shoes)     . += shoes

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
