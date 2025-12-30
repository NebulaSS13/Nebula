/mob/living/silicon/pai/get_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	infix = ", personal AI"
	. = ..()
	switch(stat)
		if(CONSCIOUS)
			if(!src.client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			. += "<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)
			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"
	. += "*---------*"
	if(print_flavor_text())
		. += "[print_flavor_text()]"
	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "It is [pose]"
