var/global/list/special_channel_keys = list(
	"r" = MESSAGE_MODE_RIGHT,
	"l" = MESSAGE_MODE_LEFT,
	"i" = MESSAGE_MODE_INTERCOM,
	"h" = MESSAGE_MODE_DEPARTMENT,
	"+" = MESSAGE_MODE_SPECIAL,    //activate radio-specific special functions
	"w" = MESSAGE_MODE_WHISPER,
	"к" = MESSAGE_MODE_RIGHT,
	"д" = MESSAGE_MODE_LEFT,
	"ш" = MESSAGE_MODE_INTERCOM,
	"р" = MESSAGE_MODE_DEPARTMENT,
	"ц" = MESSAGE_MODE_WHISPER
)

/mob/proc/say(datum/speech/phrases, verb = "says", whispering)
	return

/mob/verb/whisper()
	set name = "Whisper"
	set category = "IC"
	return

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"
	SStyping.set_indicator_state(client, FALSE)
	if(!filter_block_message(usr, message))
		usr.say(message)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	SStyping.set_indicator_state(client, FALSE)
	if(!filter_block_message(usr, message))
		message = sanitize(message)
		if(can_emote(VISIBLE_MESSAGE, src))
			usr.custom_emote(usr.emote_type, message)
		else
			usr.emote(message)

/mob/proc/say_dead(var/message)
	communicate(/decl/communication_channel/dsay, client, message)

/mob/proc/say_understands(mob/speaker, decl/language/speaking)
	if(stat == DEAD || universal_speak || universal_understand)
		return TRUE
	if(!istype(speaker))
		return TRUE
	if(speaking)
		return speaking.can_be_understood_by(speaker, src)
	return (speaker.universal_speak || istype(speaker, type) || istype(src, speaker.type))

/mob/proc/say_quote(var/message, var/decl/language/speaking = null)
	var/ending = copytext(message, length(message))
	if(speaking)
		return speaking.get_spoken_verb(src, ending)

	var/verb = pick(speak_emote)
	if(verb == "says") //a little bit of a hack, but we can't let speak_emote default to an empty list without breaking other things
		if(ending == "!")
			verb = pick("exclaims","shouts","yells")
		else if(ending == "?")
			verb ="asks"
	return verb

/mob/proc/check_speech_punctuation_state(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "question"
	else if (ending == "!")
		return "exclamation"
	return "statement"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode=MESSAGE_MODE_DEFAULT)
	if(length(message) <= 0)
		return null
	message = lowertext(message)
	var/initial_char = copytext_char(message,1,2)
	if(initial_char == get_common_radio_prefix())
		return standard_mode
	if(initial_char == get_department_radio_prefix() && length(message) >= 2)
		var/channel_prefix = copytext(message, 2, 3)
		. = global.special_channel_keys[channel_prefix] || channel_prefix

// returns a language based on the supplied key
/mob/proc/get_language_by_key(language_key)

	// This is a numerical key to our default language.
	var/num_key = isnum(language_key) ? language_key : text2num(language_key)
	if(num_key == 0)
		return get_default_language()

	// This is a positional numerical key to our language list.
	if(num_key > 0 && num_key <= length(languages))
		return languages[num_key]

	// This is a text key - it's either a full key reference, or a partial reference to a language we know.
	// Try the full language list first.
	var/static/list/languages_by_key
	if(!languages_by_key)
		languages_by_key = list()
		for(var/decl/language/lang in decls_repository.get_decls_of_subtype_unassociated(/decl/language))
			if(lang.language_key)
				languages_by_key[lang.language_key] = lang
	language_key = lowertext(language_key)
	. = languages_by_key[language_key]
	if(.)
		return

	// Find the first language that has a key starting with the key we asked for.
	for(var/decl/language/lang as anything in languages)
		lang = RESOLVE_TO_DECL(lang)
		if(!lang?.language_key) // no key, why is this non-abstract?
			continue
		if(length(lang.language_key) <= length(language_key)) // if we had identical keys, we'd have returned already
			continue
		if(copytext(lang.language_key, 1, length(language_key)+1) == language_key)
			return lang

