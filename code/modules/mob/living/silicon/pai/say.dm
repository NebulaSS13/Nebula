/mob/living/silicon/pai/say(var/msg)
	if(HAS_STATUS(src, STAT_SILENCE))
		to_chat(src, SPAN_WARNING("Communication circuits are disabled."))
		return
	return ..(msg)
