/datum/unit_test/cable_colors_shall_be_unique
	name = "UNIQUENESS: Cable Colors Shall Be Unique"

/datum/unit_test/cable_colors_shall_be_unique/start_test()
	var/list/names = list()
	var/list/colors = list()

	var/index = 0
	var/list/possible_cable_colours = get_global_cable_colors()
	for(var/color_name in possible_cable_colours)
		group_by(names, color_name, index)
		group_by(colors, possible_cable_colours[color_name], index)
		index++

	var/number_of_issues = number_of_issues(names, "Names")
	number_of_issues += number_of_issues(colors, "Colors")

	if(number_of_issues)
		fail("[number_of_issues] issues with cable colors found.")
	else
		pass("All cable colors are unique.")

	return 1

/datum/unit_test/player_preferences_shall_have_unique_key
	name = "UNIQUENESS: Player Preferences Shall Be Unique"

/datum/unit_test/player_preferences_shall_have_unique_key/start_test()
	var/list/preference_keys = list()

	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		group_by(preference_keys, client_pref.key, client_pref)

	var/number_of_issues = number_of_issues(preference_keys, "Keys")
	if(number_of_issues)
		fail("[number_of_issues] issues with player preferences found.")
	else
		pass("All player preferences have unique keys.")
	return 1

/datum/unit_test/access_datums_shall_be_unique
	name = "UNIQUENESS: Access Datums Shall Be Unique"

/datum/unit_test/access_datums_shall_be_unique/start_test()
	var/list/access_ids = list()
	var/list/access_descs = list()

	for(var/a in get_all_access_datums())
		var/datum/access/access = a
		group_by(access_ids, access.id, access)
		group_by(access_descs, access.desc, access)

	var/number_of_issues = number_of_issues(access_ids, "Ids")
	number_of_issues += number_of_issues(access_descs, "Descriptions")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with access datums found.")
	else
		pass("All access datums are unique.")
	return 1

/datum/unit_test/outfit_datums_shall_have_unique_names
	name = "UNIQUENESS: Outfit Datums Shall Have Unique Names"

/datum/unit_test/outfit_datums_shall_have_unique_names/start_test()
	var/list/outfits_by_name = list()

	for(var/decl/outfit/outfit in decls_repository.get_decls_of_subtype_unassociated(/decl/outfit))
		group_by(outfits_by_name, outfit.name, outfit.type)

	var/number_of_issues = number_of_issues(outfits_by_name, "Names")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with outfit datums found.")
	else
		pass("All outfit datums have unique names.")
	return 1

/datum/unit_test/languages_shall_have_unique_names
	name = "UNIQUENESS: Languages Shall Have Unique Names"

/datum/unit_test/languages_shall_have_unique_names/start_test()
	var/list/languages_by_name = list()

	for(var/lt in decls_repository.get_decl_paths_of_subtype(/decl/language))
		var/decl/language/l = lt
		group_by(languages_by_name, initial(l.name), lt)

	var/number_of_issues = number_of_issues(languages_by_name, "Language Names")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with language datums found.")
	else
		pass("All languages datums have unique names.")
	return 1

/datum/unit_test/languages_shall_have_no_or_unique_keys
	name = "UNIQUENESS: Languages Shall Have No or Unique Keys"

/datum/unit_test/languages_shall_have_no_or_unique_keys/start_test()
	var/list/languages_by_key = list()

	for(var/lt in decls_repository.get_decl_paths_of_subtype(/decl/language))
		var/decl/language/l = lt
		var/language_key = initial(l.key)
		if(!language_key)
			continue

		group_by(languages_by_key, language_key, lt)

	var/number_of_issues = number_of_issues(languages_by_key, "Language Keys")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with language datums found.")
	else
		pass("All languages datums have unique keys.")
	return 1

/datum/unit_test/outfit_backpacks_shall_have_unique_names
	name = "UNIQUENESS: Outfit Backpacks Shall Have Unique Names"

/datum/unit_test/outfit_backpacks_shall_have_unique_names/start_test()
	var/list/backpacks_by_name = list()

	var/bos = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
	for(var/bo in bos)
		var/decl/backpack_outfit/backpack_outfit = bos[bo]
		group_by(backpacks_by_name, backpack_outfit.name, backpack_outfit)

	var/number_of_issues = number_of_issues(backpacks_by_name, "Outfit Backpack Names")
	if(number_of_issues)
		fail("[number_of_issues] duplicate outfit backpacks\s found.")
	else
		pass("All outfit backpacks have unique names.")
	return 1

/datum/unit_test/space_suit_modifiers_shall_have_unique_names
	name = "UNIQUENESS: Space Suit Modifiers Shall Have Unique Names"

/datum/unit_test/space_suit_modifiers_shall_have_unique_names/start_test()
	var/list/space_suit_modifiers_by_name = list()

	var/sss = decls_repository.get_decls_of_subtype(/decl/item_modifier/space_suit)
	for(var/ss in sss)
		var/decl/item_modifier/space_suit/space_suit_modifier = sss[ss]
		group_by(space_suit_modifiers_by_name, space_suit_modifier.name, space_suit_modifier)

	var/number_of_issues = number_of_issues(space_suit_modifiers_by_name, "Space Suit Modifier Names")
	if(number_of_issues)
		fail("[number_of_issues] duplicate space suit modifier\s found.")
	else
		pass("All space suit modifiers have unique names.")
	return 1

/datum/unit_test/all_traits_shall_have_unique_name
	name = "UNIQUENESS: Traits Shall Have Unique Names"

