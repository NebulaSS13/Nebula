var/list/bp_slot_id_to_descriptive_name = list(
	BP_EYES = "eyes",
	BP_GROIN = "waist",
	BP_NECK = null,
	BP_BODY = null,
	BP_L_EAR = "left ear",
	BP_R_EAR = "right ear"
)

/datum/inventory_slot/proc/get_examine_line(var/mob/living/owner, skipgloves, skipsuitstorage, skipjumpsuit, skipshoes, skipmask, skipears, skipeyes, skipface)

	if(slot_id == BP_EYES && skipeyes)
		return
	else if(slot_id == BP_MOUTH && skipmask)
		return
	else if(slot_id == BP_CHEST && skipjumpsuit)
		return
	else if((slot_id == BP_L_EAR || slot_id == BP_R_EAR) && skipears)
		return

	var/bp_name = slot_id
	if(slot_id in global.bp_slot_id_to_descriptive_name)
		bp_name = global.bp_slot_id_to_descriptive_name[slot_id]
	else
		var/obj/item/organ/external/E = owner.get_organ(slot_id)
		if(E)
			bp_name = E.name

	var/datum/gender/G = gender_datums[owner.get_gender()]
	. = "[G.He]"
	if(slot_id in owner.held_item_slots)
		. = "[.] [G.is] holding [holding.get_examine_line()]"
		if(bp_name)
			. = "[.] in"
	else 
		if(slot_id == BP_EYES || slot_id == BP_GROIN)
			. = "[.] [G.has] [holding.get_examine_line()]"
			if(bp_name)
				if(slot_id == BP_EYES)
					. = "[.] covering"
				else
					. = "[.] about"
		else
			. = "[.] [G.is] wearing [holding.get_examine_line()]"
			if(bp_name)
				. = "[.] on"
	if(bp_name)
		. = "[.] [G.his] [bp_name]"
	. += "."

/datum/inventory_slot/proc/handle_post_unequip(var/mob/living/owner, var/obj/item/unequipped)
	handle_icon_updates(owner, unequipped, TRUE)

/mob/living
	var/held_item_slot_selected
	var/list/inventory_slots
	var/list/held_item_slots

/mob/living/get_equipped_items(var/include_carried = 0)
	. = ..()
	for(var/bp in inventory_slots)
		if(bp in held_item_slots)
			continue
		var/datum/inventory_slot/inv_slot = inventory_slots[bp]
		if(inv_slot.holding)
			. |= inv_slot.holding

/mob/living/has_held_item_slot()
	. = LAZYLEN(held_item_slots) >= 1

/mob/living/proc/add_inventory_slot(var/slot, var/new_ui_loc, var/new_overlay_slot, var/new_label, var/can_toggle, var/inventory_slot_type = /datum/inventory_slot)
	if(!LAZYACCESS(inventory_slots, slot))
		. = new inventory_slot_type(slot, new_ui_loc, new_overlay_slot, new_label, can_toggle)
		LAZYSET(inventory_slots, slot, .)
		hud_used?.rebuild_equipment_slots(list(slot), FALSE)

/mob/living/proc/add_held_item_slot(var/slot, var/new_ui_loc, var/new_overlay_slot, var/new_label, var/can_toggle)
	. = add_inventory_slot(slot, new_ui_loc, new_overlay_slot, new_label, can_toggle, /datum/inventory_slot/hand)
	if(. && !LAZYACCESS(held_item_slots, slot))
		LAZYSET(held_item_slots, slot, .)
		if(!get_active_hand())
			select_held_item_slot(slot)

/mob/living/proc/remove_inventory_slot(var/slot)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(inventory_slots, slot)
	if(!inv_slot)
		return
	if(inv_slot.holding)
		drop_from_inventory(inv_slot.holding)
	inventory_slots -= slot
	hud_used?.rebuild_equipment_slots(FALSE, list(slot))
	if(LAZYACCESS(held_item_slots, slot))
		held_item_slots -= slot
		if(get_active_held_item_slot() == slot && length(held_item_slots))
			select_held_item_slot(held_item_slots[1])
	qdel(inv_slot)

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
	. = inv_slot?.holding

/mob/living/get_active_held_item_slot()
	. = held_item_slot_selected

/mob/living/get_inactive_held_items()
	for(var/bp in (held_item_slots - get_active_held_item_slot()))
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		if(inv_slot?.holding)
			LAZYADD(., inv_slot.holding)

/mob/living/is_holding_offhand(var/thing)
	. = (thing in get_inactive_held_items())

/mob/living/swap_hand()
	. = ..()
	select_held_item_slot(next_in_list(get_active_held_item_slot(), held_item_slots))

/mob/living/get_empty_hand_slot()
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		if(inv_slot && !inv_slot.holding)
			return bp

/mob/living/get_empty_hand_slots()
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		if(inv_slot && !inv_slot.holding)
			LAZYADD(., bp)

/mob/living/get_equipped_item(var/slot)
	. = ..()
	if(!.)
		var/datum/inventory_slot/inv_slot = LAZYACCESS(inventory_slots, slot)
		. = inv_slot?.holding

/mob/living/drop_from_hand(var/slot, var/atom/Target)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(inventory_slots, slot)
	if(inv_slot?.holding)
		return drop_from_inventory(inv_slot.holding, Target)
	. = ..()

/mob/living/u_equip(obj/W)
	. = ..()
	if(!.)
		for(var/bp in inventory_slots)
			var/datum/inventory_slot/inv_slot = inventory_slots[bp]
			if(inv_slot?.holding == W)
				inv_slot.holding = null
				inv_slot.handle_post_unequip(src, W)
				return TRUE

/mob/living/get_inventory_slot(var/slot)
	. = LAZYACCESS(inventory_slots, slot)

/mob/living/get_inventory_slot_for_item(obj/item/I)
	for(var/bp in inventory_slots)
		var/datum/inventory_slot/inv_slot = inventory_slots[bp]
		if(inv_slot?.holding == I)
			return bp