//parses the language code (e.g. ,j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(message)
	var/prefix = copytext_char(message,1,2)
	if(length(message) >= 1 && prefix == get_prefix_key(/decl/prefix/audible_emote))
		return GET_DECL(/decl/language/noise)
	if(length(message) >= 2 && prefix == get_prefix_key(/decl/prefix/language))
		var/key_end = findtext_char(message, " ")
		if(key_end > 0)
			var/decl/language/speaking = get_language_by_key(lowertext(copytext_char(message, 2, key_end)))
			if(speaking && can_speak(speaking))
				return speaking

/mob/proc/is_silenced()
	. = !!get_item_blocking_speech()

/obj/item/proc/blocks_speech_in_mouth(mob/wearer)
	return FALSE

/mob/proc/get_item_blocking_speech()
	// Can't talk with something in your mouth.
	var/datum/inventory_slot/mouth_slot = get_inventory_slot_datum(BP_MOUTH)
	. = mouth_slot?.get_equipped_item()
	if(!.)
		var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
		if(mask?.blocks_speech_in_mouth(src))
			return mask

/mob/proc/get_default_language()
	return

/mob/proc/get_any_good_language(set_default=FALSE)
	return

/mob/proc/handle_speech_problems(var/list/message_data, var/decl/language/spoken)
	return message_data

// Parses a message into a list of list(text = spoken language) entries.
/mob/proc/parse_message_into_phrases(message)

	message = trim(message)
	var/full_message = message

	//parse the radio code and consume it
	var/message_mode = parse_message_mode(full_message, standard_mode = MESSAGE_MODE_DEFAULT)
	if(message_mode)
		if(message_mode == MESSAGE_MODE_DEFAULT)
			message = copytext_char(message, 2)
		else
			message = copytext_char(message, 3)

	var/static/regex/split_msg_regex = regex("(.*)(,\\w.*)")
	var/list/phrases = list()
	while(split_msg_regex.Find(message))
		message = split_msg_regex.group[1]
		phrases.Insert(1, split_msg_regex.group[2])
	if(message)
		phrases.Insert(1, message)

	var/use_verb
	var/list/parsed_phrases = list()
	for(var/phrase in phrases)

		var/decl/language/speaking = parse_language(phrase)
		if(speaking)
			if(speaking.type == /decl/language/noise)
				phrase = copytext_char(phrase, 1) // trim the single-char noise prefix
			else
				phrase = copytext_char(phrase, findtext_char(phrase, " ")+1) // trim the entire key
		else
			speaking = get_any_good_language(set_default=TRUE)

		// Format and present nicely.
		phrase = trim(html_encode(phrase))
		phrase = handle_autohiss(phrase, speaking)

		// The LANG_FLAG_NO_STUTTER check means nonvocal or unusually-produced
		// languages (e.g. sign language, noise emotes, computer beeps)
		// will not be affected by stuttering, slurring, silence, etc. effects.
		if(speaking && !(speaking.language_flags & LANG_FLAG_NO_STUTTER))
			var/list/message_data = list(phrase, speaking.speech_verb, 0)
			if(handle_speech_problems(message_data))
				phrase = message_data[1]
				use_verb ||= message_data[2]

		if(speaking)
			var/speech_ability_result = speaking.can_be_spoken_properly_by(src)
			if(speech_ability_result == SPEECH_RESULT_MUDDLED)
				phrase = speaking.muddle(phrase)
			else if(speech_ability_result == SPEECH_RESULT_INCAPABLE)
				// weird phrasing, but needs to cover speaking and signing
				to_chat(src, SPAN_WARNING("You don't have the right equipment to communicate in that way!"))
				return

		parsed_phrases += list(list(phrase, speaking))

	if(length(parsed_phrases))
		return new /datum/speech(src, full_message, message_mode, parsed_phrases, use_verb)
