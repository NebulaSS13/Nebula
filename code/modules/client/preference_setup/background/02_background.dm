#define GET_ALLOWED_VALUES(write_to, check_key) \
	var/decl/species/S = get_species_by_key(pref.species); \
	if(!S) { \
		write_to = list(); \
	} else if(S.force_background_info[check_key]) { \
		write_to = list(S.force_background_info[check_key] = TRUE); \
	} else { \
		write_to = list(); \
		for(var/cul in S.available_background_info[check_key]) { \
			write_to[cul] = TRUE; \
		} \
	}

/datum/preferences
	var/list/background_info = list()

/datum/category_item/player_setup_item/background/details
	name = "Background Details"
	sort_order = 2
	var/list/hidden

/datum/category_item/player_setup_item/background/details/New()
	hidden = list()
	for(var/cat_type in global.using_map.get_background_categories())
		hidden[cat_type] = TRUE
	..()

/datum/category_item/player_setup_item/background/details/sanitize_character()

	if(!islist(pref.background_info))
		pref.background_info = list()

	// Prune any entries that do not fit the expected structure.
	for(var/background_cat_type in pref.background_info)
		var/decl/background_category/cat = GET_DECL(background_cat_type)
		if(!istype(cat))
			pref.background_info -= background_cat_type
			continue
		var/decl/background_detail/background = GET_DECL(pref.background_info[background_cat_type])
		if(!istype(background, cat.item_type))
			pref.background_info -= background
			continue

	// Sanitize and initialize our background lists, taking data from our map
	// or other defaults if we haven't got anything loaded for the various tokens.
	for(var/cat_type in global.using_map.get_background_categories())
		var/list/_backgrounds
		GET_ALLOWED_VALUES(_backgrounds, cat_type)
		if(LAZYLEN(_backgrounds))
			var/current_value = pref.background_info[cat_type]
			if(!current_value || !_backgrounds[current_value])
				pref.background_info[cat_type] = _backgrounds[1]
		else
			pref.background_info[cat_type] = global.using_map.default_background_info[cat_type]

	// We handle name sanitizing here because otherwise we would not be able to retrieve the background data.
	// This is a bit noodly. If pref.background_info has no entry for naming, then we haven't finished loading/sanitizing, which means we might purge
	// numbers or w/e from someone's name by comparing them to the map default. So we just don't bother sanitizing at this point otherwise.
	var/decl/background_detail/check = pref.get_background_datum_by_flag(BACKGROUND_FLAG_NAMING)
	if(istype(check))
		pref.real_name = check.sanitize_background_name(pref.real_name, pref.species)
		if(!pref.real_name)
			pref.real_name = check.get_random_name(get_mannequin(pref.client?.ckey), pref.gender)

// Load an associative list of background category type to a background type.
/datum/category_item/player_setup_item/background/details/load_character(datum/pref_record_reader/R)
	pref.background_info = list()
	var/list/all_background_categories = global.using_map.get_background_categories()
	for(var/cat_type in all_background_categories)
		var/decl/background_category/cat = all_background_categories[cat_type]
		var/load_value = R.read(cat.uid)
		if(!load_value && cat.old_tag)
			load_value = R.read(cat.old_tag)
		if(!load_value)
			continue
		var/decl/background_detail/background = decls_repository.get_decl_by_id_or_var(load_value, /decl/background_detail)
		if(istype(background))
			pref.background_info[cat.type] = background.type

/datum/category_item/player_setup_item/background/details/save_character(datum/pref_record_writer/W)
	for(var/background_cat_type in pref.background_info)
		var/decl/background_category/cat = GET_DECL(background_cat_type)
		var/decl/background_detail/entry = GET_DECL(pref.background_info[background_cat_type])
		if(istype(cat) && istype(entry))
			W.write(cat.uid, entry.uid)

/datum/category_item/player_setup_item/background/details/content()
	. = list()

	var/list/all_background_categories = global.using_map.get_background_categories()
	for(var/cat_type in all_background_categories)

		var/decl/background_category/cat = all_background_categories[cat_type]
		var/decl/background_detail/background = GET_DECL(pref.background_info[cat.type])

		. += "<table width = '100%'>"
		. += "<tr><td colspan=3><center><h3>[capitalize(cat.name)]</h3>"
		var/list/valid_values
		GET_ALLOWED_VALUES(valid_values, cat.type)
		. += "</center></td></tr>"
		. += "<tr><td colspan=3><center>"
		for(var/background_path in valid_values)
			var/decl/background_detail/check_background = GET_DECL(background_path)
			if(pref.background_info[cat.type] == background_path)
				. += "<span class='linkOn'>[check_background.name]</span> "
			else
				. += "<a href='byond://?src=\ref[src];set_token_entry_[cat.uid]=\ref[check_background]'>[check_background.name]</a> "
		. += "</center><hr/></td></tr>"

		var/list/background_strings = background.get_description(!hidden[cat.type])
		. += "<tr><td width = '200px'>"
		. += "<small>[background_strings["details"] || "No additional details."]</small>"
		. += "</td><td>"
		. += "[background_strings["body"] || "No description."]"
		. += "</td><td width = '50px'>"
		. += "<a href='byond://?src=\ref[src];toggle_verbose_[cat.uid]=1'>[hidden[cat.type] ? "Expand" : "Collapse"]</a>"
		. += "</td></tr>"
		. += "</table><hr>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/background/details/OnTopic(var/href,var/list/href_list, var/mob/user)

	var/list/all_background_categories = global.using_map.get_background_categories()
	for(var/cat_type in all_background_categories)
		var/decl/background_category/cat = all_background_categories[cat_type]

		if(href_list["toggle_verbose_[cat.uid]"])
			hidden[cat.type] = !hidden[cat.type]
			return TOPIC_REFRESH

		var/decl/background_detail/new_token = href_list["set_token_entry_[cat.uid]"]
		if(!isnull(new_token))
			new_token = locate(new_token)
			if(istype(new_token))
				pref.background_info[cat.type] = new_token.type
				return TOPIC_REFRESH

	. = ..()

#undef GET_ALLOWED_VALUES
