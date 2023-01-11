/mob/proc/get_visible_pronouns(hideflags)
	//suits/masks/helmets make it hard to tell their gender
	if((hideflags & HIDEJUMPSUIT) && (hideflags & HIDEFACE))
		return GET_DECL(/decl/pronouns)
	return get_pronouns()

/mob/proc/get_equipment_visibility()
	. = 0
	for(var/obj/item/thing in get_equipped_items(include_carried = FALSE))
		. |= thing.flags_inv
	return . & EQUIPMENT_VISIBILITY_FLAGS

/mob/proc/show_examined_short_description(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	to_chat(user, "[html_icon(src)] That's \a [src][infix]. [suffix]")
	to_chat(user, desc)

/datum/inventory_slot/proc/get_examined_string()
	return

/mob/proc/show_examined_worn_held_items(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)

	. = list()

	// This block currently does nothing due to inventory slots being unimplemented.
	// On full implementation it will replace the entire chunk of human inv code below.
	var/slot_datums = get_inventory_slots()
	if(length(slot_datums))
		for(var/slot in global.all_inventory_slots) // TODO: consider sorting inventory_slots instead of relying on this list order.
			var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(slot)
			var/slot_desc = inv_slot?.get_examined_string(src, user, distance, hideflags, pronouns)
			if(slot_desc)
				. += slot_desc

	/*
	 * Begin giant horrible lump of inventory text migrated down here from human/examine()
	 * Kill this entire chunk when inventory slots are properly implemented and the above
	 * block handles this properly.
	 */

	//uniform
	var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
	if(uniform && !(hideflags & HIDEJUMPSUIT))
		. += "[pronouns.He] [pronouns.is] wearing [uniform.get_examine_line()]."
	//head
	var/obj/item/head = get_equipped_item(slot_head_str)
	if(head)
		. += "[pronouns.He] [pronouns.is] wearing [head.get_examine_line()] on [pronouns.his] head."
	//suit/armour
	var/obj/item/suit = get_equipped_item(slot_wear_suit_str)
	if(suit)
		. += "[pronouns.He] [pronouns.is] wearing [suit.get_examine_line()]."
		//suit/armour storage
		if(!(hideflags & HIDESUITSTORAGE))
			var/obj/item/stored = get_equipped_item(slot_s_store_str)
			if(stored)
				. += "[pronouns.He] [pronouns.is] carrying [stored.get_examine_line()] on [pronouns.his] [suit.name]."
	//back
	var/obj/item/back = get_equipped_item(slot_back_str)
	if(back)
		. += "[pronouns.He] [pronouns.has] [back.get_examine_line()] on [pronouns.his] back."
	//held items
	var/list/held_slots = get_held_item_slots()
	for(var/hand_slot in held_slots)
		var/datum/inventory_slot/inv_slot = LAZYACCESS(held_slots, hand_slot)
		if(inv_slot?.holding)
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, hand_slot)
			if(E)
				. += "[pronouns.He] [pronouns.is] holding [inv_slot.holding.get_examine_line()] in [pronouns.his] [E.name]."
	//gloves
	var/obj/item/gloves = get_equipped_item(slot_gloves_str)
	if(gloves && !(hideflags & HIDEGLOVES))
		. += "[pronouns.He] [pronouns.has] [gloves.get_examine_line()] on [pronouns.his] hands."
	else
		var/datum/reagents/coating
		for(var/obj/item/organ/external/E in get_hands_organs())
			if(E.coating)
				coating = E.coating
				break
		if(coating)
			. += "There's <font color='[coating.get_color()]'>something on [pronouns.his] hands</font>!"
	//belt
	var/obj/item/belt = get_equipped_item(slot_belt_str)
	if(belt)
		. += "[pronouns.He] [pronouns.has] [belt.get_examine_line()] about [pronouns.his] waist."
	//shoes
	var/obj/item/shoes = get_equipped_item(slot_shoes_str)
	if(shoes && !(hideflags & HIDESHOES))
		. += "[pronouns.He] [pronouns.is] wearing [shoes.get_examine_line()] on [pronouns.his] feet."
	else
		var/datum/reagents/coating
		for(var/foot_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, foot_tag)
			if(E && E.coating)
				coating = E.coating
				break
		if(coating)
			. += "There's <font color='[coating.get_color()]'>something on [pronouns.his] feet</font>!"
	//mask
	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	if(mask && !(hideflags & HIDEMASK))
		. += "[pronouns.He] [pronouns.has] [mask.get_examine_line()] on [pronouns.his] face."
	//eyes
	if(!(hideflags & HIDEEYES))
		var/obj/item/glasses = get_equipped_item(slot_glasses_str)
		if(glasses)
			. += "[pronouns.He] [pronouns.has] [glasses.get_examine_line()] covering [pronouns.his] eyes."
	if(!(hideflags & HIDEEARS))
		var/obj/item/ear = get_equipped_item(slot_l_ear_str)
		if(ear)
			. += "[pronouns.He] [pronouns.has] [ear.get_examine_line()] on [pronouns.his] left ear."
		ear = get_equipped_item(slot_r_ear_str)
		if(ear)
			. += "[pronouns.He] [pronouns.has] [ear.get_examine_line()] on [pronouns.his] right ear."
	//ID
	var/obj/item/id = get_equipped_item(slot_wear_id_str)
	if(id)
		. += "[pronouns.He] [pronouns.is] wearing [id.get_examine_line()]."
	//handcuffs?
	var/obj/item/cuffs = get_equipped_item(slot_handcuffed_str)
	if(cuffs)
		. += "<span class='warning'>[pronouns.He] [pronouns.is] [html_icon(cuffs)] restrained with \the [cuffs]!</span>"
	/*
	 * End giant horrible block of human inventory shit.
	 */

	if(buckled)
		. += SPAN_WARNING("[pronouns.He] [pronouns.is] [html_icon(buckled)] buckled to [buckled]!")
	if(length(.))
		to_chat(user, jointext(., "\n"))

/mob/proc/show_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	return

/mob/examine(mob/user, distance, infix, suffix)

	SHOULD_CALL_PARENT(FALSE)
	. = TRUE

	// Collect equipment visibility flags.
	var/hideflags = get_equipment_visibility()
	//no accuately spotting headsets from across the room.
	if(distance > 3)
		hideflags |= HIDEEARS

	// Show our equipment, held items, desc, etc.
	var/decl/pronouns/pronouns = get_visible_pronouns(hideflags)
	to_chat(user, "<quote>")
	show_examined_short_description(user, distance, infix, suffix, hideflags, pronouns)
	show_examined_worn_held_items(user, distance, infix, suffix, hideflags, pronouns)
	show_other_examine_strings(user, distance, infix, suffix, hideflags, pronouns)
	to_chat(user, "</quote>")

	// Update our target dolly.
	if(user.zone_sel)
		var/decl/species/target_species = get_species()
		if(target_species && (BP_TAIL in target_species.has_limbs))
			user.zone_sel.icon_state = "zone_sel_tail"
		else
			user.zone_sel.icon_state = "zone_sel"
