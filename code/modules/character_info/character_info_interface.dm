#define COMMENT_CANDYSTRIPE_ONE "#343434"
#define COMMENT_CANDYSTRIPE_TWO "#454545"

/client
	var/viewing_character_info_as
	var/show_comments_legend = FALSE

/client/New()
	..()
	if(get_config_value(/decl/config/toggle/allow_character_comments))
		verbs |= /client/proc/view_character_information
	else
		verbs -= /client/proc/view_character_information

/client/proc/view_character_information(var/search_for as text)

	set name = "View Character Information"
	set category = "OOC"
	set src = usr

	// Technically we might want to show IC/OOC but the primary meat
	// of the system is comments and I'm losing steam on the coding.
	if(!get_config_value(/decl/config/toggle/allow_character_comments))
		to_chat(usr, SPAN_WARNING("Character information viewing is currently not enabled."))
		verbs -= /client/proc/view_character_information
		return

	var/datum/character_information/comments
	if(!viewing_character_info_as)
		var/datum/character_information/my_comments = mob?.get_comments_record()
		viewing_character_info_as = my_comments?.record_id || prefs?.comments_record_id
	if(search_for)
		comments = SScharacter_info.search_records(search_for)
	else if(viewing_character_info_as)
		comments = SScharacter_info.get_record(viewing_character_info_as)
	else
		to_chat(usr, SPAN_WARNING("Please either supply a search string, or set up a character slot to view your own information."))
		return

	if(islist(comments))
		var/list/comment_list = comments
		if(length(comment_list) == 1)
			comments = comment_list[1]
		else
			comments = input(usr, "Multiple matches. Which character do you wish to show?", "View Character Comments") as null|anything in comment_list
	if(istype(comments))
		comments.display_to(usr)
	else
		to_chat(usr, SPAN_WARNING("There is no visible character information for that character."))

/datum/character_information/proc/display_to(var/mob/user)

	if(!user.client || !get_config_value(/decl/config/toggle/allow_character_comments))
		return

	if(ckey == user.ckey)
		has_new_comments = FALSE

	var/list/dat = list("<b>Viewing:</b> <a href='byond://?src=\ref[src];change_viewed=1'>[name]</a><br/>")
	var/datum/character_information/viewer = user.client.viewing_character_info_as && SScharacter_info.get_record(user.client.viewing_character_info_as, TRUE)
	dat += "<b>Viewing as:</b> <a href='byond://?src=\ref[src];change_viewer=1'>[viewer?.name || "Nobody"]</a><br/>"
	dat += "<center><h2>IC Info</h2></center>"
	dat += "<center>[ic_info || "None supplied."]</center><br/>"
	dat += "<center><h2>OOC Info</h2></center>"
	dat += "<center>[ooc_info || "None supplied."]</center><br/>"
	dat += "<center><h2>Comments</h2></center>"

	if(!allow_comments)
		dat += "<center>This character page is not currently accepting or displaying comments.</center>"
	else
		if(user.client?.show_comments_legend)
			dat += "<center><a href='byond://?src=\ref[src];show_legend=0'>Hide legend</a></center>"
			dat += get_comment_mood_legend()
		else
			dat += "<center><a href='byond://?src=\ref[src];show_legend=1'>Show legend</a></center>"
		dat += "<br/>"

		var/list/other_comments = list()
		var/datum/character_comment/my_comment
		for(var/datum/character_comment/comment in comments)
			if(viewer && comment.author_id == viewer.record_id)
				my_comment = comment
			else if(!comment.is_stale())
				other_comments += comment

		dat += "<center><h3>My Comment</h3></center>"
		dat += "<table width = 700px style=\"padding: 1px; display: flex; justify-content: center; align-items: center;\">"
		if(my_comment)
			dat += my_comment.get_comment_html(src, user, COMMENT_CANDYSTRIPE_ONE)
		else if(viewer)
			dat += "<tr><td width = 700px colspan = 3><center>You have not left a comment for this character. <a href='byond://?src=\ref[src];create_comment=1'>Leave one now?</a></center></td></tr>"
		else
			dat += "<tr><td width = 700px colspan = 3><center><b>You cannot leave a comment anonymously. Click <a href='byond://?src=\ref[src];change_viewer=1'>here</a> to select one of your saved characters.</b></center></td></tr>"
		dat += "</table>"

		dat += "<center><h3>Other Comments</h3></center>"
		dat += "<table width = 700px style=\"padding: 1px; display: flex; justify-content: center; align-items: center;\">"
		//TODO sort other_comments
		if(length(other_comments))
			var/ticker = FALSE
			for(var/datum/character_comment/comment in other_comments)
				dat += comment.get_comment_html(src, user, ticker ? COMMENT_CANDYSTRIPE_ONE : COMMENT_CANDYSTRIPE_TWO)
				ticker = !ticker
		else
			dat += "<tr><td width = 700px colspan = 3><center>There are no other comments to view.</center></td></tr>"
		dat += "</table>"

	var/datum/browser/popup = new(user, "character_information", "Character Information", 750, 800)
	popup.set_content(JOINTEXT(dat))
	popup.open()

