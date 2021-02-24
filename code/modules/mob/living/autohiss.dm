#define AUTOHISS_NUM 3


/mob/living/proc/handle_autohiss(message, decl/language/L)
	return message // no autohiss at this level

/mob/living/carbon/human/handle_autohiss(message, decl/language/L)
	if(!client || get_preference_value(/datum/client_preference/autohiss) == GLOB.PREF_OFF) // no need to process if there's no client or they have autohiss off
		return message
	return species.handle_autohiss(message, L, get_preference_value(/datum/client_preference/autohiss))

/decl/species
	var/list/autohiss_basic_map = null
	var/list/autohiss_extra_map = null
	var/list/autohiss_exempt = null

/decl/species/proc/get_autohiss_map(var/mode)
	. = autohiss_basic_map?.Copy() || list()
	if(mode == GLOB.PREF_FULL && autohiss_extra_map)
		. |= autohiss_extra_map

/decl/species/proc/handle_autohiss(message, decl/language/lang, mode)
	if(!autohiss_basic_map)
		return message
	if(lang.flags & NO_STUTTER)	// Currently prevents EAL, Sign language, and emotes from autohissing
		return message
	if(autohiss_exempt && (lang.name in autohiss_exempt))
		return message

	var/map = get_autohiss_map(mode)
	. = list()

	while(length(message))
		var/min_index = 10000 // if the message is longer than this, the autohiss is the least of your problems
		var/min_char = null
		for(var/char in map)
			var/i = findtext_char(message, char)
			if(!i) // no more of this character anywhere in the string, don't even bother searching next time
				map -= char
			else if(i < min_index)
				min_index = i
				min_char = char
		if(!min_char) // we didn't find any of the mapping characters
			. += message
			break
		. += copytext_char(message, 1, min_index)
		if(copytext_char(message, min_index, min_index+1) == uppertext(min_char))
			switch(text2ascii(message, min_index+1))
				if(65 to 90) // A-Z, uppercase; uppercase R/S followed by another uppercase letter, uppercase the entire replacement string
					. += uppertext(pick(map[min_char]))
				else
					. += capitalize(pick(map[min_char]))
		else
			. += pick(map[min_char])
		message = copytext_char(message, min_index + 1)

	return jointext(., null)