/proc/codex_sanitize(var/input)
	return lowertext(trim(strip_improper(input)))

/datum/codex_entry
	var/name
	var/store_codex_entry = TRUE
	var/list/associated_strings
	var/list/associated_paths
	var/lore_text
	var/mechanics_text
	var/antag_text
	var/disambiguator
	var/list/categories

/datum/codex_entry/temporary
	store_codex_entry = FALSE

/datum/codex_entry/New(var/_display_name, var/list/_associated_paths, var/list/_associated_strings, var/_lore_text, var/_mechanics_text, var/_antag_text)

	if(_display_name)       name =               _display_name
	if(_associated_paths)   associated_paths =   _associated_paths
	if(_associated_strings) associated_strings = _associated_strings
	if(_lore_text)          lore_text =          _lore_text
	if(_mechanics_text)     mechanics_text =     _mechanics_text
	if(_antag_text)         antag_text =         _antag_text

	if(store_codex_entry && length(associated_paths))
		for(var/tpath in associated_paths)
			var/atom/thing = tpath
			var/thing_name = codex_sanitize(initial(thing.name))
			if(disambiguator)
				thing_name = "[thing_name] ([disambiguator])"
			LAZYDISTINCTADD(associated_strings, thing_name)
		for(var/associated_path in associated_paths)
			if(SScodex.entries_by_path[associated_path])
				PRINT_STACK_TRACE("Trying to save codex entry for [name] by path [associated_path] but one already exists!")
			SScodex.entries_by_path[associated_path] = src

	if(!name)
		if(length(associated_strings))
			name = associated_strings[1]
		else
			CRASH("Attempted to instantiate unnamed codex entry with no associated strings!")

	if(store_codex_entry)
		SScodex.all_entries += src
		LAZYDISTINCTADD(associated_strings, codex_sanitize(name))
		for(var/associated_string in associated_strings)
			var/clean_string = codex_sanitize(associated_string)
			if(!clean_string)
				associated_strings -= associated_string
				continue
			if(clean_string != associated_string)
				associated_strings -= associated_string
				associated_strings |= clean_string
			if(SScodex.entries_by_string[clean_string])
				PRINT_STACK_TRACE("Trying to save codex entry for [name] by string [clean_string] but one already exists!")
			SScodex.entries_by_string[clean_string] = src

	..()

/datum/codex_entry/Destroy(force)
	if(store_codex_entry) // Gating here to avoid unnecessary list checking overhead.
		SScodex.all_entries -= src
		for(var/associated_string in associated_strings)
			SScodex.entries_by_string -= associated_string
		for(var/associated_path in associated_paths)
			SScodex.entries_by_path -= associated_path
		for(var/thing in SScodex.index_file)
			if(src == SScodex.index_file[thing])
				SScodex.index_file -= thing
		for(var/thing in SScodex.search_cache)
			var/list/cached = SScodex.search_cache[thing]
			if(src in cached)
				cached -= src
	. = ..()

/datum/codex_entry/proc/get_codex_header(var/mob/presenting_to)
	. = list()
	if(presenting_to)
		var/datum/codex_entry/linked_entry = SScodex.get_entry_by_string("nexus")
		. += "<a href='?src=\ref[SScodex];show_examined_info=\ref[linked_entry];show_to=\ref[presenting_to]'>Home</a>"
		if(presenting_to.client)
			. += "<a href='?src=\ref[presenting_to.client];codex_search=1'>Search Codex</a>"
			. += "<a href='?src=\ref[presenting_to.client];codex_index=1'>List All Entries</a>"
	. += "<hr><h2>[name]</h2>"

/datum/codex_entry/proc/get_codex_footer(var/mob/presenting_to)
	. = list()
	if(length(categories))
		for(var/decl/codex_category/category in categories)
			. += category.get_category_link(src)

// TODO: clean up codex bodies until trimming linebreaks is unnecessary.
#define TRIM_LINEBREAKS(TEXT) replacetext(replacetext(TEXT, SScodex.trailingLinebreakRegexStart, null), SScodex.trailingLinebreakRegexEnd, null)
/datum/codex_entry/proc/get_codex_body(var/mob/presenting_to, var/include_header = TRUE, var/include_footer = TRUE)

	. = list()
	if(include_header && presenting_to)
		var/header = get_codex_header(presenting_to)
		if(length(header))
			. += "<span class='dmCodexHeader'>"
			. += header
			. += "</span>"

	. += "<span class='dmCodexBody'>"
	if(lore_text)
		. += "<p><span class='codexLore'>[TRIM_LINEBREAKS(lore_text)]</span></p>"
	if(mechanics_text)
		. += "<h3>OOC Information</h3>\n<p><span class='codexMechanics'>[TRIM_LINEBREAKS(mechanics_text)]</span></p>"
	if(antag_text && (!presenting_to || (presenting_to.mind && player_is_antag(presenting_to.mind))))
		. += "<h3>Antagonist Information</h3>\n<p><span class='codexAntag'>[TRIM_LINEBREAKS(antag_text)]</span></p>"
	. += "</span>"

	if(include_footer)
		var/footer = get_codex_footer(presenting_to)
		if(length(footer))
			. += "<span class='dmCodexFooter'>"
			. += footer
			. += "</span>"
#undef TRIM_LINEBREAKS
