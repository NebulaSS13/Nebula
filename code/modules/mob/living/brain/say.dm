/mob/living/brain/say(datum/speech/phrases, verb = "says", whispering)
	if(GET_STATUS(src, STAT_SILENCE) || !is_in_interface())
		return
	if(prob(emp_damage*4))
		if(prob(10))
			return
		if(istext(phrases))
			phrases = Gibberish(phrases, (emp_damage*6))
		else if(islist(phrases))
			for(var/list/phrase in phrases.phrases)
				phrase[1] = Gibberish(phrase[1], (emp_damage*6))
	. = ..()
	var/obj/item/radio/radio = get_radio()
	if(radio)
		radio.hear_talk(src, phrases, verb)

