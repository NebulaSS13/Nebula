/datum/category_item/player_setup_item/background/species
	name = "Species"
	sort_order = 1
	var/hide_species = TRUE

/datum/category_item/player_setup_item/background/species/save_character(datum/pref_record_writer/W)
	W.write("species", pref.species)

/datum/category_item/player_setup_item/background/species/load_character(datum/pref_record_reader/R)
	pref.species = R.read("species") 

/datum/category_item/player_setup_item/background/species/sanitize_character()
	. = ..()
	sanitize_species()

/datum/category_item/player_setup_item/background/species/proc/sanitize_species()

	var/decl/species/mob_species
	if(!pref.species)
		mob_species = GET_DECL(global.using_map.default_species)
		pref.species = mob_species.name
	else
		mob_species = get_species_by_key(pref.species)

	var/decl/pronouns/pronouns = get_pronouns_by_gender(pref.gender)
	if(!istype(pronouns) || !(pronouns in mob_species.available_pronouns))
		pronouns = mob_species.available_pronouns[1]
		pref.gender = pronouns.name

	pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)
	pref.cultural_info = mob_species.default_cultural_info.Copy()

	if(!has_flag(get_species_by_key(pref.species), HAS_UNDERWEAR))
		pref.all_underwear.Cut()

/datum/category_item/player_setup_item/background/species/proc/has_flag(var/decl/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/background/species/content(var/mob/user)
	var/decl/species/current_species = get_species_by_key(pref.species)
	var/list/prefilter = get_playable_species()
	var/list/playables = list()
	
	for(var/s in prefilter)
		if(!check_rights(R_ADMIN, 0) && config.usealienwhitelist)
			var/decl/species/checking_species = get_species_by_key(s)
			if(!(checking_species.spawn_flags & SPECIES_CAN_JOIN))
				continue
			else if((checking_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),checking_species))
				continue
		playables += s

	. = list()
	. += "<tr><td colspan=3><center><h3>Species</h3></td></tr>"
	. += "</center></td></tr>"
	. += "<tr><td colspan=3><center>"
	for(var/s in get_playable_species())
		var/decl/species/list_species = get_species_by_key(s)
		if(pref.species == list_species.name)
			. += "<span class='linkOn'>[list_species.name]</span> "
		else
			. += "<a href='?src=\ref[src];set_species=[list_species.name]'>[list_species.name]</a> "
	. += "</center><hr/></td></tr>"
	. += "<tr><td width = '200px'>"
	. += "<center>[current_species.get_description() || "No additional details."]</center>"
	. += "</td>"
	. += "</table><hr>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/background/species/OnTopic(var/href,var/list/href_list, var/mob/user)

	var/decl/species/mob_species = get_species_by_key(pref.species)
	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TOPIC_REFRESH

	else if(href_list["set_species"])

		var/choice = href_list["set_species"]
		if(choice != pref.species)

			pref.species = choice
			sanitize_species()
			prune_occupation_prefs()

			//reset hair colour and skin colour
			ResetAllHair()
			pref.hair_colour = COLOR_BLACK
			pref.skin_tone = 0
			pref.body_markings.Cut() // Basically same as above.
			mob_species.handle_post_species_pref_set(pref)

			return TOPIC_REFRESH_UPDATE_PREVIEW

	. = ..()
