/decl/language/mantid
	name = "Ascent-Voc"
	desc = "A curt, sharp language developed by the insectoid Ascent for use over comms."
	speech_verb = "clicks"
	ask_verb = "chirps"
	exclaim_verb = "rasps"
	colour = "alien"
	syllables = list("-","=","+","_","|","/")
	space_chance = 0
	key = "|"
	flags = LANG_FLAG_RESTRICTED
	shorthand = "KV"
	machine_understands = FALSE
	var/list/correct_mouthbits = list(
		SPECIES_MANTID_ALATE,
		SPECIES_MANTID_GYNE
	)

/decl/language/mantid/can_be_spoken_properly_by(var/mob/speaker)
	var/mob/living/S = speaker
	if(!istype(S))
		return SPEECH_RESULT_INCAPABLE
	if(S.isSynthetic())
		return SPEECH_RESULT_GOOD
	if(ishuman(speaker))
		var/mob/living/human/H = speaker
		if(H.species.name in correct_mouthbits)
			return SPEECH_RESULT_GOOD
	return SPEECH_RESULT_MUDDLED

/decl/language/mantid/muddle(var/message)
	message = replacetext(message, "...",  ".")
	message = replacetext(message, "!?",   ".")
	message = replacetext(message, "?!",   ".")
	message = replacetext(message, "!",    ".")
	message = replacetext(message, "?",    ".")
	message = replacetext(message, ",",    "")
	message = replacetext(message, ";",    "")
	message = replacetext(message, ":",    "")
	message = replacetext(message, ".",    "...")
	message = replacetext(message, "&#39", "'")
	return message

/decl/language/mantid/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	. = ..(speaker, message, speaker.real_name)

/decl/language/mantid/nonvocal
	key = "]"
	name = "Ascent-Glow"
	desc = "A complex visual language of bright bio-luminescent flashes, 'spoken' natively by the Kharmaani of the Ascent."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = LANG_FLAG_RESTRICTED | LANG_FLAG_NO_STUTTER | LANG_FLAG_NONVERBAL
	shorthand = "KNV"

#define MANTID_SCRAMBLE_CACHE_LEN 20
/decl/language/mantid/nonvocal/scramble(mob/living/speaker, input, list/known_languages)
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n
	var/scrambled_text = ""
	scramble_cache[input] = make_rainbow("**********************************")
	if(scramble_cache.len > MANTID_SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-MANTID_SCRAMBLE_CACHE_LEN-1)
	return scrambled_text
#undef MANTID_SCRAMBLE_CACHE_LEN

/decl/language/mantid/nonvocal/can_speak_special(var/mob/living/speaker)
	if(istype(speaker) && speaker.isSynthetic())
		return TRUE
	else if(ishuman(speaker))
		var/mob/living/human/H = speaker
		return (H.species.name == SPECIES_MANTID_ALATE || H.species.name == SPECIES_MANTID_GYNE)
	return FALSE

/decl/language/mantid/worldnet
	key = "\["
	name = "Worldnet"
	desc = "The mantid aliens of the Ascent maintain an extensive self-supporting broadcast network for use in team communications."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = LANG_FLAG_RESTRICTED | LANG_FLAG_NO_STUTTER | LANG_FLAG_NONVERBAL | LANG_FLAG_HIVEMIND
	shorthand = "KB"

#define isascentdrone(X) istype(X, /mob/living/silicon/robot/flying/ascent)
/decl/language/mantid/worldnet/check_special_condition(var/mob/living/other)
	if(isascentdrone(other))
		return TRUE
	if(istype(other) && (locate(/obj/item/organ/internal/controller) in other.get_internal_organs()))
		return TRUE
	return FALSE
