/mob/living
	var/held_item_slot_selected
	var/list/held_item_slots
	var/list/inventory_slots
	var/pending_hand_rebuild

/mob/living/get_inventory_slots()
	return global.all_inventory_slots // inventory_slots

/mob/living/get_inventory_slot_datum(var/slot)
	return LAZYACCESS(inventory_slots, slot) || LAZYACCESS(held_item_slots, slot)

/mob/living/get_held_item_slots()
	return held_item_slots

/mob/living/has_held_item_slot()
	. = LAZYLEN(held_item_slots) >= 1

// Temporary proc, replace when the main inventory rewrite goes in.
/mob/living/get_all_valid_equipment_slots()
	for(var/slot in held_item_slots)
		LAZYDISTINCTADD(., slot)
	var/decl/species/my_species = get_species()
	for(var/slot in my_species?.hud?.equip_slots)
		LAZYDISTINCTADD(., slot)

/mob/living/proc/add_held_item_slot(var/datum/inventory_slot/held_slot)
	var/datum/inventory_slot/existing_slot = LAZYACCESS(held_item_slots, held_slot.slot_id)
	if(existing_slot)
		var/held = existing_slot.get_equipped_item()
		if(existing_slot)
			held_slot.set_slot(held)
		qdel(existing_slot)
	LAZYSET(held_item_slots, held_slot.slot_id, held_slot)
	if(!get_active_hand())
		select_held_item_slot(held_slot.slot_id)
	queue_hand_rebuild()

/mob/living/proc/remove_held_item_slot(var/slot)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
	if(inv_slot)
		var/held = inv_slot.get_equipped_item()
		if(held)
			drop_from_inventory(held)
		held_item_slots -= slot
		qdel(inv_slot)
		if(get_active_held_item_slot() == slot && length(held_item_slots))
			select_held_item_slot(held_item_slots[1])
		queue_hand_rebuild()

/mob/living/proc/select_held_item_slot(var/slot)
	var/last_slot = get_active_held_item_slot()
	if(slot != last_slot && LAZYACCESS(held_item_slots, slot))
		held_item_slot_selected = slot
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
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, get_active_held_item_slot())
	return inv_slot?.get_equipped_item()

/mob/living/get_active_held_item_slot()
	. = held_item_slot_selected
	if(. && !(. in held_item_slots))
		held_item_slot_selected = null
		. = null

/mob/living/get_inactive_held_items()
	for(var/hand_slot in (held_item_slots - get_active_held_item_slot()))
		var/datum/inventory_slot/inv_slot = held_item_slots[hand_slot]
		var/obj/item/thing = inv_slot?.get_equipped_item()
		if(istype(thing))
			LAZYADD(., thing)

/mob/living/is_holding_offhand(var/thing)
	. = (thing in get_inactive_held_items())

/mob/living/swap_hand()
	. = ..()
	if(length(held_item_slots))
		select_held_item_slot(next_in_list(get_active_held_item_slot(), held_item_slots))

/mob/living/get_empty_hand_slot()
	for(var/hand_slot in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[hand_slot]
		if(!inv_slot?.get_equipped_item())
			return hand_slot

/mob/living/get_empty_hand_slots()
	for(var/hand_slot in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[hand_slot]
		if(!inv_slot?.get_equipped_item())
			LAZYADD(., hand_slot)

/mob/living/drop_from_hand(var/slot, var/atom/Target)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
	var/held = inv_slot?.get_equipped_item()
	if(held)
		return drop_from_inventory(held, Target)
	. = ..()
