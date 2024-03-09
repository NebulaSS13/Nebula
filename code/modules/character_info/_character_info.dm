/// Main holder class for character comments - primarily user-set info, tracking vars, and a list of comment datums.
/datum/character_information
	/// A user-descriptive (searchable) name for presenting comment holders.
	var/name
	/// Any user-specified in character info, like Teshari pack stuff or faction notes.
	var/ic_info
	/// Any user-specified out of character info, like content warnings.
	var/ooc_info
	/// Owning character name (for searches)
	var/char_name
	/// Owning ckey (for searches).
	var/ckey
	/// GUID for this ckey/save slot combo.
	var/record_id
	/// Linear list of comment datums for comments left on this character.
	var/list/comments = list()
	/// Whether or not this record is allowing comments currently
	var/allow_comments = FALSE
	/// Boolean to indicate if the owner of this record has read it since it was last update.
	var/has_new_comments = FALSE
	/// Boolean to indicate if this character will show IC and OOC info when examined.
	var/show_info_on_examine = FALSE
	/// The location this file was loaded from in the first place. Defaults to subsystem and ID if unset.
	var/file_location
	/// Static list of var keys to serialize. TODO: unit test
	var/static/list/serialize_fields = list(
		"record_id",
		"char_name",
		"ckey",
		"ic_info",
		"ooc_info",
		"has_new_comments",
		"allow_comments",
		"show_info_on_examine"
	)

/datum/character_information/New(var/list/json_input)

	// None of our serialized fields are datum references so this should in theory be safe.
	for(var/key in json_input)
		try
			if(key in vars)
				vars[key] = json_input[key]
			else
				log_error("Character comments attempting to deserialize invalid var '[key]'")
		catch(var/exception/E)
			log_error("Exception on deserializing character comments: [E]")

	// Comments are serialized to a linear list of json strings
	// so we now need to deserialize them to instances.
	if(length(comments))
		var/list/loading_comments = comments
		comments = list()
		for(var/list/comment in loading_comments)
			comments += new /datum/character_comment(comment)

	// Update our display name.
	update_fields()

/datum/character_information/proc/update_fields()
	name = "[char_name || "Unknown"] - [ckey || "Unknown"]"

/datum/character_information/proc/serialize_to_json()

	. = list()
	for(var/key in serialize_fields)
		if(key in vars)
			.[key] = vars[key]
		else
			log_error("Character comments attempting to serialize invalid var '[key]'")

	var/list/serialized_comments = list()
	for(var/datum/character_comment/comment in comments)
		serialized_comments += list(comment.serialize_to_list()) // Double wrap to avoid list merge.
	.["comments"] = serialized_comments

	. = json_encode(.)
