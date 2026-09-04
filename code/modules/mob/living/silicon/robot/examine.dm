/mob/living/silicon/robot/examined_by(mob/user, distance, infix, suffix)
	. = ..()
	user?.showLaws(src)

/mob/living/silicon/robot/get_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	infix = custom_name ? ", [modtype] [braintype]" : ""
	. = ..()
	var/brute_damage = get_damage(BRUTE)
	if (brute_damage >= 75)
		. += SPAN_WARNING("<B>It looks severely dented!</B>")
	else if(brute_damage)
		. += SPAN_WARNING("It looks slightly dented.")
	var/burn_damage = get_damage(BURN)
	if (burn_damage >= 75)
		. += SPAN_WARNING("<B>It looks severely burnt and heat-warped!</B>")
	else if(burn_damage)
		. += SPAN_WARNING("It looks slightly charred.")
	if(opened)
		. += SPAN_WARNING("Its cover is open and the power cell is [cell ? "installed" : "missing"].")
	else
		. += "Its cover is closed."
	if(!has_power)
		. += SPAN_WARNING("It appears to be running on backup power.")
	switch(stat)
		if(CONSCIOUS)
			if(!client)
				. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			. += SPAN_WARNING("It doesn't seem to be responding.")
		if(DEAD)
			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"
	. += "*---------*"
	if(print_flavor_text())
		. += "[print_flavor_text()]"
	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "It [pose]"
