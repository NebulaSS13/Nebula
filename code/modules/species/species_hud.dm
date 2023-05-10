/datum/hud_data
	var/icon              // If set, overrides ui_style.
	var/has_a_intent = 1  // Set to draw intent box.
	var/has_m_intent = 1  // Set to draw move intent box.
	var/has_warnings = 1  // Set to draw environment warnings.
	var/has_pressure = 1  // Draw the pressure indicator.
	var/has_nutrition = 1 // Draw the nutrition indicator.
	var/has_bodytemp = 1  // Draw the bodytemp indicator.
	var/has_hands = 1     // Set to draw hands.
	var/has_drop = 1      // Set to draw drop button.
	var/has_throw = 1     // Set to draw throw button.
	var/has_resist = 1    // Set to draw resist button.
	var/has_internals = 1 // Set to draw the internals toggle button.
	var/has_up_hint = 1   // Set to draw the "look-up" hint icon
	var/list/equip_slots = list() // Checked by mob_can_equip().
	var/list/persistent_slots = list() // Built in New(), used for unhidable inv updates
	var/list/hidden_slots = list() // Built in New(), used for hidable inv updates

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
		if(slot_id in global.persistent_inventory_slots)
			persistent_slots |= slot_id
		else if(slot_id in global.hidden_inventory_slots)
			hidden_slots |= slot_id

	if(has_hands)
		equip_slots |= slot_handcuffed_str

	if(slot_back_str in equip_slots)
		equip_slots |= slot_in_backpack_str

	if(slot_w_uniform_str in equip_slots)
		equip_slots |= slot_tie_str

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
