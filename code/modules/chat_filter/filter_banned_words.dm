#ifndef BANNED_WORD_LOCATION
#define BANNED_WORD_LOCATION "config/banned_words.json"
#endif

/decl/chat_filter/regexp/banned_words
	name = "Banned Words"
	summary = "Blocks speech, emotes, character names and announcements that contain banned words. Contact an admin for information on which words are banned."
	can_deny_message = TRUE

/decl/chat_filter/regexp/banned_words/Initialize()
	. = ..()
	disabled = TRUE
	var/list/banned_words = cached_json_decode(safe_file2text(BANNED_WORD_LOCATION, FALSE))
	if(length(banned_words))
		disabled = FALSE
		filter_regex = regex("\\b([jointext(banned_words, "|")])\\b", "i")

/decl/chat_filter/regexp/banned_words/deny(var/mob/speaker, var/match)
	log_and_message_admins("[key_name(speaker)] tried to use a banned word: '[filter_regex.match]'.", speaker, get_turf(speaker))
	return "You tried to use a banned word: '[filter_regex.match]'."

#undef BANNED_WORD_LOCATION