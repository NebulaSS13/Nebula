//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_hand()
	var/obj/item/E = get_equipped_item(slot)
	if (istype(E))
		if(istype(W))
			E.attackby(W,src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)

//This is a SAFE proc. Use this instead of equip_to_slot()!
//set del_on_fail to have it delete W if it fails to equip
//set disable_warning to disable the 'you are unable to equip that' warning.
//unset redraw_mob to prevent the mob from being redrawn at the end.
//set force to replace items in the slot and ignore blocking overwear
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, del_on_fail = 0, disable_warning = 0, redraw_mob = 1, force = 0)
	if(!istype(W) || !slot)
		return FALSE

	if(!W.mob_can_equip(src, slot, disable_warning, force))
		if(del_on_fail)
			qdel(W)
		else if(!disable_warning)
			to_chat(src, SPAN_WARNING("You are unable to equip that."))
		return FALSE

	if(canUnEquip(W))
		equip_to_slot(W, slot, redraw_mob) //This proc should not ever fail.
		return TRUE

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/mob/proc/equip_to_slot(obj/item/W, slot)
	SHOULD_CALL_PARENT(TRUE)
	return istype(W) && !isnull(slot)

//This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to equip people when the rounds tarts and when events happen and such.
/mob/proc/equip_to_slot_or_del(obj/item/W, slot)
	return equip_to_slot_if_possible(W, slot, 1, 1, 0)

/mob/proc/equip_to_slot_or_store_or_drop(obj/item/W, slot)
	var/store = equip_to_slot_if_possible(W, slot, 0, 1, 0)
	if(!store)
		return equip_to_storage_or_drop(W)
	return store

//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
var/global/list/slot_equipment_priority = list( \
		slot_back_str,\
		slot_wear_id_str,\
		slot_w_uniform_str,\
		slot_wear_suit_str,\
		slot_wear_mask_str,\
		slot_head_str,\
		slot_shoes_str,\
		slot_gloves_str,\
		slot_l_ear_str,\
		slot_r_ear_str,\
		slot_glasses_str,\
		slot_belt_str,\
		slot_s_store_str,\
		slot_tie_str,\
		slot_l_store_str,\
		slot_r_store_str\
	)

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return 1

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W, var/skip_store = 0)
	if(!istype(W)) 
		return FALSE
	for(var/slot in slot_equipment_priority)
		if(skip_store)
			if(slot == slot_s_store_str || slot == slot_l_store_str || slot == slot_r_store_str)
				continue
		if(equip_to_slot_if_possible(W, slot, del_on_fail=0, disable_warning=1, redraw_mob=1))
			return TRUE
	return FALSE

/mob/proc/equip_to_storage(obj/item/newitem)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/storage))
		var/obj/item/storage/backpack = src.back
		if(backpack.can_be_inserted(newitem, null, 1))
			newitem.forceMove(src.back)
			return backpack

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/storage/S in src.contents)
		if(S.can_be_inserted(newitem, null, 1))
			newitem.forceMove(S)
			return S

/mob/proc/equip_to_storage_or_drop(obj/item/newitem)
	var/stored = equip_to_storage(newitem)
	if(!stored && newitem)
		newitem.forceMove(loc)
	return stored

/mob/proc/equip_to_storage_or_put_in_hands(obj/item/newitem)
	var/stored = equip_to_storage(newitem)
	if(!stored && newitem)
		put_in_hands(newitem)
	return stored
//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

//Returns the thing in our active hand
/mob/proc/get_active_hand()
	RETURN_TYPE(/obj/item)
	return null

/mob/proc/get_active_held_item_slot()
	return

//Returns the thing in our inactive hand
/mob/proc/get_inactive_held_items()
	RETURN_TYPE(/list)
	return null

/mob/proc/get_held_items()
	var/list/held_obj = get_inactive_held_items()
	if(length(held_obj))
		. = held_obj.Copy()
	held_obj = get_active_hand()
	if(held_obj)
		LAZYADD(., held_obj)

/mob/proc/get_empty_hand_slot()
	return

/mob/proc/get_empty_hand_slots()
	return

/mob/proc/put_in_active_hand(var/obj/item/W)
	. = equip_to_slot_if_possible(W, get_active_held_item_slot(), disable_warning = TRUE)

//Puts the item into (one of) our inactive hand(s) if possible. returns 1 on success.
/mob/proc/put_in_inactive_hand(var/obj/item/W)
	var/active_slot = get_active_held_item_slot()
	for(var/slot in get_empty_hand_slots())
		if(slot == active_slot)
			continue
		. = equip_to_slot_if_possible(W, slot, disable_warning = TRUE)
		if(.)
			break
//Puts the item our active hand if possible. Failing that it tries our inactive hand. Returns 1 on success.
//If both fail it drops it on the floor and returns 0.
//This is probably the main one you need to know :)

