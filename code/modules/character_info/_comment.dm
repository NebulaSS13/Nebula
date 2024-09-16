/// Individual comment datum. Tracked by the comment holder datum.
/datum/character_comment
	/// Actual text body of the comment.
	var/body
	/// Author character name for comment/display.
	var/author_char
	/// Author ckey for comment/display.
	var/author_ckey
	/// Combined ckey/save slot GUID for linking back to the author's comments page.
	var/author_id
	/// REALTIMEOFDAY value of the last edit, used for hiding old or out of date comments.
	var/last_updated
	/// Formatting info for displaying comments a la the old shipping manifest.
	var/decl/comment_mood/main_mood
	var/decl/comment_mood/border_mood
	/// Static list of var keys to serialize. TODO: unit test
	var/static/list/serialize_fields = list(
		"body",
		"author_char",
		"author_ckey",
		"author_id",
		"last_updated"
	)

/datum/character_comment/proc/is_stale()
	return !get_config_value(/decl/config/num/hide_comments_older_than) || (REALTIMEOFDAY - last_updated) > (get_config_value(/decl/config/num/hide_comments_older_than))

/datum/character_comment/proc/get_comment_html(var/datum/character_information/presenting, var/mob/usr, var/row_bkg_color)

	if(!istype(main_mood))
		main_mood = GET_DECL(/decl/comment_mood/unknown)

	var/mood_title = main_mood.name
	if(border_mood)
		mood_title = "[mood_title] ([border_mood.name])"
	. = list(
		"<tr bgcolor = '[row_bkg_color]'>",
		"<td width = 170px><small><center><b>[author_char]</b><br/><i>([author_ckey])</i><br/><a href='byond://?src=\ref[presenting];set_viewed=[author_id]'>View</a></small></center></td>",
		"<td title = '[mood_title]' style=\"border: 1px solid [border_mood ? border_mood.bg_color : main_mood.fg_color];\" width = 360px bgcolor = '[main_mood.bg_color]'><center><font color = '[main_mood.fg_color]'>[body]</font></center></td>",
		"<td width = 170px>"
	)
	if(usr)
		. += "<center>"
		if(author_ckey == usr.ckey || check_rights(R_MOD))
			. += "<a href='byond://?src=\ref[presenting];comment_ref=\ref[src];edit_comment=1'>Edit</a><br/>"
			. += "<a href='byond://?src=\ref[presenting];comment_ref=\ref[src];delete_comment=1'>Delete</a><br/>"
			. += "<a href='byond://?src=\ref[presenting];comment_ref=\ref[src];change_comment_mood=primary'>Change primary mood</a><br/>"
			. += "<a href='byond://?src=\ref[presenting];comment_ref=\ref[src];change_comment_mood=border'>Change border mood</a>"
		else if(usr.ckey == presenting.ckey)
			. += "<a href='byond://?src=\ref[presenting];comment_ref=\ref[src];delete_comment=1'>Delete</a>"
		else
			. += "<small><i>Not editable.</i></small>"
		. += "</center>"
	. += "</td></tr>"

/datum/character_comment/proc/deserialize_mood(var/decl/comment_mood/mood_input)
	if(mood_input && !istype(mood_input))
		if(ispath(mood_input, /decl/comment_mood))
			mood_input = GET_DECL(mood_input)
		else if(istext(mood_input))
			mood_input = lowertext(trim(mood_input))
			var/list/all_moods = decls_repository.get_decls_of_type(/decl/comment_mood)
			for(var/mood_type in all_moods)
				var/decl/comment_mood/check_mood = all_moods[mood_type]
				if(lowertext(trim(check_mood.uid)) == mood_input)
					mood_input = check_mood
					break
			if(!istype(mood_input))
				mood_input = null
		else
			mood_input = null
	if(!mood_input)
		mood_input = GET_DECL(/decl/comment_mood)
	return mood_input

/datum/character_comment/New(var/list/json_input)

	for(var/key in json_input)
		try
			vars[key] = json_input[key]
		catch(var/exception/E)
			log_error("Exception on deserializing character comment: [E]")

	// Moods are decls stored by uid, they need to be deserialized again after JSON load.
	main_mood = deserialize_mood(main_mood)
	if(!isnull(border_mood))
		border_mood = deserialize_mood(border_mood)

	// If we didn't have a deserialized value we must have been created today.
	if(isnull(last_updated))
		last_updated = REALTIMEOFDAY

/// Generate a list of fields to values for use in comment holder json serialization.
/datum/character_comment/proc/serialize_to_list()
	. = list()
	for(var/key in serialize_fields)
		if(key in vars)
			.[key] = vars[key]
		else
			log_error("Character comment attempting to serialize invalid var '[key]'")
	if(istype(main_mood))
		.["main_mood"] = lowertext(main_mood.uid)
	if(istype(border_mood))
		.["border_mood"] = lowertext(border_mood.uid)
