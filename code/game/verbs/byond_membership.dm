/client/verb/check_byond_membership()
	set name = "Check Byond Membership"
	set category = "OOC"

	var/list/perks
	for(var/modpack in SSmodpacks.loaded_modpacks)
		var/decl/modpack/M = SSmodpacks.loaded_modpacks[modpack]
		var/perk = M.get_membership_perks()
		if(perk)
			LAZYADD(perks, "<li>[perk]</li>")

	var/membership_days = get_byond_membership()
	if(membership_days == 0)
		to_chat(src, SPAN_NOTICE("<a href=\"https://secure.byond.com/membership\">Become a BYOND member</a> to support the engine that makes this game possible!"))
		if(LAZYLEN(perks))
			to_chat(src, SPAN_NOTICE("Membership grants access to [length(perks)] perk\s:<br><ul>[jointext(perks, "\n")]</ul>"))
	else
		if(membership_days == -1)
			to_chat(src, SPAN_NOTICE("Thanks for supporting BYOND! You have a lifetime membership."))
		else
			to_chat(src, SPAN_NOTICE("Thanks for supporting BYOND! You have [get_byond_membership()] day\s of membership left."))
		if(LAZYLEN(perks))
			to_chat(src, SPAN_NOTICE("You have access to [length(perks)] perk\s:<br><ul>[jointext(perks, "\n")]</ul>"))
