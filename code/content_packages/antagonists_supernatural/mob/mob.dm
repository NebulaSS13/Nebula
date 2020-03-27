/mob/Destroy()
	if(mind && mind.current == src)
		spellremove(src)
	. = ..()