/datum/character_information/Topic(href, href_list)
	. = ..()
	if(. || !usr?.client || !get_config_value(/decl/config/toggle/allow_character_comments))
		return

	if(href_list["create_comment"])

		// Have to commenting as someone, and you can't have commented already (edit your previous one nerd).
		if(!usr.client.viewing_character_info_as)
			return TOPIC_NOACTION
		var/datum/character_information/commenting_as = usr.client.viewing_character_info_as && SScharacter_info.get_record(usr.client.viewing_character_info_as, TRUE)
		if(!istype(commenting_as))
			return TOPIC_NOACTION
		for(var/datum/character_comment/comment in comments)
			if(comment.author_id == commenting_as.record_id)
				return TOPIC_NOACTION
		var/datum/character_comment/new_comment = new
		new_comment.author_char = commenting_as.char_name
		new_comment.author_ckey = commenting_as.ckey
		new_comment.author_id   = commenting_as.record_id
		new_comment.body        = "..."
		comments += new_comment
		. = TOPIC_REFRESH

	if(href_list["show_legend"])
		usr.client.show_comments_legend = text2num(href_list["show_legend"])
		. = TOPIC_REFRESH

	if(href_list["change_viewer"])
		var/list/other_slots = list()
		if(usr.client.prefs)
			for(var/i = 1 to length(usr.client.prefs.slot_names))
				var/slot_key = usr.client.prefs.get_slot_key(i)
				if(!slot_key || !LAZYACCESS(usr.client.prefs.slot_names, slot_key))
					continue
				var/datum/character_information/comments = SScharacter_info.get_record("[usr.ckey]-[slot_key]", TRUE)
				if(comments)
					other_slots += comments

		if(!length(other_slots))
			to_chat(usr, SPAN_WARNING("You have no character slots to select a viewer from."))
			. = TOPIC_NOACTION
		else
			var/datum/character_information/my_comments = input(usr, "Which character do you wish to view and comment as?", "View Character Comments") as null|anything in other_slots
			if(istype(my_comments))
				usr.client.viewing_character_info_as = my_comments.record_id
				. = TOPIC_REFRESH

	if(href_list["set_viewed"])
		var/datum/character_information/comments = SScharacter_info.get_record(href_list["set_viewed"])
		if(istype(comments))
			comments.display_to(usr)
			. = TOPIC_HANDLED

	if(href_list["change_viewed"])

		var/search_for = input(usr, "Please specify a name or ckey to search for.", "View Character Comments") as null|text
		if(search_for)
			usr.client.view_character_information(search_for)
		. = TOPIC_HANDLED

	if(href_list["comment_ref"])
		var/datum/character_comment/comment = locate(href_list["comment_ref"])
		if(!istype(comment))
			return TOPIC_NOACTION

		var/has_full_rights =   (comment.author_ckey == usr.ckey || check_rights(R_ADMIN))
		var/has_delete_rights = (has_full_rights || ckey == usr.ckey)

		if(has_full_rights)

			if(href_list["edit_comment"])
				var/new_body = sanitize(input(usr, "Enter or edit your comment.", "Editing Comment", comment.body) as message|null)
				if(new_body && !QDELETED(comment) && (comment in comments))
					comment.body = new_body
					comment.last_updated = REALTIMEOFDAY
					. = TOPIC_REFRESH

			if(href_list["change_comment_mood"])
				var/changing_border_mood = href_list["change_comment_mood"] == "border"
				var/list/moods = list()
				if(changing_border_mood)
					moods += "Clear border"
				var/list/all_moods = decls_repository.get_decls_of_type(/decl/comment_mood)
				for(var/mood in all_moods)
					moods += all_moods[mood]
				var/new_mood = input(usr, "Select a new mood for the [changing_border_mood ? "comment border" : "comment"].", "Select Mood", (changing_border_mood ? comment.border_mood : comment.main_mood) || GET_DECL(/decl/comment_mood)) as null|anything in moods
				if(new_mood)
					if(changing_border_mood)
						if(changing_border_mood == "Clear border")
							comment.border_mood = null
						else
							comment.border_mood = new_mood
					else
						comment.main_mood = new_mood
					comment.last_updated = REALTIMEOFDAY
					. = TOPIC_REFRESH

		if(has_delete_rights && href_list["delete_comment"])
			if(alert(usr, "Are you sure you want to delete this comment?", "Delete Message", "No", "Yes") == "Yes")
				if(!QDELETED(comment) && (comment in comments))
					comments -= comment
					qdel(comment)
					. = TOPIC_REFRESH

		if(. == TOPIC_REFRESH)
			has_new_comments = TRUE
			SScharacter_info.queue_to_save(record_id)

	if(. == TOPIC_REFRESH)
		display_to(usr)

/datum/admins/proc/dump_character_info_manifest()
	set name = "Dump Character Info Manifest"
	set category = "Debug"
	set src = usr

	var/list/dat = SScharacter_info.get_character_manifest_html()
	dat += "<a href='byond://?src=\ref[SScharacter_info];download_manifest=1'>Download as HTML</a>"

	var/datum/browser/popup = new(usr, "character_matrix", "Character Matrix", 800, 800)
	popup.set_content(JOINTEXT(dat))
	popup.open()

#undef COMMENT_CANDYSTRIPE_ONE
#undef COMMENT_CANDYSTRIPE_TWO
