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

/mob/proc/say()
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
		if(use_me)
			usr.emote("me",usr.emote_type,message)
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

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

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

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(var/message)

	var/prefix = copytext_char(message,1,2)
	if(length(message) >= 1 && prefix == get_prefix_key(/decl/prefix/audible_emote))
		return GET_DECL(/decl/language/noise)

	if(length(message) >= 2 && is_language_prefix(prefix))
		var/language_prefix = lowertext(copytext_char(message, 2 ,3))
		var/decl/language/L = SSlore.get_language_by_key(language_prefix)
		if (can_speak(L))
			return L

/mob/proc/is_silenced()
	. = is_muzzled()

/mob/proc/is_muzzled()
	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	return istype(mask, /obj/item/clothing/mask/muzzle) || istype(mask, /obj/item/clothing/sealant)
