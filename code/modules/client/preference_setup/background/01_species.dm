/datum/category_item/player_setup_item/background/species
	name = "Species"
	sort_order = 1
	var/hide_species = TRUE

/datum/category_item/player_setup_item/background/species/save_character(datum/pref_record_writer/W)
	W.write("species", pref.species)

/datum/category_item/player_setup_item/background/species/preload_character(datum/pref_record_reader/R)
	pref.species = R.read("species")

/datum/category_item/player_setup_item/background/species/sanitize_character()
	. = ..()
	sanitize_species()

/datum/category_item/player_setup_item/background/species/proc/sanitize_species()

	if(!pref.species || !get_species_by_key(pref.species))
		pref.set_species(global.using_map.default_species)
	var/decl/species/mob_species = get_species_by_key(pref.species)
	var/decl/bodytype/mob_bodytype = mob_species.get_bodytype_by_name(pref.bodytype) || mob_species.default_bodytype
	var/decl/pronouns/pronouns = get_pronouns_by_gender(pref.gender)
	if(!istype(pronouns) || !(pronouns in mob_species.available_pronouns))
		pronouns = mob_species.available_pronouns[1]
		pref.gender = pronouns.name

	pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)

	if(pref.all_underwear && !(mob_bodytype.appearance_flags & HAS_UNDERWEAR))
		pref.all_underwear.Cut()

/datum/category_item/player_setup_item/background/species/content(var/mob/user)
	var/decl/species/current_species = get_species_by_key(pref.species)
	var/list/prefilter = get_playable_species()
	var/list/playables = list()

	for(var/s in prefilter)
		if(!check_rights(R_ADMIN, 0) && get_config_value(/decl/config/toggle/use_alien_whitelist))
			var/decl/species/checking_species = get_species_by_key(s)
			if(!(checking_species.spawn_flags & SPECIES_CAN_JOIN))
				continue
			else if((checking_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),checking_species))
				continue
		playables += s

	. = list()
	. += "<table width = '100%'>"
	. += "<tr><td colspan=3><center><h3>Species</h3></center></td></tr>"
	. += "<tr><td colspan=3><center>"
	for(var/s in get_playable_species())
		var/decl/species/list_species = get_species_by_key(s)
		if(pref.species == list_species.name)
			. += "<span class='linkOn'>[list_species.name]</span> "
		else
			. += "<a href='byond://?src=\ref[src];set_species=[list_species.name]'>[list_species.name]</a> "
	. += "</center><hr/></td></tr>"

	. += "<tr>"

	var/icon/use_preview_icon = current_species.get_preview_icon()
	if(use_preview_icon)
		send_rsc(user, use_preview_icon, current_species.preview_icon_path)
		. += "<td width = '200px' align='center'><img src='[current_species.preview_icon_path]' width='[current_species.preview_icon_width]px' height='[current_species.preview_icon_height]px'></td>"
	else
		. += "<td width = '200px' align='center'>No preview available.</td>"

	var/desc = current_species.description ? "<h3>Species Summary</h3><p>[current_species.description]</p>" : null
	if(current_species.roleplay_summary)
		desc = "[desc]<h3>Roleplaying Summary</h3><p>[current_species.roleplay_summary]</p>"

	if(hide_species && length(desc) > 200)
		desc = "[copytext(desc, 1, 194)] <small>\[...\]</small>"
	. += "<td width>[desc]</td>"
	. += "<td width = '50px'><a href='byond://?src=\ref[src];toggle_species_verbose=1'>[hide_species ? "Expand" : "Collapse"]</a></td>"

	. += "</tr>"

	. += "</table><hr>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/background/species/OnTopic(var/href,var/list/href_list, var/mob/user)

	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TOPIC_REFRESH

	else if(href_list["set_species"])

		var/choice = href_list["set_species"]
		if(choice != pref.species)
			pref.set_species(choice)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	. = ..()
