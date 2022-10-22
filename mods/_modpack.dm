/decl/modpack
	/// A string name for the modpack. Used for looking up other modpacks in init.
	var/name
	/// A string desc for the modpack. Can be used for modpack verb list as description.
	var/desc
	/// A string with authors of this modpack.
	var/author

	var/list/dreams //! A list of strings to be added to the random dream proc.

	var/list/credits_other           //! A list of strings that are used by the end of round credits roll.
	var/list/credits_adventure_names //! A list of strings that are used by the end of round credits roll.
	var/list/credits_crew_names      //! A list of strings that are used by the end of round credits roll.
	var/list/credits_holidays        //! A list of strings that are used by the end of round credits roll.
	var/list/credits_adjectives      //! A list of strings that are used by the end of round credits roll.
	var/list/credits_crew_outcomes   //! A list of strings that are used by the end of round credits roll.
	var/list/credits_topics          //! A list of strings that are used by the end of round credits roll.
	var/list/credits_nouns           //! A list of strings that are used by the end of round credits roll.

/decl/modpack/proc/get_player_panel_options(var/mob/M)
	return

/decl/modpack/proc/pre_initialize()
	if(!name)
		return "Modpack name is unset."

/decl/modpack/proc/initialize()
	return

/decl/modpack/proc/post_initialize()
	if(length(dreams))
		SSlore.dreams |= dreams
	if(length(credits_other))
		SSlore.credits_other |= credits_other
	if(length(credits_adventure_names))
		SSlore.credits_adventure_names |= credits_adventure_names
	if(length(credits_crew_names))
		SSlore.credits_crew_names |= credits_crew_names
	if(length(credits_holidays))
		SSlore.credits_holidays |= credits_holidays
	if(length(credits_adjectives))
		SSlore.credits_adjectives |= credits_adjectives
	if(length(credits_crew_outcomes))
		SSlore.credits_crew_outcomes |= credits_crew_outcomes
	if(length(credits_topics))
		SSlore.credits_topics |= credits_topics
	if(length(credits_nouns))
		SSlore.credits_nouns |= credits_nouns

/decl/modpack/proc/get_membership_perks()
	return

/client/verb/modpacks_list()
	set name = "Modpacks List"
	set category = "OOC"

	if(!mob || !SSmodpacks.initialized)
		return

	if(SSmodpacks.loaded_modpacks.len)
		. = "<hr><br><center><b><font size = 3>Modpacks List</font></b></center><br><hr><br>"
		for(var/modpack in SSmodpacks.loaded_modpacks)
			var/decl/modpack/M = SSmodpacks.loaded_modpacks[modpack]
			
			if(M.name)
				. += "<div class = 'statusDisplay'>"
				. += "<center><b>[M.name]</b></center>"
				
				if(M.desc || M.author)
					. += "<br>"
					if(M.desc)
						. += "<br>Description: [M.desc]"
					if(M.author)
						. += "<br><i>Author: [M.author]</i>"
				. += "</div><br>"

		var/datum/browser/popup = new(mob, "modpacks_list", "Modpacks List", 480, 580)
		popup.set_content(.)
		popup.open()
	else
		to_chat(src, SPAN_WARNING("This server does not include any modpacks."))
