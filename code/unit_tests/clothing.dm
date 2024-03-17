/datum/unit_test/gear_rig_validation_test
	name = "GEAR: All Rigs Shall Have Non-Null Component Types"

/datum/unit_test/gear_rig_validation_test/start_test()
	var/list/results = list()
	for(var/rigtype in subtypesof(/obj/item/rig))
		var/res = ""
		var/obj/item/rig/rig = new rigtype
		if(initial(rig.gloves) == null)
			res = "[res] - null initial gloves"
		if(initial(rig.chest) == null)
			res = "[res] - null initial chest"
		if(initial(rig.helmet) == null)
			res = "[res] - null initial helmet"
		if(initial(rig.boots) == null)
			res = "[res] - null initial boots"
		if(res)
			results += "[rigtype] - [res]"
	if(length(results))
		fail("Some rig components were null:\n[jointext(results, "\n")].")
	else
		pass("No invalid rigs.")
	return TRUE

/datum/unit_test/gear_clothing_icon_state_test
	name = "GEAR: All Clothing Shall Have Valid Icons"

/datum/unit_test/gear_clothing_icon_state_test/start_test()

	var/list/check_types = subtypesof(/obj/item/clothing)
	var/list/detailed_check_types = list(
		/obj/item/clothing/suit,
		/obj/item/clothing/accessory,
		/obj/item/clothing/under
	)
	var/list/skip_detailed_check_types = list()
	var/list/onmob_exception_list = list(
		/obj/item/clothing/accessory/buddytag,
		/obj/item/clothing/accessory/armor/plate,
		/obj/item/clothing/accessory/armor/tag/oneg,
		/obj/item/clothing/accessory/armor/tag/opos,
		/obj/item/clothing/accessory/armor/tag/apos,
		/obj/item/clothing/accessory/armor/tag/aneg,
		/obj/item/clothing/accessory/armor/tag/bpos,
		/obj/item/clothing/accessory/armor/tag/bneg,
		/obj/item/clothing/accessory/armor/tag/abpos,
		/obj/item/clothing/accessory/armor/tag/abneg
	)
	for(var/checktype in onmob_exception_list)
		onmob_exception_list |= typesof(checktype)

	var/list/failures = list()
	for(var/clothing_type in check_types)

		var/obj/item/clothing/clothes = clothing_type
		if(TYPE_IS_ABSTRACT(clothes))
			continue

		var/initial_state       = initial(clothes.icon_state)
		var/initial_item_state  = initial(clothes.item_state)
		var/initial_icon        = initial(clothes.icon)

		var/list/clothing_fails = list()

		// Initial checks that do not require an instance.
		if(!initial_icon)
			clothing_fails += "missing initial icon"
		if(!initial_state)
			clothing_fails += "no initial state"
		else if(initial_state != ICON_STATE_WORLD && initial_state != ICON_STATE_INV)
			clothing_fails += "unconverted initial state '[initial_state]'"
		else if(initial_icon && !check_state_in_icon(initial_state, initial_icon))
			clothing_fails += "missing initial state '[initial_state]' in initial icon '[initial_icon]'"
		if(initial_item_state)
			clothing_fails += "legacy item state set '[initial_item_state]'"

		var/do_detailed_check = FALSE
		for(var/detailed_check_type in detailed_check_types)
			if(ispath(clothes, detailed_check_type))
				do_detailed_check = TRUE
				break
		if(do_detailed_check)
			for(var/detailed_check_type in skip_detailed_check_types)
				if(ispath(clothes, detailed_check_type))
					do_detailed_check = FALSE
					break

		if(!do_detailed_check)
			if(length(clothing_fails))
				failures += "[clothing_type]:\n- [jointext(clothing_fails, "\n- ")]"
			continue

		// We don't currently validate clothes specifically for nonhumans.
		// TODO: make this a loop over all relevant bodytype categories instead.
		var/check_flags = initial(clothes.bodytype_equip_flags)
		if(!(check_flags & BODY_FLAG_HUMANOID) || ((check_flags & BODY_FLAG_EXCLUDE) && (check_flags & BODY_FLAG_HUMANOID)))
			if(length(clothing_fails))
				failures += "[clothing_type]:\n- [jointext(clothing_fails, "\n- ")]"
			continue

		clothes = new clothes

		// Check if the clothing has all expected states.
		var/decl/species/default_species = get_species_by_key(global.using_map.default_species)
		var/decl/bodytype/default_bodytype = default_species.default_bodytype
		var/state_base = default_bodytype.bodytype_category

		var/list/check_slots = list()
		for(var/inv_slot_type in subtypesof(/datum/inventory_slot))
			var/datum/inventory_slot/slot_ref = inv_slot_type
			var/req_slot_flags = initial(slot_ref.requires_slot_flags)
			if(!isnull(req_slot_flags) && (req_slot_flags & clothes.slot_flags))
				var/slot_id = initial(slot_ref.slot_id)
				if(!isnull(slot_id))
					check_slots |= slot_id

		for(var/slot in check_slots)
			var/check_state = "[state_base]-[slot]"
			if(!check_state_in_icon(check_state, clothes.icon))
				clothing_fails += "missing onmob state '[check_state]' in '[clothes.icon]'"

		// I wish we could initial() lists/procs.
		if(!length(clothes.get_available_clothing_state_modifiers()))
			QDEL_NULL(clothes)
			if(length(clothing_fails))
				failures += "[clothing_type]:\n- [jointext(clothing_fails, "\n- ")]"
			continue

		var/list/all_tokens = list()
		for(var/decl/clothing_state_modifier/modifier in clothes.get_available_clothing_state_modifiers())
			if(!modifier.applies_icon_state_modifier)
				continue
			all_tokens += modifier.icon_state_modifier

		// Generate an ordered non-overlapping set of possible icon state combinations.
		var/list/generated_tokens = all_tokens.Copy()
		for(var/token in all_tokens)
			for(var/gen_token in generated_tokens)
				var/skip_gen = FALSE
				for(var/check_index = all_tokens.Find(token) to length(all_tokens))
					if(findtext(gen_token, all_tokens[check_index]))
						skip_gen = TRUE
						break
				if(skip_gen)
					continue
				generated_tokens += "[gen_token][token]"

		// Keep track of which states we've looked for or otherwise evaluated for later state checking.
		var/list/check_states = icon_states(clothes.icon)

		// Validate against the list of generated tokens.
		for(var/gen_token in generated_tokens)

			if(ICON_STATE_WORLD in check_states)
				var/check_state = "[ICON_STATE_WORLD][gen_token]"
				if(!(check_state in check_states))
					clothing_fails += "missing world state '[check_state]' in '[clothes.icon]'"

			if(ICON_STATE_INV in check_states)
				var/check_state = "[ICON_STATE_INV][gen_token]"
				if(!(check_state in check_states))
					clothing_fails += "missing inventory state '[check_state]' in '[clothes.icon]'"

			for(var/slot in check_slots)
				var/check_state = "[state_base]-[slot][gen_token]"
				if(!(slot in global.all_hand_slots) && !(check_state in check_states))
					clothing_fails += "missing onmob state '[check_state]' in '[clothes.icon]'"

			// Prune expected states from the file.
			for(var/related_state in check_states)
				if(findtext(related_state, gen_token))
					check_states -= related_state

		// Now we check for unrelated or invalid modifier states remaining.
		var/list/extraneous_states = list()
		var/list/all_modifiers = decls_repository.get_decls_of_subtype(/decl/clothing_state_modifier)
		for(var/modifier_type in all_modifiers)
			var/decl/clothing_state_modifier/modifier = all_modifiers[modifier_type]
			if(modifier.applies_icon_state_modifier)
				for(var/check_state in check_states)
					if(findtext(check_state, modifier.icon_state_modifier))
						extraneous_states |= check_state

		for(var/extraneous_state in extraneous_states)
			clothing_fails += "extraneous onmob state '[extraneous_state]' in '[clothes.icon]'"

		QDEL_NULL(clothes)
		if(length(clothing_fails))
			failures += "[clothing_type]:\n- [jointext(clothing_fails, "\n- ")]"

	if(length(failures))
		fail("Some clothing failed validation:\n[jointext(failures, "\n")]")
	else
		pass("All clothing passed validation paths.")
	return TRUE
