/datum/codex_entry/proc/get_dump_link_name()
	return name

/datum/codex_entry/codex/get_dump_link_name()
	return "index" // This is the central page of the website.

/decl/codex_page_converter
	var/write_location = "codex/"
	var/file_prefix
	var/file_suffix = ".html"
	var/style_loc = "common.css"
	var/sidebar
	var/static/list/illegal_filename_characters = list(
		"\\",
		"/",
		":",
		"*",
		"?",
		"\"",
		"<",
		">",
		"|",
		".",
		"\n",
		"\[",
		"]"
	)

/decl/codex_page_converter/proc/handle_additional_dump()
	var/full_style_loc = "[write_location][style_loc]"
	if(fexists(full_style_loc))
		fdel(full_style_loc)
	fcopy('html/browser/common.css', full_style_loc)

/decl/codex_page_converter/proc/insert_header(var/title, var/body)
	return "<head>\n<link rel='stylesheet' href='[style_loc]'/>\n<meta charset='UTF-8'/>\n<title>[get_config_value(/decl/config/text/server_name)] - [title]</title>\n</head>\n[body]"

/decl/codex_page_converter/proc/insert_footer(var/title, var/body)
	var/datum/codex_entry/entry = SScodex.get_entry_by_string(title)
	if(length(entry?.categories))
		body = "[body]\n<br>\n<p>This page is part of the following categories:"
		for(var/decl/codex_category/category in entry.categories)
			body = "[body] <a href='[convert_filename("[category.name] (category)")]'>[category.name]</a>"
		body = "[body]</p>"
	return body

// Strip out any invalid characters from the filename.
/decl/codex_page_converter/proc/convert_filename(var/filename)
	. = replacetext(lowertext(filename), " ", "_")
	for(var/char in illegal_filename_characters)
		. = replacetext(., char, "")
	. = "[file_prefix][.][file_suffix]"

/decl/codex_page_converter/proc/generate_sidebar()

	sidebar = list()
	sidebar += "<a href='index.html'>Main page</a>"

/*
TODO: work out how to implement an external search function.
	sidebar += "<hr/>"
	sidebar += "<form action='/url' method='GET'>"
	sidebar += "<input type='text' placeholder='Search the codex.'>"
	sidebar += "<button>Go!</button>"
	sidebar += "</form>"
*/

	sidebar += "<hr/>"
	sidebar += "<ul>"
	var/list/codex_categories = decls_repository.get_decls_of_subtype(/decl/codex_category)
	for(var/cat_type in codex_categories)
		var/decl/codex_category/cat = codex_categories[cat_type]
		var/datum/codex_entry/cat_entry = SScodex.get_entry_by_string("[cat.name] (category)")
		if(cat_entry)
			sidebar += "<li><a href='[convert_filename(cat_entry.get_dump_link_name())]'>[cat.name]</a></li>"
	sidebar += "</ul>"

	sidebar += "<hr/>"
	sidebar += "<ul>"
	var/githuburl = get_config_value(/decl/config/text/githuburl)
	if(githuburl)
		sidebar += "<li><a href='[githuburl]'>Github repository</a></li>"
	var/discordurl = get_config_value(/decl/config/text/discordurl)
	if(discordurl)
		sidebar += "<li><a href='[discordurl]'>Discord community</a></li>"
	sidebar += "</ul>"

	sidebar = jointext(sidebar, "\n")

/decl/codex_page_converter/proc/get_sidebar()
	if(!sidebar)
		generate_sidebar()
	return sidebar

// Strips out some extraneous <br> in the codex strings.
/decl/codex_page_converter/proc/convert_body(var/title, var/list/body)
	. = "<body>\n<div class = 'dumpCodexPage'>\n<div class = 'dumpCodexSidebar'>\n[get_sidebar()]\n</div>\n<div class = 'dumpCodexText'>\n<h1>[title]</h1>\n[jointext(body, "\n")]\n"
	. = replacetext(., "<p><br>",  "\n<p>")
	. = replacetext(., "<br><p>",  "\n<p>")
	. = replacetext(., "</p><br>", "</p>\n")
	. = replacetext(., "<br></p>", "</p>\n")
	. = insert_header(title, .)
	. = insert_footer(title, .)
	. = "<!DOCTYPE html>\n<html>\n[.]\n</div>\n</div>\n</body>\n</html>"

/decl/codex_page_converter/proc/strikethrough(var/thing)
	return "<font color = '#ff0000'><s>[thing]</s></font>"

