/mob/living/slime/say_quote(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "asks"
	else if (ending == "!")
		return "cries"
	return "chirps"

/mob/living/slime/say_understands(mob/speaker, decl/language/speaking)
	. = isslime(speaker) || ..()

/mob/living/slime/hear_say(var/message, var/verb = "says", var/decl/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	var/datum/mob_controller/slime/slime_ai = ai
	if(istype(slime_ai) && (weakref(speaker) in slime_ai.observed_friends))
		LAZYSET(slime_ai.speech_buffer, speaker, lowertext(html_decode(message)))
	return ..()

/mob/living/slime/hear_radio(var/message, var/verb="says", var/decl/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="", var/vsource)
	var/datum/mob_controller/slime/slime_ai = ai
	if(istype(slime_ai) && (weakref(speaker) in slime_ai.observed_friends))
		LAZYSET(slime_ai.speech_buffer, speaker, lowertext(html_decode(message)))
	return ..()
