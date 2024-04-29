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
	var/list/failures = list()
	var/list/icon_states_checked = list()
	var/list/reported_failures = list()

	var/decl/species/default_species = get_species_by_key(SPECIES_HUMAN)
	var/decl/bodytype/default_bodytype = default_species.default_bodytype
	var/state_base = default_bodytype.bodytype_category

	for(var/clothing_type in check_types)

		var/obj/item/clothing/clothes = clothing_type
		if(TYPE_IS_ABSTRACT(clothes) || !initial(clothes.draw_on_mob_when_equipped))
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
			if(!(initial_state in reported_failures[initial_icon]))
				LAZYADD(reported_failures[initial_icon], initial_state)
				clothing_fails += "missing initial state '[initial_state]' in initial icon '[initial_icon]'"
		if(initial_item_state)
			clothing_fails += "legacy item state set '[initial_item_state]'"

		// Check for old accessory states.
		if(!(initial_icon in icon_states_checked))
			icon_state_cache += initial_icon
			for(var/state in icon_states(initial_icon))
				if(findtext(lowertext(state), "slot_tie") && !("slot_tie" in reported_failures[initial_icon]))
					LAZYADD(reported_failures[initial_icon], "slot_tie")
					clothing_fails += "legacy 'slot_tie' state defined in '[initial_icon]'"

		// We don't currently validate clothes specifically for nonhumans.
		// TODO: make this a loop over all relevant bodytype categories instead.
		var/check_flags = initial(clothes.bodytype_equip_flags)
		if((check_flags && !(check_flags & BODY_FLAG_HUMANOID)) || ((check_flags & BODY_FLAG_EXCLUDE) && (check_flags & BODY_FLAG_HUMANOID)))
			if(length(clothing_fails))
				failures += "[clothing_type]:\n- [jointext(clothing_fails, "\n- ")]"
			continue

		clothes = new clothes

		// Check if the clothing has a fallback icon slot and an icon for it.
		var/fallback_slot = clothes.get_fallback_slot()
		if(istext(fallback_slot))
			var/check_state = "[state_base]-[fallback_slot]"
			if(!(check_state in reported_failures[clothes.icon]) && !check_state_in_icon(check_state, clothes.icon))
				LAZYADD(reported_failures[clothes.icon], check_state)
				clothing_fails += "missing base onmob state '[check_state]' in '[clothes.icon]'"
			if(clothes.markings_state_modifier && clothes.markings_color)
				check_state = "[check_state][clothes.markings_state_modifier]"
				if(!(check_state in reported_failures[clothes.icon]) && !check_state_in_icon(check_state, clothes.icon))
					LAZYADD(reported_failures[clothes.icon], check_state)
					clothing_fails += "missing markings onmob state '[check_state]' in '[clothes.icon]'"
		else
			clothing_fails += "invalid fallback slot '[!isnull(fallback_slot) ? fallback_slot : "NULL"]'"

		// I wish we could initial() lists/procs.
		if(length(clothes.get_available_clothing_state_modifiers()))

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

			// God help unit test time if people start putting markings on flannel shirts.
			if(clothes.markings_state_modifier && clothes.markings_color)
				for(var/token in generated_tokens)
					generated_tokens += "[token][clothes.markings_state_modifier]"

			// Keep track of which states we've looked for or otherwise evaluated for later state checking.
			var/list/check_states = icon_states(clothes.icon)

			// Validate against the list of generated tokens.
			for(var/gen_token in generated_tokens)

			// This logic is currently not working (false negatives). Uncomment when fixed.
			/*
				if(ICON_STATE_WORLD in check_states)
					var/check_state = "[ICON_STATE_WORLD][gen_token]"
					if(!(check_state in reported_failures[clothes.icon]) && !(check_state in check_states))
						LAZYADD(reported_failures[clothes.icon], check_state)
						clothing_fails += "missing token world state '[check_state]' in '[clothes.icon]'"

				if(ICON_STATE_INV in check_states)
					var/check_state = "[ICON_STATE_INV][gen_token]"
					if(!(check_state in reported_failures[clothes.icon]) && !(check_state in check_states))
						LAZYADD(reported_failures[clothes.icon], check_state)
						clothing_fails += "missing token inventory state '[check_state]' in '[clothes.icon]'"

				if(fallback_slot)
					var/check_state = "[state_base]-[fallback_slot][gen_token]"
					if(!(check_state in reported_failures[clothes.icon]) && !(check_state in check_states))
						LAZYADD(reported_failures[clothes.icon], check_state)
						clothing_fails += "missing token onmob state '[check_state]' in '[clothes.icon]'"
			*/
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
				if(!(extraneous_state in reported_failures[clothes.icon]))
					LAZYADD(reported_failures[clothes.icon], extraneous_state)
					clothing_fails += "extraneous onmob state '[extraneous_state]' in '[clothes.icon]'"

		QDEL_NULL(clothes)
		if(length(clothing_fails))
			failures += "[clothing_type]:\n- [jointext(clothing_fails, "\n- ")]"

	if(length(failures))
		fail("Some clothing failed validation:\n[jointext(failures, "\n")]")
	else
		pass("All clothing passed validation paths.")
	return TRUE