/mob/proc/put_in_hands_or_del(var/obj/item/W)
	. = put_in_hands(W)
	if(!. && !QDELETED(W))
		qdel(W)

/mob/proc/put_in_hands(var/obj/item/W)
	if(!W)
		return 0
	drop_from_inventory(W)
	return 0

/mob/proc/put_in_hands_or_store_or_drop(var/obj/item/W)
	. = put_in_hands(W)
	if(!.)
		. = equip_to_storage_or_drop(W)

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.
/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	if(W)
		remove_from_mob(W, target)
		if(!(W && W.loc)) return 1 // self destroying objects (tk, grabs)
		update_icon()
		return 1
	return 0

// Drops a held item from a given slot.
/mob/proc/drop_from_hand(var/slot, var/atom/Target)
	return FALSE

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something
/mob/proc/drop_item(var/atom/Target)
	if(!Target && !length(get_held_items()))
		if(length(get_active_grabs()))
			for(var/obj/item/grab/grab in get_active_grabs())
				qdel(grab)
				. = TRUE
			return
		var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
		if(hattable?.drop_hat(src))
			return TRUE
	. = drop_from_inventory(get_active_hand(), Target)

/*
	Removes the object from any slots the mob might have, calling the appropriate icon update proc.
	Does nothing else.

	>>>> *** DO NOT CALL THIS PROC DIRECTLY *** <<<<

	It is meant to be called only by other inventory procs.
	It's probably okay to use it if you are transferring the item between slots on the same mob,
	but chances are you're safer calling remove_from_mob() or drop_from_inventory() anyways.

	As far as I can tell the proc exists so that mobs with different inventory slots can override
	the search through all the slots, without having to duplicate the rest of the item dropping.
*/
/mob/proc/u_equip(obj/W)
	SHOULD_CALL_PARENT(TRUE)
	if(W == back)
		back = null
		update_inv_back(0)
		return TRUE
	if(W == wear_mask)
		wear_mask = null
		refresh_mask(W)
		return TRUE
	return FALSE

/mob/proc/refresh_mask(var/obj/item/removed)
	update_inv_wear_mask(0)

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return 0
	return get_inventory_slot(I) != 0

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return 1
	var/slot = get_inventory_slot(I)
	if(!slot && !istype(I.loc, /obj/item/rig_module))
		return 1 //already unequipped, so success
	return I.mob_can_unequip(src, slot)

/mob/proc/get_inventory_slot(obj/item/I)
	for(var/s in global.all_inventory_slots)
		if(get_equipped_item(s) == I)
			return s

//This differs from remove_from_mob() in that it checks if the item can be unequipped first. Use drop_from_inventory if you don't want to check.
/mob/proc/unEquip(obj/item/I, var/atom/target)
	if(!canUnEquip(I))
		return FALSE
	drop_from_inventory(I, target)
	return TRUE

//Attemps to remove an object on a mob.
/mob/proc/remove_from_mob(var/obj/O, var/atom/target)
	if(!O) // Nothing to remove, so we succeed.
		return 1
	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
	O.reset_plane_and_layer()
	O.screen_loc = null
	if(istype(O, /obj/item))
		var/obj/item/I = O
		if(target)
			I.forceMove(target)
		else
			I.dropInto(loc)
		I.dropped(src)
	return 1

/mob/proc/drop_held_items()
	for(var/thing in get_held_items())
		unEquip(thing)

//Returns the item equipped to the specified slot, if any.
/mob/proc/get_equipped_item(var/slot)
	SHOULD_CALL_PARENT(TRUE)
	switch(slot)
		if(slot_back_str) 
			return back
		if(slot_wear_mask_str) 
			return wear_mask

/mob/proc/get_equipped_items(var/include_carried = 0)
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	if(back)      
		. += back
	if(wear_mask) 
		. += wear_mask
	if(include_carried)
		. |= get_held_items()

/mob/proc/delete_inventory(var/include_carried = FALSE)
	for(var/entry in get_equipped_items(include_carried))
		drop_from_inventory(entry)
		qdel(entry)

// Returns all currently covered body parts
/mob/proc/get_covered_body_parts()
	. = 0
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		. |= I.body_parts_covered

// Returns the first item which covers any given body part
/mob/proc/get_covering_equipped_item(var/body_parts)
	if(isnum(body_parts))
		for(var/entry in get_equipped_items())
			var/obj/item/I = entry
			if(I.body_parts_covered & body_parts)
				return I

// Returns all items which covers any given body part
/mob/proc/get_covering_equipped_items(var/body_parts)
	. = list()
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		if(I.body_parts_covered & body_parts)
			. += I

/mob/proc/has_held_item_slot()
	return TRUE

/mob/proc/is_holding_offhand(var/thing)
	return FALSE

/mob/proc/ui_toggle_internals()
	return FALSE