/mob/living/silicon
	default_law_extension_type = /datum/extension/laws/silicon

/mob/living/silicon/robot/get_law_superior()
	. = (lawupdate && connected_ai)

/mob/living/silicon/ai/get_law_subordinates()
	for(var/atom/movable/beep in connected_robots)
		if(beep.get_law_superior() == src)
			LAZYADD(., beep)

/mob/living/silicon/update_laws()
	get_or_create_extension(src, default_law_extension_type)
	verbs |= /mob/living/proc/show_laws_verb
	verbs |= /mob/living/proc/state_laws_verb
	verbs |= /mob/living/silicon/manage_laws_verb

/mob/living/silicon/manage_laws_verb()
	open_subsystem(/datum/nano_module/law_manager)
