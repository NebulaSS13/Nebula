/decl/prefix
	decl_flags = DECL_FLAG_MANDATORY_UID
	var/name
	var/default_key
	var/is_locked = FALSE

/decl/prefix/language
	name = "Language"
	default_key = ","
	uid = "chat_prefix_language"

/decl/prefix/radio_channel_selection
	name = "Radio, channel selection"
	default_key = ":"
	is_locked = TRUE
	uid = "chat_prefix_radio_channel"

/decl/prefix/radio_main_channel
	name = "Radio, main channel"
	default_key = ";"
	uid = "chat_prefix_radio_channel_main"

/decl/prefix/audible_emote
	name = "Emote, audible"
	default_key = "!"
	uid = "chat_prefix_emote_audible"

/decl/prefix/visible_emote
	name = "Emote, visible"
	default_key = "^"
	uid = "chat_prefix_emote_visible"

/decl/prefix/custom_emote
	name = "Emote, custom"
	default_key = "*"
	uid = "chat_prefix_emote_custom"
