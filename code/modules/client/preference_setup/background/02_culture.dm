#define GET_ALLOWED_VALUES(write_to, check_key) \
	var/decl/species/S = get_species_by_key(pref.species); \
	if(!S) { \
		write_to = list(); \
	} else if(S.force_cultural_info[check_key]) { \
		write_to = list(S.force_cultural_info[check_key] = TRUE); \
	} else { \
		write_to = list(); \
		for(var/cul in S.available_cultural_info[check_key]) { \
			write_to[cul] = TRUE; \
		} \
	}

/datum/preferences
	var/list/cultural_info = list()

/datum/category_item/player_setup_item/background/culture
	name = "Culture"
	sort_order = 2
	var/list/hidden

/datum/category_item/player_setup_item/background/culture/New()
	hidden = list()
	for(var/token in ALL_CULTURAL_TAGS)
		hidden[token] = TRUE
	..()

/datum/category_item/player_setup_item/background/culture/sanitize_character()

	if(!islist(pref.cultural_info))
		pref.cultural_info = list()

	// Map any non-path tokens (ie. data that has been loaded from a file) to decls.
	var/list/all_cultural_decls = decls_repository.get_decls_of_subtype(/decl/cultural_info)
	for(var/token in ALL_CULTURAL_TAGS)
		var/entry = pref.cultural_info[token]
		if(!entry || ispath(entry, /decl/cultural_info))
			continue
		entry = lowertext(entry)
		pref.cultural_info -= token
		for(var/ftype in all_cultural_decls)
			var/decl/cultural_info/culture = all_cultural_decls[ftype]
			if(lowertext(culture.name) == entry)
				pref.cultural_info[token] = culture.type
				break

	// Sanitize and initialize our culture lists, taking data from our map
	// or other defaults if we haven't got anything loaded for the various tokens.
	for(var/token in ALL_CULTURAL_TAGS)
		var/list/_cultures
		GET_ALLOWED_VALUES(_cultures, token)
		if(!LAZYLEN(_cultures))
			pref.cultural_info[token] = global.using_map.default_cultural_info[token]
		else
			var/current_value = pref.cultural_info[token]
			if(!current_value || !_cultures[current_value])
				pref.cultural_info[token] = _cultures[1]

	// We handle name sanitizing here because otherwise we would not be able to retrieve the culture data.
	// This is a bit noodly. If pref.cultural_info[TAG_CULTURE] is null, then we haven't finished loading/sanitizing, which means we might purge
	// numbers or w/e from someone's name by comparing them to the map default. So we just don't bother sanitizing at this point otherwise.
	if(pref.cultural_info[TAG_CULTURE])
		var/decl/cultural_info/check = GET_DECL(pref.cultural_info[TAG_CULTURE])
		if(check)
			pref.real_name = check.sanitize_cultural_name(pref.real_name, pref.species)
			if(!pref.real_name)
				pref.real_name = check.get_random_name(get_mannequin(pref.client?.ckey), pref.gender)

/datum/category_item/player_setup_item/background/culture/load_character(datum/pref_record_reader/R)
	for(var/token in ALL_CULTURAL_TAGS)
		pref.cultural_info[token] = R.read(token)

/datum/category_item/player_setup_item/background/culture/save_character(datum/pref_record_writer/W)
	for(var/token in ALL_CULTURAL_TAGS)
		var/entry = pref.cultural_info[token]
		if(entry)
			if(ispath(entry, /decl/cultural_info))
				var/decl/cultural_info/culture = GET_DECL(entry)
				entry = culture.name
		W.write(token, entry)

/datum/category_item/player_setup_item/background/culture/content()
	. = list()
	for(var/token in ALL_CULTURAL_TAGS)

		var/decl/cultural_info/culture = GET_DECL(pref.cultural_info[token])

		. += "<table width = '100%'>"
		. += "<tr><td colspan=3><center><h3>[culture.desc_type]</h3>"
		var/list/valid_values
		GET_ALLOWED_VALUES(valid_values, token)
		. += "</center></td></tr>"
		. += "<tr><td colspan=3><center>"
		for(var/culture_path in valid_values)
			var/decl/cultural_info/culture_data = GET_DECL(culture_path)
			if(pref.cultural_info[token] == culture_data.type)
				. += "<span class='linkOn'>[culture_data.name]</span> "
			else
				. += "<a href='byond://?src=\ref[src];set_token_entry_[token]=\ref[culture_data]'>[culture_data.name]</a> "
		. += "</center><hr/></td></tr>"

		var/list/culture_info = culture.get_description(!hidden[token])
		. += "<tr><td width = '200px'>"
		. += "<small>[culture_info["details"] || "No additional details."]</small>"
		. += "</td><td>"
		. += "[culture_info["body"] || "No description."]"
		. += "</td><td width = '50px'>"
		. += "<a href='byond://?src=\ref[src];toggle_verbose_[token]=1'>[hidden[token] ? "Expand" : "Collapse"]</a>"
		. += "</td></tr>"
		. += "</table><hr>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/background/culture/OnTopic(var/href,var/list/href_list, var/mob/user)

	for(var/token in ALL_CULTURAL_TAGS)

		if(href_list["toggle_verbose_[token]"])
			hidden[token] = !hidden[token]
			return TOPIC_REFRESH

		var/decl/cultural_info/new_token = href_list["set_token_entry_[token]"]
		if(!isnull(new_token))
			new_token = locate(new_token)
			if(istype(new_token))
				pref.cultural_info[token] = new_token.type
				return TOPIC_REFRESH

	. = ..()

#undef GET_ALLOWED_VALUES
