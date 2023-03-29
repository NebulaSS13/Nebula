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

/mob/living/carbon/human/set_item_unequipped_legacy(obj/W)
	if (W == _wear_suit)
		if(_s_store)
			drop_from_inventory(_s_store)
		_wear_suit = null
		update_inv_wear_suit()
		return TRUE
	if (W == _w_uniform)
		if (_r_store)
			drop_from_inventory(_r_store)
		if (_l_store)
			drop_from_inventory(_l_store)
		if (_wear_id)
			drop_from_inventory(_wear_id)
		if (_belt)
			drop_from_inventory(_belt)
		_w_uniform = null
		update_inv_w_uniform()
		return TRUE
	if (W == _gloves)
		_gloves = null
		update_inv_gloves()
		return TRUE
	if (W == _glasses)
		_glasses = null
		update_inv_glasses()
		return TRUE
	if (W == _head)
		_head = null
		if(istype(W, /obj/item))
			var/obj/item/I = W
			if(I.flags_inv & (HIDEMASK|BLOCK_ALL_HAIR))
				update_inv_wear_mask(0)
		if(src)
			var/obj/item/clothing/mask/mask = src.get_equipped_item(slot_wear_mask_str)
			if(!(mask && (mask.item_flags & ITEM_FLAG_AIRTIGHT)))
				set_internals(null)
		update_inv_head()
		return TRUE
	if (W == _l_ear)
		_l_ear = null
		if(_r_ear == W) //check for items that get equipped to both ear slots
			_r_ear = null
		update_inv_ears()
		return TRUE
	if (W == _r_ear)
		_r_ear = null
		if(_l_ear == W)
			_l_ear = null
		update_inv_ears()
		return TRUE
	if (W == _shoes)
		_shoes = null
		update_inv_shoes()
		return TRUE
	if (W == _belt)
		_belt = null
		update_inv_belt()
		return TRUE
	if (W == _wear_id)
		_wear_id = null
		update_inv_wear_id()
		return TRUE
	if (W == _r_store)
		_r_store = null
		update_inv_pockets()
		return TRUE
	if (W == _l_store)
		_l_store = null
		update_inv_pockets()
		return TRUE
	if (W == _s_store)
		_s_store = null
		update_inv_s_store()
		return TRUE
	if (W == _handcuffed)
		_handcuffed = null
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()
		update_inv_handcuffed()
		return TRUE
	return ..()