/datum/unit_test/all_traits_shall_have_unique_name/start_test()
	var/list/trait_names = list()

	var/traits = decls_repository.get_decls_of_subtype(/decl/trait)
	for(var/trait_type as anything in traits)
		var/decl/trait/trait = traits[trait_type]
		group_by(trait_names, trait.name, trait.type)

	var/number_of_issues = number_of_issues(trait_names, "Names")
	if(number_of_issues)
		fail("[number_of_issues] duplicate trait name\s found")
	else
		pass("All traits have unique names")
	return TRUE

/datum/unit_test/decls_shall_have_no_or_unique_uids
	name = "UNIQUENESS: Decls Shall Have No or Unique UIDs"

/datum/unit_test/decls_shall_have_no_or_unique_uids/start_test()
	var/list/decls_by_uid = list()

	var/list/decls_by_type = decls_repository.get_decls_of_subtype(/decl)
	for(var/decl_type in decls_by_type)
		var/decl/decl_instance = decls_by_type[decl_type]
		var/uid = decl_instance.uid
		if(!uid) // mandatory UIDs are handled in /validate instead
			continue
		group_by(decls_by_uid, decl_instance.uid, decl_type)

	var/number_of_issues = number_of_issues(decls_by_uid, "Language UIDs")
	if(number_of_issues)
		fail("[number_of_issues] issue\s with decl UIDs found.")
	else
		pass("All decl UIDs are unique.")
	return TRUE

/datum/unit_test/material_gas_symbols_shall_be_unique
	name = "UNIQUENESS: Material Gas Symbols Shall Be Unique"

/datum/unit_test/material_gas_symbols_shall_be_unique/start_test()
	var/list/all_materials = decls_repository.get_decls_of_type(/decl/material)
	var/list/mat_gas_symbols = list()
	for(var/decl_type in all_materials)
		var/decl/material/mat = all_materials[decl_type]
		// Gas symbols are autogenerated if unset, so we just check uniqueness.
		group_by(mat_gas_symbols, mat.gas_symbol, decl_type)

	var/number_of_issues = number_of_issues(mat_gas_symbols, "Gas Symbols")

	if(number_of_issues)
		fail("[number_of_issues] issue\s with gas symbols found.")
	else
		pass("All gas symbols are unique.")
	return TRUE

/datum/unit_test/submaps_shall_have_a_unique_descriptor
	name = "UNIQUENESS: Archetypes shall have a valid, unique descriptor."

/datum/unit_test/submaps_shall_have_a_unique_descriptor/start_test()
	var/list/submaps_by_name = list()

	var/list/all_submaps = decls_repository.get_decls_of_subtype(/decl/submap_archetype)
	for(var/submap_type in all_submaps)
		var/decl/submap_archetype/submap = all_submaps[submap_type]
		if(submap.descriptor)
			group_by(submaps_by_name, submap.descriptor, submap_type)

	var/number_of_issues = number_of_issues(submaps_by_name, "Submap Archetype Descriptors")
	if(length(number_of_issues))
		fail("Found [number_of_issues] submap archetype\s with duplicate descriptors.")
	else
		pass("All submap archetypes have unique descriptors.")
	return 1


/datum/unit_test/proc/number_of_issues(var/list/entries, var/type, var/feedback = /decl/noi_feedback)
	var/issues = 0
	for(var/key in entries)
		var/list/values = entries[key]
		if(values.len > 1)
			var/decl/noi_feedback/noif = GET_DECL(feedback)
			noif.print(src, type, key, values)
			issues++

	return issues

/decl/noi_feedback/proc/priv_print(var/datum/unit_test/ut, var/type, var/key, var/output_text)
	ut.log_bad("[type] - [key] - The following entries have the same value: [output_text]")

/decl/noi_feedback/proc/print(var/datum/unit_test/ut, var/type, var/key, var/list/entries)
	priv_print(ut, type, key, english_list(entries))

/decl/noi_feedback/detailed/print(var/datum/unit_test/ut, var/type, var/key, var/list/entries)
	var/list/pretty_print = list()
	pretty_print += ""
	for(var/entry in entries)
		pretty_print += log_info_line(entry)
	priv_print(ut, type, key, jointext(pretty_print, "\n"))

/datum/unit_test/holopad_id_uniqueness
	name = "UNIQUENESS: Holopads Shall Have Unique Valid IDs"

/datum/unit_test/holopad_id_uniqueness/start_test()

	var/list/failures = list()

	var/list/seen_holopad_ids = list()
	for(var/obj/machinery/hologram/holopad/holopad in global.holopads)
		var/area/area = get_area(holopad)
		var/holopad_loc = "x[holopad.x],y[holopad.y],z[holopad.z] - [area?.proper_name || "Unknown"]"
		if(istext(holopad.holopad_id))
			LAZYDISTINCTADD(seen_holopad_ids[holopad.holopad_id], holopad_loc)
		else
			failures += "[holopad_loc] - null or non-text holopad_id ([isnull(holopad.holopad_id) ? "NULL" : holopad.holopad_id])"

	for(var/holopad_id in seen_holopad_ids)
		if(length(seen_holopad_ids[holopad_id]) > 1)
			failures += "overlapping holopad_id ([holopad_id]) - [jointext(seen_holopad_ids[holopad_id], ", ")]"

	if(length(failures))
		fail("Some holopads had overlapping or invalid ID values:\n[jointext(failures,"\n")]")
	else
		pass("All holopads had unique valid ID values.")
	return 1
