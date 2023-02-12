/datum/inventory_slot
	var/slot_id
	var/ui_loc
	var/ui_label
	var/overlay_slot
	var/obj/item/holding

/datum/inventory_slot/New(var/new_slot, var/new_ui_loc, var/new_overlay_slot, var/new_label)
	slot_id = new_slot
	ui_loc = new_ui_loc
	ui_label = new_label
	overlay_slot = new_overlay_slot || new_slot

/mob/living
	var/held_item_slot_selected
	var/list/held_item_slots
	var/list/inventory_slots

/mob/living/get_inventory_slots()
	return global.all_inventory_slots // inventory_slots

/mob/living/get_inventory_slot_datum(var/slot)
	return LAZYACCESS(inventory_slots, slot) || LAZYACCESS(held_item_slots, slot)

/mob/living/get_held_item_slots()
	return held_item_slots

/mob/living/has_held_item_slot()
	. = LAZYLEN(held_item_slots) >= 1

/mob/living/proc/add_held_item_slot(var/slot, var/new_ui_loc, var/new_overlay_slot, var/new_label)
	LAZYSET(held_item_slots, slot, new /datum/inventory_slot(slot, new_ui_loc, new_overlay_slot, new_label))
	hud_used?.rebuild_hands(list(slot), FALSE)
	if(!get_active_hand())
		select_held_item_slot(slot)

/mob/living/proc/remove_held_item_slot(var/slot)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
	if(inv_slot)
		if(inv_slot.holding)
			drop_from_inventory(inv_slot.holding)
		held_item_slots -= slot
		qdel(inv_slot)
		hud_used?.rebuild_hands(FALSE, list(slot))
		if(get_active_held_item_slot() == slot && length(held_item_slots))
			select_held_item_slot(held_item_slots[1])

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

/mob/living/get_active_hand()
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, get_active_held_item_slot())
	return inv_slot?.holding

/mob/living/get_active_held_item_slot()
	. = held_item_slot_selected
	if(. && !(. in held_item_slots))
		held_item_slot_selected = null
		. = null

/mob/living/get_inactive_held_items()
	for(var/hand_slot in (held_item_slots - get_active_held_item_slot()))
		var/datum/inventory_slot/inv_slot = held_item_slots[hand_slot]
		var/obj/item/thing = inv_slot?.holding
		if(istype(thing))
			LAZYADD(., thing)

/mob/living/is_holding_offhand(var/thing)
	. = (thing in get_inactive_held_items())

/mob/living/swap_hand()
	. = ..()
	select_held_item_slot(next_in_list(get_active_held_item_slot(), held_item_slots))

/mob/living/get_empty_hand_slot()
	for(var/hand_slot in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[hand_slot]
		if(inv_slot && !inv_slot.holding)
			return hand_slot

/mob/living/get_empty_hand_slots()
	for(var/hand_slot in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[hand_slot]
		if(inv_slot && !inv_slot.holding)
			LAZYADD(., hand_slot)

/mob/living/get_equipped_item(var/slot)
	. = ..()
	if(!.)
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(slot)
		return inv_slot?.holding

/mob/living/drop_from_hand(var/slot, var/atom/Target)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
	if(inv_slot?.holding)
		return drop_from_inventory(inv_slot.holding, Target)
	. = ..()

/mob/living/u_equip(obj/W)
	. = ..()
	if(!.)
		for(var/hand_slot in held_item_slots)
			var/datum/inventory_slot/inv_slot = held_item_slots[hand_slot]
			if(inv_slot?.holding == W)
				inv_slot.holding = null
				. = TRUE
				break
		if(.)
			update_inv_hands()
