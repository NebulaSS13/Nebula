// General-purpose memorise proc, used by /commanded
/datum/mob_controller/proc/memorise(mob/speaker, message)
	if((ai_flags & AI_FLAG_COMMANDED) && is_friend(speaker))
		var/command = list(list(speaker, lowertext(html_decode(message))))
		LAZYADD(command_buffer, command)

// General-purpose memory checking proc, used by /faithful_hound
/datum/mob_controller/proc/check_memory(mob/speaker, message)
	return FALSE
