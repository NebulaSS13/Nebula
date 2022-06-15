/mob/living/set_inventory_slots(var/list/new_slots, var/preserve_hands)

	var/list/old_slots = inventory_slots
	inventory_slots = null

	// Keep hands if desired.
	if(preserve_hands && LAZYLEN(old_slots))
		for(var/slot in get_held_item_slot_strings())
			if(slot in old_slots)
				LAZYSET(inventory_slots, slot, old_slots[slot])

	// Check if we need to replace any existing slots.
	for(var/new_slot_id in new_slots)
		var/datum/inventory_slot/new_slot = LAZYACCESS(new_slots, new_slot_id)
		var/datum/inventory_slot/old_slot = LAZYACCESS(old_slots, new_slot_id)
		if(old_slot)
			new_slot.set_slot(old_slot.get_equipped_item())
			qdel(old_slot)
		LAZYSET(inventory_slots, new_slot.slot_id, new_slot)

/mob/living/get_held_item_slot_strings()
	return held_item_slot_strings

/mob/living/clear_inventory_slots(var/ignore_hands)
	for(var/slot in inventory_slots)
		if(!ignore_hands || !(slot in held_item_slot_strings))
			remove_inventory_slot(slot)
	QDEL_NULL_LIST(inventory_slots)

/mob/living/add_inventory_slot(var/datum/inventory_slot/inv_slot)
	. = ..()
	if(.)
		LAZYSET(inventory_slots, inv_slot.slot_id, inv_slot)

/mob/living/remove_inventory_slot(var/slot_id)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(inventory_slots, slot_id)
	if(inv_slot)
		var/held = inv_slot.get_equipped_item()
		if(held)
			drop_from_inventory(held)
		qdel(inv_slot)
	LAZYREMOVE(inventory_slots, slot_id)

/mob/living/get_inventory_slot(var/slot)
	return LAZYACCESS(inventory_slots, slot)

/mob/living/proc/add_held_item_slot(var/datum/inventory_slot/held_slot)
	if(!add_inventory_slot(held_slot))
		return FALSE
	LAZYDISTINCTADD(held_item_slot_strings, held_slot.slot_id)
	get_active_hand() // Refreshes selected held item slot if not currently set.
	queue_hand_rebuild()
	return TRUE

/mob/living/proc/remove_held_item_slot(var/slot)
	var/datum/inventory_slot/inv_slot = get_inventory_slot(slot)
	if(inv_slot)
		LAZYREMOVE(held_item_slot_strings, slot)
		remove_inventory_slot(slot)
		if(get_active_held_item_slot() == slot && length(held_item_slot_strings))
			select_held_item_slot(LAZYACCESS(held_item_slot_strings, 1))
		queue_hand_rebuild()

// Defer proc for the same of delimbing root limbs with multiple graspers (serpentid)
/mob/living/proc/queue_hand_rebuild()
	set waitfor = FALSE
	if(!pending_hand_rebuild)
		pending_hand_rebuild = TRUE
		sleep(1)
		pending_hand_rebuild = FALSE
		if(hud_used)
			hud_used.rebuild_hands()

/mob/living/select_held_item_slot(var/slot)
	if(slot != held_item_slot_selected && (slot in get_held_item_slot_strings()))
		held_item_slot_selected = slot
		if(hud_used)
			// TODO: convert hand screen inv items to have
			// a type, implement below on on_update_icon().
			for(var/obj/screen/inventory/hand in hud_used.hand_hud_objects)
				hand.cut_overlay("hand_selected")
				if(hand.slot_id == slot)
					hand.add_overlay("hand_selected")
				hand.compile_overlays()
		var/obj/item/I = get_active_hand()
		if(istype(I))
			I.on_active_hand()

/mob/living/get_active_held_item_slot()
	if(LAZYLEN(held_item_slot_strings) && (!held_item_slot_selected || !(held_item_slot_selected in held_item_slot_strings)))
		select_held_item_slot(LAZYACCESS(held_item_slot_strings, 1))
	return held_item_slot_selected

/mob/living/get_inventory_slots()
	return inventory_slots

/mob/living/can_use_held_item(var/obj/item/held)
	var/datum/inventory_slot/gripper/gripper = get_inventory_slot(get_active_held_item_slot())
	return istype(gripper) && gripper.can_use_held_item
