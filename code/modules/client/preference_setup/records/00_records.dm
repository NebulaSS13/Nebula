/datum/preferences
	var/list/records = list()

/datum/category_item/player_setup_item/records
	var/record_key

/datum/category_item/player_setup_item/records/content(var/mob/user)
	. = list()
	if(record_key)
		. += "<br/><b>[name]</b>:<br/>"
		if(jobban_isbanned(user, "Records") || jobban_isbanned(user, name))
			. += "<span class='danger'>You are banned from modifying your [lowertext(name)].</span><br>"
		else
			. += "<a href='byond://?src=\ref[src];set_record=1'>[TextPreview(pref.records[record_key], 40)]</a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/records/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (record_key && href_list["set_record"])
		var/new_record = sanitize(input(user,"Enter new [lowertext(name)] here.", CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.records[record_key])) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_record) && !jobban_isbanned(user, "Records") && !jobban_isbanned(user, name) && CanUseTopic(user))
			pref.records[record_key] = new_record
		return TOPIC_REFRESH

/datum/category_item/player_setup_item/records/load_character(var/datum/pref_record_reader/R)
	if(record_key)
		pref.records[record_key] = R.read(record_key)

/datum/category_item/player_setup_item/records/save_character(var/datum/pref_record_writer/P)
	if(record_key)
		P.write(record_key, pref.records[record_key])
