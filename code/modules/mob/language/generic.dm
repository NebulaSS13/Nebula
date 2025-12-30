// Noise "language", for audible emotes.
/decl/language/noise
	name = "Noise"
	desc = "Noises"
	key = ""
	flags = LANG_FLAG_RESTRICTED|LANG_FLAG_NONGLOBAL|LANG_FLAG_INNATE|LANG_FLAG_NO_TALK_MSG|LANG_FLAG_NO_STUTTER
	hidden_from_codex = TRUE

/decl/language/noise/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/decl/language/noise/format_message_plain(message, verb)
	return message

/decl/language/noise/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/decl/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

/decl/language/sign
	name = "Sign Language"
	desc = "In an age of commonplace extra-vehicular activity and habitation of airless worlds, \
	sign language is often an essential communication tool for large portions of the population."
	signlang_verb = list("gestures")
	colour = "say_quote"
	key = "s"
	flags = LANG_FLAG_SIGNLANG | LANG_FLAG_NO_STUTTER | LANG_FLAG_NONVERBAL
	shorthand = "HS"