/mob/living/carbon/human/set_item_equipped_legacy(obj/item/W, slot, redraw_mob)
	switch(slot)
		if(slot_back_str)
			_back = W
			W.equipped(src, slot)
			update_inv_back(redraw_mob)
			return TRUE
		if(slot_wear_mask_str)
			_wear_mask = W
			update_hair(redraw_mob)	//rebuild hair
			update_inv_ears(0)
			W.equipped(src, slot)
			update_inv_wear_mask(redraw_mob)
			return TRUE
		if(slot_handcuffed_str)
			_handcuffed = W
			drop_held_items()
			update_inv_handcuffed(redraw_mob)
			return TRUE
		if(slot_belt_str)
			_belt = W
			W.equipped(src, slot)
			update_inv_belt(redraw_mob)
			return TRUE
		if(slot_wear_id_str)
			_wear_id = W
			W.equipped(src, slot)
			update_inv_wear_id(redraw_mob)
			return TRUE
		if(slot_l_ear_str)
			_l_ear = W
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
			return TRUE
		if(slot_r_ear_str)
			_r_ear = W
			W.equipped(src, slot)
			update_inv_ears(redraw_mob)
			return TRUE
		if(slot_glasses_str)
			_glasses = W
			W.equipped(src, slot)
			update_inv_glasses(redraw_mob)
			return TRUE
		if(slot_gloves_str)
			_gloves = W
			W.equipped(src, slot)
			update_inv_gloves(redraw_mob)
			return TRUE
		if(slot_head_str)
			_head = W
			update_hair(redraw_mob)	//rebuild hair
			update_inv_ears(0)
			if(_head.flags_inv & HIDEMASK)
				update_inv_wear_mask(0)
			if(istype(W,/obj/item/clothing/head/kitty))
				W.update_icon(src)
			W.equipped(src, slot)
			update_inv_head(redraw_mob)
			return TRUE
		if(slot_shoes_str)
			_shoes = W
			W.equipped(src, slot)
			update_inv_shoes(redraw_mob)
			return TRUE
		if(slot_wear_suit_str)
			_wear_suit = W
			if(_wear_suit.flags_inv & HIDESHOES)
				update_inv_shoes(0)
			if(_wear_suit.flags_inv & HIDEGLOVES)
				update_inv_gloves(0)
			if(_wear_suit.flags_inv & HIDEJUMPSUIT)
				update_inv_w_uniform(0)
			W.equipped(src, slot)
			update_inv_wear_suit(redraw_mob)
			return TRUE
		if(slot_w_uniform_str)
			_w_uniform = W
			if(_w_uniform.flags_inv & HIDESHOES)
				update_inv_shoes(0)
			W.equipped(src, slot)
			update_inv_w_uniform(redraw_mob)
			return TRUE
		if(slot_l_store_str)
			_l_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
			return TRUE
		if(slot_r_store_str)
			_r_store = W
			W.equipped(src, slot)
			update_inv_pockets(redraw_mob)
			return TRUE
		if(slot_s_store_str)
			_s_store = W
			W.equipped(src, slot)
			update_inv_s_store(redraw_mob)
			return TRUE
		if(slot_in_backpack_str)
			if(src.get_active_hand() == W)
				src.remove_from_mob(W)
			var/obj/item/back = get_equipped_item(slot_back_str)
			W.forceMove(back)
			return TRUE
		if(slot_tie_str)
			var/obj/item/clothing/under/uniform = get_equipped_item(slot_w_uniform_str)
			if(uniform)
				uniform.attackby(W,src)
			return TRUE
	return ..()

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/living/carbon/human/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	var/obj/item/covering = null
	var/check_flags = 0

	switch(slot)
		if(slot_wear_mask_str)
			covering = get_equipped_item(slot_head_str)
			check_flags = SLOT_FACE
		if(slot_glasses_str)
			covering = get_equipped_item(slot_head_str)
			check_flags = SLOT_EYES
		if(slot_gloves_str, slot_w_uniform_str)
			covering = get_equipped_item(slot_wear_suit_str)
		if(slot_l_ear_str, slot_r_ear_str)
			covering = get_equipped_item(slot_head_str)
			check_flags = SLOT_EARS

	if(covering && (covering.body_parts_covered & (I.body_parts_covered|check_flags)))
		to_chat(user, SPAN_WARNING("\The [covering] is in the way."))
		return 0
	return 1

/mob/living/carbon/human/get_equipped_item(var/slot)

	switch(slot)
		if(slot_wear_id_str)    return _wear_id
		if(slot_glasses_str)    return _glasses
		if(slot_gloves_str)     return _gloves
		if(slot_belt_str)       return _belt
		if(slot_head_str)       return _head
		if(slot_back_str)       return _back
		if(slot_handcuffed_str) return _handcuffed
		if(slot_l_store_str)    return _l_store
		if(slot_r_store_str)    return _r_store
		if(slot_wear_mask_str)  return _wear_mask
		if(slot_shoes_str)      return _shoes
		if(slot_wear_suit_str)  return _wear_suit
		if(slot_w_uniform_str)  return _w_uniform
		if(slot_s_store_str)    return _s_store
		if(slot_l_ear_str)      return _l_ear
		if(slot_r_ear_str)      return _r_ear
	. = ..()

/mob/living/carbon/human/get_equipped_items(var/include_carried = 0)
	. = ..()
	for(var/slot in global.equipped_slots)
		var/obj/item/thing = get_equipped_item(slot)
		if(istype(thing))
			LAZYADD(., thing)
	if(include_carried)
		for(var/slot in global.carried_slots)
			var/obj/item/thing = get_equipped_item(slot)
			if(istype(thing))
				LAZYADD(., thing)

//Same as get_covering_equipped_items, but using target zone instead of bodyparts flags
/mob/living/carbon/human/proc/get_covering_equipped_item_by_zone(var/zone)
	var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(src, zone)
	if(O)
		return get_covering_equipped_item(O.body_part)
