/client/verb/check_byond_membership()
	set name = "Check Byond Membership"
	set category = "OOC"

	if(get_byond_membership())
		to_chat(src, SPAN_NOTICE("Congratulations! You are a BYOND member and (depends on features of this server) might have some exclusive features!"))
		to_chat(src, SPAN_NOTICE("[get_byond_membership() == -1 ? "You have a lifetime membership." : "Membership days left: [get_byond_membership()]"]"))
	else
		to_chat(src, SPAN_NOTICE("Become a BYOND member to support the engine that makes this game possible. You also can get access to member-perks and features if this server has any. Only 10 bucks for 3 months! <a href=\"https://secure.byond.com/membership\">Click Here to find out more</a>."))

	var/list/perks
	for(var/modpack in SSmodpacks.loaded_modpacks)
		var/decl/modpack/M = SSmodpacks.loaded_modpacks[modpack]
		var/perk = M.get_membership_perks()
		if(perk)
			LAZYADD(perks, "<li>[perk]</li>")

	to_chat(src, "This server has [length(perks)] perk\s for membership[length(perks) ? ":<br><ul>[jointext(perks, "\n")]</ul>" : "."]")