/decl/codex_page_converter/proc/convert_link(var/address, var/thing)
	return "<a href='[url_encode(address)]'>[thing]</a>"

/datum/controller/subsystem/codex/proc/dump_to_filesystem(var/codex_page_converter = /decl/codex_page_converter)

	var/decl/codex_page_converter/convert = GET_DECL(codex_page_converter)

	// Build a reference list of filenames to datums so we can
	// crosslink them when generating the text body. Also collect
	// our body text in the process.
	var/list/address_to_body =  list()
	var/list/address_to_entry = list()
	var/list/entry_to_address = list()
	//var/list/seen_name_count =  list()
	for(var/datum/codex_entry/codex_entry as anything in all_entries)
		var/address = convert.convert_filename(codex_entry.get_dump_link_name())
		address_to_entry[address] = codex_entry
		entry_to_address[codex_entry] = address
		address_to_body[address] = convert.convert_body(codex_entry.name, codex_entry.get_codex_body(include_header = FALSE, include_footer = FALSE))

	// Copied from del_the_world UT exceptions list.
	var/static/list/skip_types = list(
		/obj/item/organ/external/chest,
		/obj/machinery/power/apc,
		/obj/machinery/alarm,
		/obj/structure/stairs
	)

	// Suspend to avoid fluid flows shoving stuff off the testing turf.
	SSfluids.suspend()

	// Also iterate the object tree for any generated on-examine codex pages.
	var/list/seen_name_count = list()
	for(var/atom_type in typesof(/obj/item, /obj/effect, /obj/structure, /obj/machinery, /obj/vehicle, /mob) - skip_types)
		var/atom/movable/atom = atom_type
		if(!TYPE_IS_SPAWNABLE(atom) || !initial(atom.simulated))
			continue
		try
			atom = atom_info_repository.get_instance_of(atom)
			if(!istype(atom)) // Something went wrong, possibly a runtime in the atom info repo.
				continue
			var/datum/codex_entry/codex_entry = atom.get_specific_codex_entry()
			if(istype(codex_entry))
				var/link_name = codex_entry.get_dump_link_name()
				if(ismob(atom))
					link_name = "[link_name] (mob)"
				else if(isobj(atom))
					link_name = "[link_name] (object)"
				else if(isturf(atom))
					link_name = "[link_name] (turf)"
				seen_name_count[link_name]++ // these are definitely not going to be unique based on name.
				var/address = convert.convert_filename("[link_name]_[seen_name_count[link_name]]")
				address_to_entry[address] = codex_entry
				entry_to_address[codex_entry] = address
				address_to_body[address] = convert.convert_body(codex_entry.name, codex_entry.get_codex_body(include_header = FALSE, include_footer = FALSE))
		catch(var/exception/E)
			PRINT_STACK_TRACE("Exception when performing codex dump for [atom_type]: [E]")

	// TODO: disambiguation pages - generate in DM, skip dump, iterate to create pages

	// Parse links and replace with hrefs to the filenames in address_to_entry
	// Boilerplate stolen from codex parse_links(), thanks Chinsky.
	var/regex_key
	var/replacement
	var/datum/codex_entry/linked_entry
	var/list/dumping_to_file = list()
	var/list/broken_links = list()
	for(var/entry_address in address_to_body)
		var/entry_body = address_to_body[entry_address]
		while(linkRegex.Find(entry_body))
			regex_key = linkRegex.group[4]
			if(linkRegex.group[2])
				regex_key = linkRegex.group[3]
			regex_key = lowertext(trim(regex_key))
			linked_entry = get_entry_by_string(regex_key)
			replacement = linkRegex.group[4]
			if(linked_entry && entry_to_address[linked_entry])
				replacement = convert.convert_link(entry_to_address[linked_entry], replacement)
			else
				broken_links |= "[replacement] ([regex_key])"
				replacement = convert.strikethrough(replacement)
			entry_body = replacetextEx(entry_body, linkRegex.match, replacement)
		dumping_to_file[entry_address] = entry_body

	// Print any broken links for debugging purposes.
	if(length(broken_links))
		log_error("Codex had [length(broken_links)] broken link\s:\n[jointext(broken_links, "\n")]")

	// Write the collected files out to the filesystem.
	for(var/entry_address in dumping_to_file)
		var/file_address = "[convert.write_location][entry_address]"
		if(fexists(file_address) && !fdel(file_address))
			log_error("Could not remove previous version of file at [file_address].")
			continue
		to_file(file(file_address), dumping_to_file[entry_address])

	// Handle any additional dump requirements (CSS, etc)
	convert.handle_additional_dump()

	return TRUE
