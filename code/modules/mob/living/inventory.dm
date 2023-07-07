/mob/living
	var/_held_item_slot_selected
	var/list/_held_item_slots
	var/list/_inventory_slots
	var/pending_hand_rebuild

/mob/living/get_inventory_slots()
	return _inventory_slots

/mob/living/get_inventory_slot_datum(var/slot)
	return LAZYACCESS(_inventory_slots, slot)

/mob/living/get_held_item_slots()
	return _held_item_slots

// Temporary proc, replace when the main inventory rewrite goes in.
/mob/living/get_all_valid_equipment_slots()
	for(var/slot in get_held_item_slots())
		LAZYDISTINCTADD(., slot)
	var/decl/species/my_species = get_species()
	for(var/slot in my_species?.hud?.equip_slots)
		LAZYDISTINCTADD(., slot)

/mob/living/add_held_item_slot(var/datum/inventory_slot/held_slot)
	var/datum/inventory_slot/existing_slot = get_inventory_slot_datum(held_slot.slot_id)
	if(existing_slot && existing_slot != held_slot)
		var/held = existing_slot.get_equipped_item()
		held_slot.set_slot(held)
		existing_slot.clear_slot()
		qdel(existing_slot)
	LAZYDISTINCTADD(_held_item_slots, held_slot.slot_id)
	add_inventory_slot(held_slot)
	if(!get_active_hand())
		select_held_item_slot(held_slot.slot_id)
	queue_hand_rebuild()

/mob/living/remove_held_item_slot(var/slot)
	var/datum/inventory_slot/inv_slot = istype(slot, /datum/inventory_slot) ? slot : get_inventory_slot_datum(slot)
	if(inv_slot)
		LAZYREMOVE(_held_item_slots, slot)
		remove_inventory_slot(inv_slot)
		var/held_slots = get_held_item_slots()
		if(get_active_held_item_slot() == slot && length(held_slots))
			select_held_item_slot(held_slots[1])
		queue_hand_rebuild()

/mob/living/select_held_item_slot(var/slot)
	var/last_slot = get_active_held_item_slot()
	if(slot != last_slot && (slot in get_held_item_slots()))
		_held_item_slot_selected = slot
		for(var/obj/screen/inventory/hand in hud_used?.hand_hud_objects)
			hand.cut_overlay("hand_selected")
			if(hand.slot_id == slot)
				hand.add_overlay("hand_selected")
			hand.compile_overlays()
		var/obj/item/I = get_active_hand()
		if(istype(I))
			I.on_active_hand()

// Defer proc for the sake of delimbing root limbs with multiple graspers (serpentid)
/mob/living/proc/queue_hand_rebuild()
	set waitfor = FALSE
	if(!pending_hand_rebuild)
		pending_hand_rebuild = TRUE
		sleep(1)
		pending_hand_rebuild = FALSE
		if(hud_used)
			hud_used.rebuild_hands()

/mob/living/get_active_hand()
	var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(get_active_held_item_slot())
	return inv_slot?.get_equipped_item()

/mob/living/get_active_held_item_slot()
	. = _held_item_slot_selected
	if(. && !(. in get_held_item_slots()))
		_held_item_slot_selected = null
		. = null

/mob/living/get_inactive_held_items()
	for(var/hand_slot in (get_held_item_slots() - get_active_held_item_slot()))
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		var/obj/item/thing = inv_slot?.get_equipped_item()
		if(istype(thing))
			LAZYADD(., thing)

/mob/living/is_holding_offhand(var/thing)
	. = (thing in get_inactive_held_items())

/mob/living/swap_hand()
	. = ..()
	var/held_slots = get_held_item_slots()
	if(length(held_slots))
		select_held_item_slot(next_in_list(get_active_held_item_slot(), held_slots))

/mob/living/get_empty_hand_slot()
	for(var/hand_slot in get_held_item_slots())
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		if(!inv_slot?.get_equipped_item())
			return hand_slot

/mob/living/get_empty_hand_slots()
	for(var/hand_slot in get_held_item_slots())
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		if(!inv_slot?.get_equipped_item())
			LAZYADD(., hand_slot)

/mob/living/drop_from_hand(var/slot, var/atom/target)
	var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(slot)
	var/held = inv_slot?.get_equipped_item()
	if(held)
		return drop_from_inventory(held, target)
	. = ..()

/mob/living/set_inventory_slots(var/list/new_slots)

	var/list/old_slots = _inventory_slots
	_inventory_slots = null

	// Keep held item slots.
	if(LAZYLEN(old_slots))
		for(var/slot in get_held_item_slots())
			if(slot in old_slots)
				LAZYSET(_inventory_slots, slot, old_slots[slot])
				old_slots -= slot

	// Check if we need to replace any existing slots.
	for(var/new_slot_id in new_slots)
		var/datum/inventory_slot/new_slot = new_slots[new_slot_id]
		var/datum/inventory_slot/old_slot = LAZYACCESS(old_slots, new_slot_id)
		if(old_slot)
			if(old_slot != new_slot)
				// Transfer the item from the old slot to the new slot
				new_slot.set_slot(old_slot.get_equipped_item())
				old_slot.clear_slot()
				qdel(old_slot)

			old_slots -= new_slot_id

		LAZYSET(_inventory_slots, new_slot.slot_id, new_slot)

	// For any old slots which had no equivalent, drop the item into the world
	for(var/old_slot_id in old_slots)
		var/datum/inventory_slot/old_slot = old_slots[old_slot_id]
		drop_from_inventory(old_slot.get_equipped_item())
		old_slot.clear_slot() // Call this manually since it is no longer in _inventory_slots
		qdel(old_slot)

/mob/living/add_inventory_slot(var/datum/inventory_slot/inv_slot)
	LAZYSET(_inventory_slots, inv_slot.slot_id, inv_slot)

/mob/living/remove_inventory_slot(var/slot)
	var/datum/inventory_slot/inv_slot = istype(slot, /datum/inventory_slot) ? slot : LAZYACCESS(_inventory_slots, slot)
	if(inv_slot)
		var/held = inv_slot.get_equipped_item()
		if(held)
			drop_from_inventory(held)
		qdel(inv_slot)
	LAZYREMOVE(_inventory_slots, slot)