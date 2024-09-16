// Holder subsystem for character comment records.
SUBSYSTEM_DEF(character_info)
	name = "Character Information"
	flags = SS_NEEDS_SHUTDOWN
	init_order = SS_INIT_EARLY
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT // We want to save changes made during pre-round lobby.
	var/static/comments_source = "data/character_info/"
	var/list/_comment_holders_by_id = list()
	var/list/_ids_to_save = list()

/datum/controller/subsystem/character_info/Initialize()
	. = ..()
	if(!get_config_value(/decl/config/toggle/allow_character_comments))
		report_progress("Skipping mass load of character records as character comments are disabled.")
		return
	if(!fexists(comments_source))
		report_progress("Character information directory [comments_source] does not exist, no character comments will be saved or loaded.")
		return
	var/loaded_json_manifest = load_text_from_directory(comments_source, ".json")
	if(!islist(loaded_json_manifest) || !length(loaded_json_manifest["files"]))
		return
	var/list/loaded_files = loaded_json_manifest["files"]
	var/loaded_comments = 0
	for(var/loaded_file in loaded_files)
		var/datum/character_information/comments = load_record(loaded_files[loaded_file])
		if(!istext(comments.record_id))
			PRINT_STACK_TRACE("Deserialized character information had invalid id '[comments.record_id || "NULL"]'!")
			continue

		// Remove any pre-created records (early joiners, etc.)
		if(_comment_holders_by_id[comments.record_id])
			var/old_record = _comment_holders_by_id[comments.record_id]
			_comment_holders_by_id -= comments.record_id
			qdel(old_record)

		comments.file_location = loaded_file
		_comment_holders_by_id[comments.record_id] = comments
		loaded_comments += length(comments.comments)
	report_progress("Loaded [loaded_comments] record\s for [length(_comment_holders_by_id)] character\s.")

/datum/controller/subsystem/character_info/Shutdown()
	. = ..()
	for(var/id in _comment_holders_by_id)
		save_record(id)

/datum/controller/subsystem/character_info/stat_entry(msg)
	..("R:[_comment_holders_by_id.len]Q:[_ids_to_save.len][msg]")

/datum/controller/subsystem/character_info/fire(resumed = FALSE, no_mc_tick = FALSE)
	while(_ids_to_save.len)
		var/id = _ids_to_save[1]
		_ids_to_save -= id
		save_record(id)
		if(TICK_CHECK)
			return

/datum/controller/subsystem/character_info/proc/queue_to_save(var/record_id)
	if(istext(record_id) && length(record_id))
		_ids_to_save |= record_id

/datum/controller/subsystem/character_info/proc/save_record(var/record_id)
	if(!istext(record_id) || !record_id)
		return
	var/datum/character_information/comments = get_record(record_id, TRUE)
	if(!istype(comments))
		return
	if(!comments.file_location)
		comments.file_location = "[comments_source][ckey(comments.record_id)].json"
	try
		if(fexists(comments.file_location))
			fdel(comments.file_location)
		to_file(file(comments.file_location), comments.serialize_to_json())
	catch(var/exception/E)
		PRINT_STACK_TRACE("Exception when writing out character information file to [comments?.file_location || "NULL"]: [E]")

/datum/controller/subsystem/character_info/proc/load_record(var/load_from)
	var/datum/character_information/comments = new(cached_json_decode(load_from))
	_comment_holders_by_id[comments.record_id] = comments
	return comments

/datum/controller/subsystem/character_info/proc/reload_record(var/record_id)
	var/datum/character_information/comments = get_record(record_id, TRUE)
	if(comments && comments.file_location && fexists(comments.file_location))
		var/reload_from = comments.file_location
		_comment_holders_by_id -= comments.record_id
		qdel(comments)
		try
			. = load_record(safe_file2text(reload_from))
		catch(var/exception/E)
			PRINT_STACK_TRACE("Exception when reloading record from [reload_from]: [E]")

/datum/controller/subsystem/character_info/proc/clear_record(var/record_id)
	var/datum/character_information/comments = get_record(record_id, TRUE)
	if(comments)
		comments.comments.Cut()
		comments.ic_info = null
		comments.ooc_info = null

/datum/controller/subsystem/character_info/proc/get_record_id(var/record_id)
	return trim(lowertext(record_id))

/datum/controller/subsystem/character_info/proc/get_record(var/record_id, var/override_prefs, var/discard_archived_record)
	record_id = get_record_id(record_id)
	if(!record_id)
		CRASH("Attempt to retrieve null character information ID.")
	var/datum/character_information/comments = _comment_holders_by_id[record_id]
	if(istype(comments) && (override_prefs || (get_config_value(/decl/config/toggle/allow_character_comments) && comments.allow_comments) || comments.show_info_on_examine))
		return comments

