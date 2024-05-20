SUBSYSTEM_DEF(codex)
	name = "Codex"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_CODEX

	var/regex/linkRegex
	var/regex/trailingLinebreakRegexStart
	var/regex/trailingLinebreakRegexEnd

	var/list/datum/codex_entry/all_entries =       list()
	var/list/datum/codex_entry/entries_by_path =   list()
	var/list/datum/codex_entry/entries_by_string = list()
	var/list/index_file =                          list()
	var/list/search_cache =                        list()

/datum/controller/subsystem/codex/Initialize()
	// Codex link syntax is such:
	// <l>keyword</l> when keyword is mentioned verbatim,
	// <span codexlink='keyword'>whatever</span> when shit gets tricky
	linkRegex = regex(@"<(span|l)(\s+codexlink='([^>]*)'|)>([^<]+)</(span|l)>","g")

	// used to remove trailing linebreaks when retrieving codex body.
	// TODO: clean up codex page generation so this isn't necessary.
	trailingLinebreakRegexStart = regex(@"^<\s*\/*\s*br\s*\/*\s*>", "igm")
	trailingLinebreakRegexEnd = regex(@"<\s*\/*\s*br\s*\/*\s*>$", "igm")

	// Create general hardcoded entries.
	for(var/ctype in subtypesof(/datum/codex_entry))
		var/datum/codex_entry/centry = ctype
		if(TYPE_IS_ABSTRACT(centry) || !initial(centry.store_codex_entry) || initial(centry.skip_hardcoded_generation))
			continue
		centry = new centry()

	// Create categorized entries.
	var/list/deferred_population = list()
	var/list/categories = decls_repository.get_decls_of_subtype(/decl/codex_category)
	for(var/ctype in categories)
		var/decl/codex_category/cat = categories[ctype]
		if(cat.defer_population)
			deferred_population += cat
			continue
		cat.Populate()

	for(var/decl/codex_category/cat as anything in deferred_population)
		cat.Populate()

	// Create the index file for later use.
	for(var/datum/codex_entry/entry as anything in all_entries)
		index_file[entry.name] = entry
	index_file = sortTim(index_file, /proc/cmp_text_asc)
	. = ..()

/datum/controller/subsystem/codex/proc/parse_links(string, viewer)
	while(linkRegex.Find(string))
		var/key = linkRegex.group[4]
		if(linkRegex.group[2])
			key = linkRegex.group[3]
		key = codex_sanitize(key)
		var/datum/codex_entry/linked_entry = get_entry_by_string(key)
		var/replacement = linkRegex.group[4]
		if(linked_entry)
			replacement = "<a href='byond://?src=\ref[SScodex];show_examined_info=\ref[linked_entry];show_to=\ref[viewer]'>[replacement]</a>"
		string = replacetextEx(string, linkRegex.match, replacement)
	return string

/datum/controller/subsystem/codex/proc/get_codex_entry(var/entry)
	if(istype(entry, /atom))
		var/atom/entity = entry
		var/specific_codex_entry = entity.get_specific_codex_entry()
		if(specific_codex_entry)
			return specific_codex_entry
		return get_entry_by_string(entity.name) || entries_by_path[entity.type]
	if(ispath(entry))
		return entries_by_path[entry]
	if(istext(entry))
		return entries_by_string[codex_sanitize(entry)]

/datum/controller/subsystem/codex/proc/get_entry_by_string(var/string)
	return entries_by_string[codex_sanitize(string)]

/datum/controller/subsystem/codex/proc/present_codex_entry(var/mob/presenting_to, var/datum/codex_entry/entry)
	if(entry && istype(presenting_to) && presenting_to.client)
		var/datum/browser/popup = new(presenting_to, "codex\ref[entry]", "Codex", nheight=425)
		popup.set_content(parse_links(jointext(entry.get_codex_body(presenting_to), null), presenting_to))
		popup.open()

/datum/controller/subsystem/codex/proc/get_manual_text(var/guide_id)
	if(ispath(guide_id, /decl/codex_category))
		var/decl/codex_category/cat = GET_DECL(guide_id)
		. = cat?.guide_html
	else if(guide_id)
		var/datum/codex_entry/entry
		if(ispath(guide_id, /datum/codex_entry))
			entry = guide_id
			guide_id = initial(entry.name)
		entry = get_codex_entry(guide_id)
		. = entry?.guide_html

/datum/controller/subsystem/codex/proc/retrieve_entries_for_string(var/searching)

	if(!initialized)
		return list()

	searching = codex_sanitize(searching)
	if(!searching)
		return list()
	if(!search_cache[searching])
		var/list/results
		if(entries_by_string[searching])
			results = list(entries_by_string[searching])
		else
			results = list()
			for(var/entry_title in entries_by_string)
				var/datum/codex_entry/entry = entries_by_string[entry_title]
				if(entry.unsearchable) // This entry can only be opened directly from links, and does not show up in search results.
					continue
				if(findtext(entry.name, searching) || findtext(entry.lore_text, searching) || findtext(entry.mechanics_text, searching) || findtext(entry.antag_text, searching))
					results |= entry
		search_cache[searching] = sortTim(results, /proc/cmp_name_asc)
	return search_cache[searching]

/datum/controller/subsystem/codex/Topic(href, href_list)
	. = ..()
	if(!. && href_list["show_examined_info"] && href_list["show_to"])
		var/mob/showing_mob =   locate(href_list["show_to"])
		if(!istype(showing_mob) || !showing_mob.can_use_codex())
			return
		var/atom/showing_atom = locate(href_list["show_examined_info"])
		var/entry
		if(istype(showing_atom, /datum/codex_entry))
			entry = showing_atom
		else if(istype(showing_atom))
			entry = get_codex_entry(showing_atom.get_codex_value())
		else
			entry = get_codex_entry(href_list["show_examined_info"])

		if(entry)
			present_codex_entry(showing_mob, entry)
			return TRUE
