#define PREF_SER_VERSION 1
/datum/preferences
	var/comments_record_id

/datum/preferences/proc/get_path(ckey, record_key, extension="json")
	return "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[record_key].[extension]"

// Returns null if there's no record file. Crashes on other error conditions.
/datum/preferences/proc/load_pref_record(record_key)
	var/path = get_path(client_ckey, record_key)
	if(!fexists(path))
		return null
	var/text = file2text(path)
	if(text == null)
		CRASH("failed to read [path]")
	var/list/data = json_decode(text)
	if(!istype(data))
		CRASH("failed to decode JSON from [path]")
	return new /datum/pref_record_reader/json_list(data)

/datum/preferences/proc/save_pref_record(record_key, list/data)
	var/path = get_path(client_ckey, record_key)
	var/text = json_encode(data)
	if(text == null)
		CRASH("failed to encode JSON for [path]")

	// Why this dance? If text2file fails, we want to leave the record as it was.

	var/tmp_path = "[path].tmp"
	// If we crashed at the end previously, we'll have a junk tmpfile, which text2file would append to.
	if(fexists(tmp_path))
		if(!fdel(tmp_path))
			CRASH("failed to remove junk existing tmpfile at [tmp_path]")
	if(!text2file(text,tmp_path))
		CRASH("failed to write record to tmpfile at [tmp_path]")
	if(!fcopy(tmp_path, path))
		CRASH("failed to copy tmpfile at [tmp_path] to [path]")
	if(!fdel(tmp_path))
		CRASH("failed to remove tmpfile at [tmp_path]")

/datum/preferences/proc/load_preferences()
	var/datum/pref_record_reader/R = load_pref_record("preferences")
	if(!R)
		R = new /datum/pref_record_reader/null_reader(PREF_SER_VERSION)
	player_setup.load_preferences(R)

/datum/preferences/proc/validate_comments_record(var/validate_slot)
	if(!SScharacter_info.initialized)
		return "The comments subsystem is still loading, or something has gone wrong. Please wait for server initialization to finish, and contact an admin if this message persists afterwards."
	if(isnull(validate_slot))
		validate_slot = default_slot
	var/slot_key = validate_slot && get_slot_key(validate_slot)
	if(!slot_key || !LAZYACCESS(slot_names, slot_key)) // Not actually a character slot.
		return "You have tried to validate an invalid slot ('[validate_slot || "null"]'). Please report this as a bug on the issue tracker."
	comments_record_id = SScharacter_info.get_record_id("[client_ckey]-[get_slot_key(validate_slot || default_slot)]")
	var/datum/character_information/comments = SScharacter_info.get_record(comments_record_id, TRUE)
	if(!comments)
		comments = SScharacter_info.get_or_create_record(comments_record_id, TRUE)
		comments.ckey = client_ckey
		comments.char_name = slot_names[slot_key] || "Unknown" // this may be inaccurate but it doesn't really matter at this point.
		comments.update_fields()
	comments_record_id = comments.record_id

/datum/preferences/proc/save_preferences()
	var/datum/pref_record_writer/json_list/W = new(PREF_SER_VERSION)
	player_setup.save_preferences(W)
	if(istext(comments_record_id) && length(comments_record_id))
		SScharacter_info.queue_to_save(comments_record_id)
	save_pref_record("preferences", W.data)

/datum/preferences/proc/get_slot_key(slot)
	return "character_[global.using_map.preferences_key()]_[slot]"

/datum/preferences/proc/load_character(slot)
	if(!slot)
		slot = default_slot

	if(slot != SAVE_RESET) // SAVE_RESET will reset the slot as though it does not exist, but keep the current slot for saving purposes.
		slot = sanitize_integer(slot, 1, get_config_value(/decl/config/num/character_slots), initial(default_slot))
		if(slot != default_slot)
			default_slot = slot
			SScharacter_setup.queue_preferences_save(src)

	var/record_id = "[client_ckey]-[get_slot_key(default_slot)]"
	if(slot == SAVE_RESET)
		// If we're resetting, set everything to null. Sanitization will clean it up
		var/datum/pref_record_reader/null_reader/R = new(PREF_SER_VERSION)
		SScharacter_info.clear_record(record_id)
		player_setup.load_character(R)
	else
		var/datum/pref_record_reader/R = load_pref_record(get_slot_key(slot))
		if(!R)
			R = new /datum/pref_record_reader/null_reader(PREF_SER_VERSION)
		// Load/reload our character info record - mass preload is done if comments are enabled, but not done otherwise.
		SScharacter_info.reload_record(record_id)
		player_setup.load_character(R)

	update_preview_icon()

/datum/preferences/proc/save_character(override_key=null)
	var/datum/pref_record_writer/json_list/W = new(PREF_SER_VERSION)
	player_setup.save_character(W)

	var/record_key = override_key || get_slot_key(default_slot)
	save_pref_record(record_key, W.data)

	// Cache the character's name for listing
	LAZYSET(slot_names, record_key, W.data["real_name"])
	SScharacter_setup.queue_preferences_save(src)

/datum/preferences/proc/sanitize_preferences()
	player_setup.sanitize_setup()
	return 1

#undef PREF_SER_VERSION
