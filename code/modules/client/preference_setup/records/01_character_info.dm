/datum/category_item/player_setup_item/records/character_info
	name = "Character Information"
	sort_order = 1
	record_key = null

/datum/category_item/player_setup_item/records/character_info/content(var/mob/user)

	var/comments_prep = pref.validate_comments_record()
	if(comments_prep)
		return "<br/>[comments_prep]<br/>"

	var/datum/character_information/comments = SScharacter_info.get_record(pref.comments_record_id, TRUE)
	. = list("<b>IC/OOC information preferences:</b><br/>")
	if(get_config_value(/decl/config/toggle/allow_character_comments))
		. += "<a href='byond://?src=\ref[src];toggle_comments=1'>[comments.allow_comments ? "Allowing and displaying comments." : "Not allowing or displaying comments."]</a><br/>"
	. += "<a href='byond://?src=\ref[src];toggle_examine_info=1'>[comments.show_info_on_examine ? "Showing IC and OOC info on examine." : "Not showing IC and OOC info on examine."]</a><br/>"

	var/is_banned = jobban_isbanned(user, "Records") || jobban_isbanned(user, name)
	. += "<br/><b>IC information:</b><br/>"
	if(is_banned)
		. += "<span class='danger'>You are banned from modifying your IC character information.</span><br>"
	else
		. += "<a href='byond://?src=\ref[src];set_ic_info=1'>[TextPreview(comments.ic_info, 40)]</a><br>"

	. += "<br/><b>OOC information:</b><br/>"
	if(is_banned)
		. += "<span class='danger'>You are banned from modifying your OOC character information.</span><br>"
	else
		. += "<a href='byond://?src=\ref[src];set_ooc_info=1'>[TextPreview(comments.ooc_info, 40)]</a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/records/character_info/OnTopic(var/href,var/list/href_list, var/mob/user)

	if (record_key && href_list["set_record"])
		var/new_record = sanitize(input(user,"Enter new [lowertext(name)] here.", CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.records[record_key])) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_record) && !jobban_isbanned(user, "Records") && !jobban_isbanned(user, name) && CanUseTopic(user))
			pref.records[record_key] = new_record
		return TOPIC_REFRESH

	var/datum/character_information/comments = pref.comments_record_id && SScharacter_info.get_record(pref.comments_record_id, TRUE)
	if(comments)

		if(get_config_value(/decl/config/toggle/allow_character_comments) && href_list["toggle_comments"])
			comments.allow_comments = !comments.allow_comments
			. = TOPIC_REFRESH

		if(href_list["toggle_examine_info"])
			comments.show_info_on_examine = !comments.show_info_on_examine
			. = TOPIC_REFRESH

		if(href_list["set_ic_info"])
			var/new_ic_info = input(user, "Enter your new IC info.", "Set IC Info", comments.ic_info) as null|message
			if(isnull(new_ic_info))
				return TOPIC_NOACTION
			comments.ic_info = sanitize(new_ic_info)
			. = TOPIC_REFRESH

		if(href_list["set_ooc_info"])
			var/new_ooc_info = input(user, "Enter your new OOC info.", "Set OOC Info", comments.ooc_info) as null|message
			if(isnull(new_ooc_info))
				return TOPIC_NOACTION
			comments.ooc_info = sanitize(new_ooc_info)
			. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH && istext(pref.comments_record_id) && length(pref.comments_record_id))
		SScharacter_info.queue_to_save(pref.comments_record_id)
