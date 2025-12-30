/mob/living/silicon/ai/examined_by(mob/user, distance, infix, suffix)
	. = ..()
	user?.showLaws(src)

/mob/living/silicon/ai/get_other_examine_strings(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	. = ..()
	if(stat == DEAD)
		. += "<span class='deadsay'>It appears to be powered-down.</span>"
	else
		var/brute_damage = get_damage(BRUTE)
		if (brute_damage >= 30)
			. += SPAN_WARNING("<B>It looks severely dented!</B>")
		else if(brute_damage)
			. += SPAN_WARNING("It looks slightly dented.")
		var/burn_damage = get_damage(BURN)
		if(burn_damage >= 30)
			. += SPAN_WARNING("<B>Its casing is melted and heat-warped!</B>")
		else if(burn_damage)
			. += SPAN_WARNING("It looks slightly charred.")
		if (!has_power())
			var/oxy_damage = get_damage(OXY)
			if (oxy_damage > 175)
				. += SPAN_WARNING("<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>")
			else if(oxy_damage > 100)
				. += SPAN_WARNING("<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>")
			else
				. += SPAN_WARNING("It seems to be running on backup power.")
		if (stat == UNCONSCIOUS)
			. += SPAN_WARNING("It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".")
	. += "*---------*"

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/observer/ghost/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
