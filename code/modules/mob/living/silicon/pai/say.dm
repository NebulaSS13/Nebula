/mob/living/silicon/pai/say(datum/speech/phrases, verb = "says", whispering)
	if(HAS_STATUS(src, STAT_SILENCE))
		to_chat(src, SPAN_WARNING("Communication circuits are disabled."))
		return
	return ..()
