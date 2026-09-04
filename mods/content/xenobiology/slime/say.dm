/mob/living/slime/say_quote(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "asks"
	else if (ending == "!")
		return "cries"
	return "chirps"

/mob/living/slime/say_understands(mob/speaker, decl/language/speaking)
	. = isslime(speaker) || ..()

/mob/living/slime/hear_say(datum/speech/phrases, verb = "says", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol, stars = FALSE, atom/relayed_by)
	var/datum/mob_controller/slime/slime_ai = ai
	if(istype(slime_ai) && (weakref(speaker) in slime_ai.observed_friends))
		LAZYSET(slime_ai.speech_buffer, speaker, lowertext(html_decode(phrases.unformatted_message)))
	return ..()

/mob/living/slime/hear_radio(datum/speech/phrases, verb = "says", part_a, part_b, part_c, mob/speaker, hard_to_hear = FALSE, vname = "", vsource, scramble = FALSE)
	var/datum/mob_controller/slime/slime_ai = ai
	if(istype(slime_ai) && (weakref(speaker) in slime_ai.observed_friends))
		LAZYSET(slime_ai.speech_buffer, speaker, lowertext(html_decode(phrases.unformatted_message)))
	return ..()
