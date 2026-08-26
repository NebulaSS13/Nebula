/datum/preferences
	var/list/prefix_keys_by_decl

/datum/category_item/player_setup_item/player_global/prefixes
	name = "Prefixes"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/prefixes/load_preferences(datum/pref_record_reader/R)
	var/list/prefix_keys_by_id = R.read("prefix_keys")

	if(istype(prefix_keys_by_id))
		pref.prefix_keys_by_decl = list()
		for(var/prefix_id in prefix_keys_by_id)
			var/decl/prefix/prefix_instance = decls_repository.get_decl_by_id_or_var(prefix_id, /decl/prefix, nameof(/decl/prefix::name))
			if(prefix_instance)
				pref.prefix_keys_by_decl[prefix_instance] = prefix_keys_by_id[prefix_id]

/datum/category_item/player_setup_item/player_global/prefixes/save_preferences(datum/pref_record_writer/writer)
	var/list/prefix_keys_by_id = list()
	for(var/decl/prefix/prefix_instance in pref.prefix_keys_by_decl)
		prefix_keys_by_id[prefix_instance.uid] = pref.prefix_keys_by_decl[prefix_instance]

	writer.write("prefix_keys", prefix_keys_by_id)

/datum/category_item/player_setup_item/player_global/prefixes/sanitize_preferences()
	if(!istype(pref.prefix_keys_by_decl))
		pref.prefix_keys_by_decl = list()

	// Setup the default keys for any prefix without one
	for(var/decl/prefix/prefix_instance in decls_repository.get_decls_of_type_unassociated(/decl/prefix))
		if(prefix_instance in pref.prefix_keys_by_decl)
			continue
		pref.prefix_keys_by_decl[prefix_instance] = prefix_instance.default_key

	// Then check for duplicate keys.
	// In case of overlap, all affected prefixes are given their default key
	reset_duplicate_keys()

/datum/category_item/player_setup_item/player_global/prefixes/content(var/mob/user)
	. += "<b>Prefix Keys:</b><br>"
	. += "<table>"
	for(var/decl/prefix/prefix_instance in decls_repository.get_decls_of_type_unassociated(/decl/prefix))
		var/current_prefix_key = pref.prefix_keys_by_decl[prefix_instance]

		. += "<tr><td>[prefix_instance.name]</td><td>[pref.prefix_keys_by_decl[prefix_instance]]</td><td>"

		if(prefix_instance.is_locked)
			. += "<span class='linkOff'>Change</span>"
		else

			. += "<a href='byond://?src=\ref[src];change_prefix=[prefix_instance.uid]'>Change</a>"

		. += "</td><td>"

		if(prefix_instance.is_locked || current_prefix_key == prefix_instance.default_key)
			. += "<span class='linkOff'>Reset</span>"
		else
			. += "<a href='byond://?src=\ref[src];reset_prefix=[prefix_instance.uid]'>Reset</a>"
		. += "</td></tr>"
	. += "</table>"

/datum/category_item/player_setup_item/player_global/prefixes/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["change_prefix"])
		var/decl/prefix/prefix_instance = decls_repository.get_decl_by_id(href_list["change_prefix"])
		if(!istype(prefix_instance) || prefix_instance.is_locked)
			return TOPIC_NOACTION

		do
			var/keys_in_use = list()
			for(var/decl/prefix/other_prefix_instance in pref.prefix_keys_by_decl)
				if(other_prefix_instance == prefix_instance)
					continue
				keys_in_use += pref.prefix_keys_by_decl[other_prefix_instance]

			var/new_key = input(user, "Enter a single special character. The following characters are already in use as prefixes: [jointext(keys_in_use, " ")]", CHARACTER_PREFERENCE_INPUT_TITLE, pref.prefix_keys_by_decl[prefix_instance]) as null|text
			if(!new_key || new_key == pref.prefix_keys_by_decl[prefix_instance] || !CanUseTopic(user))
				return TOPIC_NOACTION

			if(length(new_key) != 1)
				alert(user, "Only single characters are allowed.", "Error", "Ok")
			else if(contains_az09(new_key))
				alert(user, "Only special character are allowed.", "Error", "Ok")
			else if(new_key == " ")
				alert(user, "The space character is not allowed.", "Error", "Ok")
			else
				pref.prefix_keys_by_decl[prefix_instance] = new_key

				// Here we attempt to replace any conflicting prefix keys with their default value, to allow quick replacements
				for(var/decl/prefix/other_prefix_instance in pref.prefix_keys_by_decl)
					if(other_prefix_instance == prefix_instance)
						continue
					var/prefix_key = pref.prefix_keys_by_decl[other_prefix_instance]
					if(prefix_key == new_key)
						pref.prefix_keys_by_decl[other_prefix_instance] = other_prefix_instance.default_key
				// Then we reset any and all duplicates
				reset_duplicate_keys()
				// Then, if the new key was reset it means it matched a default key.
				// If so the user has to select another key, otherwise the selection was successful
				if(pref.prefix_keys_by_decl[prefix_instance] != new_key)
					alert(user, "The selected key is already the default key for another prefix.", "Error", "Ok")
				else
					return TOPIC_REFRESH
		while(TRUE)

	else if(href_list["reset_prefix"])
		var/decl/prefix/prefix_instance = decls_repository.get_decl_by_id(href_list["reset_prefix"])
		if(!istype(prefix_instance))
			return TOPIC_NOACTION
		pref.prefix_keys_by_decl[prefix_instance] = prefix_instance.default_key
		reset_duplicate_keys()
		return TOPIC_REFRESH

	else
		return ..()

/datum/category_item/player_setup_item/player_global/prefixes/proc/reset_duplicate_keys()
	var/list/prefixes_by_key = list()
	for(var/decl/prefix/prefix_instance in pref.prefix_keys_by_decl)
		var/prefix_key = pref.prefix_keys_by_decl[prefix_instance]
		group_by(prefixes_by_key, prefix_key, prefix_instance)

	for(var/prefix_key in prefixes_by_key)
		var/list/prefix_decls = prefixes_by_key[prefix_key]
		if(length(prefix_decls) > 1)
			for(var/decl/prefix/prefix_instance in prefix_decls)
				pref.prefix_keys_by_decl[prefix_instance] = prefix_instance.default_key

/mob/proc/get_prefix_key(var/decl/prefix/prefix_instance)
	prefix_instance = RESOLVE_TO_DECL(prefix_instance)
	return client?.prefs?.prefix_keys_by_decl[prefix_instance] || prefix_instance.default_key
