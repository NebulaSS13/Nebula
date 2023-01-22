/datum/codex_entry/codex
	name = "The Codex"
	lore_text = "The Codex is the overall body containing the document that you are currently reading. It is a distributed encyclopedia maintained by a dedicated, hard-working staff of journalists, bartenders, hobos, space pirates and xeno-intelligences, all with the goal of providing you, the user, with supposedly up-to-date, nominally useful documentation on the topics you want to know about. \
	<br><br> \
	Access to the Codex is afforded instantly by a variety of unobtrusive devices, including PDA attachments, retinal implants, neuro-memetic indoctrination and hover-drone. All our access devices are affordable, stylish and guaranteed not to expose you to encephalo-malware. \
	<br><br> \
	The Codex editorial offices are located in Venus orbit and will offer cash payments for stories, anecdotes and evidence of the strange and undocumented miscellany cluttering up our observable universe. Remember our motto: <i>\"Knowledge is power, sell your excess.\"</i>"

/datum/codex_entry/codex/New()
	mechanics_text = "The Codex is both an IC and OOC resource. ICly, it is as described; a space encyclopedia. You can use <b>Search-Codex <i>topic</i></b> to look something up, or you can click the links provided when examining some objects. \
	<br><br> \
	Any of the lore you find in the Codex, designated by <span class='codexLore'>green</span> text, can be freely referenced in-character. \
	<br><br> \
	OOC information on various mechanics and interactions is marked by <span class='codexMechanics'>blue</span> text. \
	<br><br> \
	Information for antagonists will not be shown unless you are an antagonist, and is marked by <span class='codexAntag'>red</span> text."
	..()

/datum/codex_entry/nexus
	name = "Nexus"
	mechanics_text = "The place to start with <span codexlink='the codex'>The Codex</span><br>"

/datum/codex_entry/nexus/get_codex_body(mob/presenting_to, include_header, include_footer)
	. = get_codex_header(presenting_to)
	. += "[mechanics_text]"
	. += "<h3>Categories</h3>"
	var/list/category_strings
	var/list/categories = decls_repository.get_decls_of_subtype(/decl/codex_category)
	for(var/ctype in categories)
		var/decl/codex_category/C = categories[ctype]
		if(!C?.name)
			continue
		var/key = "[initial(C.name)] (category)"
		var/datum/codex_entry/entry = SScodex.get_codex_entry(key)
		if(entry)
			LAZYADD(category_strings, "<li><span codexlink='[key]'>[initial(C.name)]</span> - [initial(C.desc)]")
	. += jointext(category_strings, " ")
	return "<span class = 'codexMechanics'>[jointext(., null)]</span>"

/client/proc/codex_topic(href, href_list)
	if(href_list["codex_search"]) //nano throwing errors
		search_codex()
		return TRUE

	if(href_list["codex_index"]) //nano throwing errors
		list_codex_entries()
		return TRUE