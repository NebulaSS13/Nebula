/mob/living/silicon/pai/say(var/msg)
	if(silence_time)
		to_chat(src, SPAN_WARNING("Communication circuits are disabled."))
		return
	return ..(msg)
