/datum/preferences
	var/list/alternate_languages

/datum/category_item/player_setup_item/background/languages
	name = "Languages"
	sort_order = 3
	var/list/allowed_languages
	var/list/free_languages

/datum/category_item/player_setup_item/background/languages/load_character(datum/pref_record_reader/R)
	pref.alternate_languages = list()
	var/list/language_names = R.read("language")
	for(var/lang in language_names)
		var/decl/language/lang_decl = SSlore.get_language_by_name(lang)
		if(istype(lang_decl))
			pref.alternate_languages |= lang_decl.type

/datum/category_item/player_setup_item/background/languages/save_character(datum/pref_record_writer/W)
	var/list/language_names = list()
	for(var/lang in pref.alternate_languages)
		var/decl/language/lang_decl = GET_DECL(lang)
		if(istype(lang_decl))
			language_names |= lang_decl.name
	W.write("language", language_names)

/datum/category_item/player_setup_item/background/languages/sanitize_character()
	if(!islist(pref.alternate_languages))
		pref.alternate_languages = list()
	sanitize_alt_languages()

/datum/category_item/player_setup_item/background/languages/content()
	. = list()
	. += "<tr><td colspan=3><center><h3>Languages</h3></td></tr>"
	. += "<hr>"
	. += "<table width = '100%'>"
	. += jointext(get_language_text(), null)
	. += "</table></center><hr>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/languages/OnTopic(var/href,var/list/href_list, var/mob/user)

	if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		if(length(pref.alternate_languages) >= index)
			pref.alternate_languages.Cut(index, index+1)
		return TOPIC_REFRESH

	if(href_list["add_language"])

		if(length(pref.alternate_languages) >= get_config_value(/decl/config/num/max_alternate_languages))
			return TOPIC_REFRESH

		var/decl/language/lang = locate(href_list["add_language"])
		if(!istype(lang) || (lang.type in pref.alternate_languages))
			return TOPIC_REFRESH

		sanitize_alt_languages()
		if(lang.type in (allowed_languages - free_languages))
			pref.alternate_languages |= lang.type
			return TOPIC_REFRESH

		return TOPIC_NOACTION

	. = ..()

/datum/category_item/player_setup_item/background/languages/proc/rebuild_language_cache(var/mob/user)

	allowed_languages = list()
	free_languages = list()

	if(!user)
		return

	for(var/thing in pref.background_info)
		var/decl/background_detail/background = GET_DECL(pref.background_info[thing])
		if(istype(background))
			var/list/langs = background.get_spoken_languages()
			if(LAZYLEN(langs))
				for(var/checklang in langs)
					free_languages[checklang] =    TRUE
					allowed_languages[checklang] = TRUE
			if(LAZYLEN(background.secondary_langs))
				for(var/checklang in background.secondary_langs)
					allowed_languages[checklang] = TRUE

	var/list/language_types = decls_repository.get_decls_of_subtype(/decl/language)
	for(var/thing in language_types)
		var/decl/language/lang = language_types[thing]
		// Abstract, forbidden and restricted languages aren't supposed to be available to anyone in chargen.
		if(lang.flags & (LANG_FLAG_FORBIDDEN|LANG_FLAG_RESTRICTED))
			continue
		// Admin don't need to worry about whitelisted checks or background datums, give them everything.
		// Non-whitelisted languages should be handled by background datums.
		if(user.has_admin_rights() || ((lang.flags & LANG_FLAG_WHITELISTED) && is_alien_whitelisted(user, lang)))
			allowed_languages[thing] = TRUE

/datum/category_item/player_setup_item/background/languages/proc/is_allowed_language(var/mob/user, var/decl/language/lang)
	if(ispath(lang, /decl/language))
		lang = GET_DECL(lang)
	if(!istype(lang) || (lang.flags & LANG_FLAG_FORBIDDEN))
		return FALSE
	if(isnull(allowed_languages) || isnull(free_languages))
		rebuild_language_cache(user)
	if(!user || is_alien_whitelisted(user, lang))
		return TRUE
	return allowed_languages[lang.type]

/datum/category_item/player_setup_item/background/languages/proc/sanitize_alt_languages()
	if(!islist(pref.alternate_languages))
		pref.alternate_languages = list()
	var/preference_mob = preference_mob()
	rebuild_language_cache(preference_mob)
	for(var/L in pref.alternate_languages)
		var/decl/language/lang = GET_DECL(L)
		if(!lang || !is_allowed_language(preference_mob, lang))
			pref.alternate_languages -= L
	if(LAZYLEN(free_languages))
		for(var/lang in free_languages)
			pref.alternate_languages -= lang
			pref.alternate_languages.Insert(1, lang)

	pref.alternate_languages = uniquelist(pref.alternate_languages)
	var/max_languages = get_config_value(/decl/config/num/max_alternate_languages)
	if(length(pref.alternate_languages) > max_languages)
		pref.alternate_languages.Cut(max_languages + 1)

/datum/category_item/player_setup_item/background/languages/proc/get_language_text()

	sanitize_alt_languages()

	var/colspan
	if(LAZYLEN(pref.alternate_languages))
		colspan = " colspan = 2"
		for(var/i = 1 to length(pref.alternate_languages))
			LAZYADD(., "<tr>")
			var/lang = pref.alternate_languages[i]
			var/decl/language/lang_instance = GET_DECL(lang)
			if(free_languages[lang])
				LAZYADD(., "<td width = '200px'><b>[lang_instance.name] <i>(required)</i></b></td>")
			else
				LAZYADD(., "<td width = '200px'><b>[lang_instance.name] <a href='byond://?src=\ref[src];remove_language=[i]'>Remove</a></b></td>")
			LAZYADD(., "<td>[lang_instance.desc || "No information avaliable."]</td>")
			LAZYADD(., "</tr>")

	var/max_languages = get_config_value(/decl/config/num/max_alternate_languages)
	if(pref.alternate_languages.len < max_languages)

		var/remaining_langs = max_languages - pref.alternate_languages.len
		var/list/available_languages = list()
		for(var/lang in (allowed_languages - free_languages))
			if(!(lang in pref.alternate_languages))
				available_languages |= GET_DECL(lang)

		LAZYADD(., "<tr>")
		if(length(available_languages))
			colspan = " colspan = 2"
			var/list/language_links = list()
			var/i = 0
			for(var/decl/language/lang in available_languages)
				i++
				var/language_link = "<a href='byond://?src=\ref[src];add_language=\ref[lang]'>[lang.name]</a>"
				if(i == 5)
					i = 0
					language_link += "<br>"
				language_links += language_link
			LAZYADD(., "<td width = '200px'><b>Add language ([remaining_langs] remaining)</b></td>")
			LAZYADD(., "<td>[jointext(language_links, null)]</td>")
		else
			LAZYADD(., "<td[colspan]>There are no additional languages available to select.</td>")
		LAZYADD(., "</tr>")

	if(!LAZYLEN(.))
		LAZYADD(., "<tr><td[colspan]>Your current species or background does not allow you to choose additional languages.</td></tr>")

