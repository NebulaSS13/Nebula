/datum/preferences
	var/list/uplink_sources
	var/exploit_record = ""

/datum/category_item/player_setup_item/antagonism/basic
	name = "Setup"
	sort_order = 2

/datum/category_item/player_setup_item/antagonism/basic/load_character(datum/pref_record_reader/R)
	pref.exploit_record = R.read("exploit_record")

	var/list/uplink_order = R.read("uplink_sources")
	if(islist(uplink_order))
		pref.uplink_sources = list()
		for(var/entry_uid in uplink_order)
			var/decl/uplink_source/source = decls_repository.get_decl_by_id_or_var(entry_uid, /decl/uplink_source, nameof(/decl/uplink_source::name))
			if(source)
				pref.uplink_sources += source

/datum/category_item/player_setup_item/antagonism/basic/save_character(datum/pref_record_writer/writer)
	var/uplink_order = list()
	for(var/decl/uplink_source/uplink_source in pref.uplink_sources)
		uplink_order += uplink_source.uid

	writer.write("uplink_sources", uplink_order)
	writer.write("exploit_record", pref.exploit_record)

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	if(!istype(pref.uplink_sources))
		pref.uplink_sources = list()
		for(var/entry in global.default_uplink_source_priority)
			pref.uplink_sources += GET_DECL(entry)

/datum/category_item/player_setup_item/antagonism/basic/content(var/mob/user)
	. +="<b>Antag Setup:</b><br>"
	. +="Uplink Source Priority: <a href='byond://?src=\ref[src];add_source=1'>Add</a><br>"
	for(var/entry in pref.uplink_sources)
		var/decl/uplink_source/uplink = entry
		. +="[uplink.name] <a href='byond://?src=\ref[src];move_source_up=[uplink.uid]'>Move Up</a> <a href='byond://?src=\ref[src];move_source_down=[uplink.uid]'>Move Down</a> <a href='byond://?src=\ref[src];remove_source=[uplink.uid]'>Remove</a><br>"
		if(uplink.desc)
			. += "<font size=1>[uplink.desc]</font><br>"
	if(!length(pref.uplink_sources))
		. += "<span class='warning'>You will not receive an uplink unless you add an uplink source!</span>"
	. +="<br>"
	. +="Exploitable information:<br>"
	if(jobban_isbanned(user, "Records"))
		. += "<b>You are banned from using character records.</b><br>"
	else
		. +="<a href='byond://?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["add_source"])
		var/list/all_uplink_sources = decls_repository.get_decls_of_type_unassociated(/decl/uplink_source)
		var/source_selection = input(user, "Select Uplink Source to Add", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in (all_uplink_sources - pref.uplink_sources)
		if(source_selection && CanUseTopic(user))
			pref.uplink_sources |= source_selection
			return TOPIC_REFRESH

	if(href_list["remove_source"])
		var/decl/uplink_source/uplink = decls_repository.get_decl_by_id(href_list["remove_source"])
		if(uplink && pref.uplink_sources.Remove(uplink))
			return TOPIC_REFRESH

	if(href_list["move_source_up"])
		var/decl/uplink_source/uplink = decls_repository.get_decl_by_id(href_list["move_source_up"])
		if(!uplink)
			return TOPIC_NOACTION
		var/index = pref.uplink_sources.Find(uplink)
		if(index <= 1)
			return TOPIC_NOACTION
		pref.uplink_sources.Swap(index, index - 1)
		return TOPIC_REFRESH

	if(href_list["move_source_down"])
		var/decl/uplink_source/uplink = decls_repository.get_decl_by_id(href_list["move_source_down"])
		if(!uplink)
			return TOPIC_NOACTION
		var/index = pref.uplink_sources.Find(uplink)
		if(index >= length(pref.uplink_sources))
			return TOPIC_NOACTION
		pref.uplink_sources.Swap(index, index + 1)
		return TOPIC_REFRESH


	if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(input(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return TOPIC_REFRESH

	return ..()