/datum/controller/subsystem/character_info/proc/get_or_create_record(var/record_id, var/override_prefs)
	. = get_record(record_id, override_prefs)
	if(!. && initialized)
		// Let's assume they'll populate it if so desired.
		var/datum/character_information/comments = new
		comments.record_id = get_record_id(record_id)
		_comment_holders_by_id[comments.record_id] = comments
		. = comments

/datum/controller/subsystem/character_info/proc/search_records(var/search_for)
	search_for = ckey(lowertext(trim(search_for)))
	for(var/id in _comment_holders_by_id)
		var/datum/character_information/comments = _comment_holders_by_id[id]
		if(istype(comments))
			for(var/checkstring in list(comments.name, comments.ckey, comments.record_id))
				if(findtext(ckey(lowertext(trim(checkstring))), search_for) > 0)
					LAZYADD(., comments)
					break

/datum/controller/subsystem/character_info/Topic(href, href_list)
	. = ..()
	if(!. && href_list["download_manifest"] && usr && check_rights(R_ADMIN))
		try
			var/dump_file_name = "[comments_source]dump_character_manifest.html"
			if(fexists(dump_file_name))
				fdel(dump_file_name)
			text2file(JOINTEXT(SScharacter_info.get_character_manifest_html(apply_striping = FALSE)), dump_file_name)
			if(fexists(dump_file_name))
				direct_output(usr, ftp(dump_file_name, "dump_manifest.html"))
				return TOPIC_HANDLED
		catch(var/exception/E)
			log_debug("Exception when dumping character relationship manifest: [E]")

#define COMMENT_CANDYSTRIPE_ONE "#343434"
#define COMMENT_CANDYSTRIPE_TWO "#454545"
/datum/controller/subsystem/character_info/proc/get_character_manifest_html(var/apply_striping = TRUE)
	var/list/records_with_an_entry = list()
	for(var/id in _comment_holders_by_id)
		var/datum/character_information/comments = _comment_holders_by_id[id]
		for(var/datum/character_comment/comment in comments.comments)
			if(comment.is_stale())
				continue
			records_with_an_entry |= comment.author_id
	sortTim(records_with_an_entry, /proc/cmp_text_asc)
	. = list("<table>")
	if(apply_striping)
		. += "<tr bgcolor = '[COMMENT_CANDYSTRIPE_ONE]'>"
	else
		. += "<tr>"
	. += "<th width = '170px'><center>Character Relationship Matrix</center></th>"
	for(var/column_id in records_with_an_entry)
		var/datum/character_information/column = _comment_holders_by_id[column_id]
		. += "<td width = '360px' style=\"border: 1px solid #272727;\"><center>[column.char_name]<br/><small><i>[column.ckey]</i></small></center></td>"
	. += "</tr>"
	var/ticker = FALSE
	for(var/row_id in records_with_an_entry)
		if(apply_striping)
			. += "<tr bgcolor = '[ticker ? COMMENT_CANDYSTRIPE_ONE : COMMENT_CANDYSTRIPE_TWO]'>"
			ticker = !ticker
		else
			. += "<tr>"
		var/datum/character_information/row = _comment_holders_by_id[row_id]
		. += "<td width = '170px' style=\"border: 1px solid #272727;\"><center>[row.char_name]<br/><small><i>[row.ckey]</i></small></center></td>"
		for(var/column_id in records_with_an_entry)
			var/datum/character_information/column = _comment_holders_by_id[column_id]
			var/found_comment = FALSE
			for(var/datum/character_comment/comment in column.comments)
				if(comment.author_id == row_id && !comment.is_stale())
					found_comment = TRUE
					var/mood_title = comment.main_mood.name
					if(comment.border_mood)
						mood_title = "[mood_title] ([comment.border_mood.name])"
					. += "<td title = '[mood_title]' width = '360px' style=\"border: 1px solid [comment.border_mood ? comment.border_mood.bg_color : comment.main_mood.fg_color];\" bgcolor = '[comment.main_mood.bg_color]'><center><font color = '[comment.main_mood.fg_color]'>[comment.body]</font></center></td>"
					break
			if(!found_comment)
				. += "<td width = '360px' style=\"border: 1px solid #272727;\"></td>"
		. += "</tr>"
	. += "</table>"
#undef COMMENT_CANDYSTRIPE_ONE
#undef COMMENT_CANDYSTRIPE_TWO