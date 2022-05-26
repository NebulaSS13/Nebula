/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 3

	var/datum/paiCandidate/candidate

/datum/category_item/player_setup_item/player_global/pai/load_preferences(datum/pref_record_reader/R)
	if(!candidate)
		candidate = new()

	if(!preference_mob())
		return

	candidate.savefile_load(preference_mob())
	pref.update_pai_preview(candidate.chassis)

/datum/category_item/player_setup_item/player_global/pai/save_preferences(datum/pref_record_writer/W)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/content(var/mob/user)
	if(!candidate)
		candidate = new()

	pref.update_pai_preview(candidate.chassis)

	. += "<b>pAI:</b><br>"
	if(!candidate)
		log_debug("[user] pAI prefs have a null candidate var.")
		return .
	. += "Name: <a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>"
	. += "Description: <a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>"
	. += "Role: <a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>"
	. += "OOC Comments: <a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>"
	. += "<div>Chassis: <a href='?src=\ref[src];option=chassis'>[candidate.chassis]</a><br>"
	. += "<div>Say Verb: <a href='?src=\ref[src];option=say'>[candidate.say_verb]</a><br>"

/datum/category_item/player_setup_item/player_global/pai/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["option"])
		var/t
		. = TOPIC_REFRESH
		switch(href_list["option"])
			if("name")
				t = sanitize_name(input(user, "Enter a name for your pAI", "Global Preference", candidate.name) as text|null, MAX_NAME_LEN, 1)
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				t = input(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description)) as message|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				t = input(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role)) as text|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				t = input(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments)) as message
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)
			if("chassis")
				t = input(usr,"What would you like to use for your mobile chassis icon?") as null|anything in global.possible_chassis
				if(!isnull(t) && CanUseTopic(user))
					candidate.chassis = t
				pref.update_pai_preview(candidate.chassis)
				. = TOPIC_HARD_REFRESH
			if("say")
				t = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in global.possible_say_verbs
				if(!isnull(t) && CanUseTopic(user))
					candidate.say_verb = t
		return

	return ..()

/datum/preferences/proc/update_pai_preview(var/chassis)
	var/mutable_appearance/MA = mutable_appearance(global.possible_chassis[chassis], ICON_STATE_WORLD)
	MA.invisibility = 0 // Byond makes pAI icon with visibility = 0; this is the workaround
	update_character_preview_mannequin(MA)
	update_character_preview_background()
