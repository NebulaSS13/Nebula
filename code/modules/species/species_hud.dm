/datum/hud_data
	/// Checked by mob_can_equip().
	var/list/equip_slots = list()
	/// Built in New(), used for unhidable inv updates
	var/list/persistent_slots = list()
	/// Built in New(), used for hidable inv updates
	var/list/hidden_slots = list()

	var/list/inventory_slots = list(
		/datum/inventory_slot/handcuffs,
		/datum/inventory_slot/uniform,
		/datum/inventory_slot/suit,
		/datum/inventory_slot/mask,
		/datum/inventory_slot/gloves,
		/datum/inventory_slot/glasses,
		/datum/inventory_slot/ear,
		/datum/inventory_slot/ear/right,
		/datum/inventory_slot/head,
		/datum/inventory_slot/shoes,
		/datum/inventory_slot/suit_storage,
		/datum/inventory_slot/back,
		/datum/inventory_slot/id,
		/datum/inventory_slot/pocket,
		/datum/inventory_slot/pocket/right,
		/datum/inventory_slot/belt
	)

/datum/hud_data/New()
	..()
	for(var/slot_type in inventory_slots)
		var/datum/inventory_slot/inv_slot = new slot_type
		inventory_slots -= slot_type
		var/slot_id = inv_slot.slot_id
		inventory_slots[slot_id] = inv_slot
		equip_slots |= slot_id
		// Build reference lists for inventory updates
		if(inv_slot.can_be_hidden)
			hidden_slots |= slot_id
		else
			persistent_slots |= slot_id
	equip_slots |= slot_handcuffed_str
	if(slot_back_str in equip_slots)
		equip_slots |= slot_in_backpack_str

/datum/hud_data/monkey
	inventory_slots = list(
		/datum/inventory_slot/handcuffs,
		/datum/inventory_slot/uniform,
		/datum/inventory_slot/pocket,
		/datum/inventory_slot/pocket/right,
		/datum/inventory_slot/ear/monkey,
		/datum/inventory_slot/ear/right/monkey,
		/datum/inventory_slot/id,
		/datum/inventory_slot/head,
		/datum/inventory_slot/mask/monkey,
		/datum/inventory_slot/shoes,
		/datum/inventory_slot/back/monkey
	)

/datum/inventory_slot/ear/monkey
	ui_loc = ui_gloves
/datum/inventory_slot/ear/right/monkey
	ui_loc = ui_l_ear
/datum/inventory_slot/mask/monkey
	ui_loc = ui_oclothing
/datum/inventory_slot/back/monkey
	ui_loc = ui_sstore1
