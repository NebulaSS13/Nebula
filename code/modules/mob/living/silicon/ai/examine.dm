/mob/living/silicon/ai/show_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	. = ..()

	var/msg = ""
	if (src.stat == DEAD)
		msg += "<span class='deadsay'>It appears to be powered-down.</span>\n"
	else
		msg += "<span class='warning'>"
		if (src.get_damage(BRUTE))
			if (src.get_damage(BRUTE) < 30)
				msg += "It looks slightly dented.\n"
			else
				msg += "<B>It looks severely dented!</B>\n"
		if (src.get_damage(BURN))
			if (src.get_damage(BURN) < 30)
				msg += "It looks slightly charred.\n"
			else
				msg += "<B>Its casing is melted and heat-warped!</B>\n"
		if (!has_power())
			if (src.get_damage(OXY) > 175)
				msg += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>\n"
			else if(src.get_damage(OXY) > 100)
				msg += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>\n"
			else
				msg += "It seems to be running on backup power.\n"

		if (src.stat == UNCONSCIOUS)
			msg += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		msg += "</span>"
	msg += "*---------*"
	to_chat(user, msg)
	user.showLaws(src)
	return

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/observer/ghost/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
