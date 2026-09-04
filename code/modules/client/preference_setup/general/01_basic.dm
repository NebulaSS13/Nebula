/datum/preferences
	var/gender = MALE					//gender of character (well duh)
	var/bodytype
	var/spawnpoint = "Default" 			//where this character will spawn (0-2).
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round

// This must always return a decl, NEVER null.
/datum/preferences/proc/get_bodytype_decl()
	RETURN_TYPE(/decl/bodytype)
	var/decl/species/species_decl = get_species_decl()
	return species_decl.get_bodytype_by_name(bodytype) || species_decl.default_bodytype

/datum/category_item/player_setup_item/physical
	abstract_type = /datum/category_item/player_setup_item/physical

/datum/category_item/player_setup_item/physical/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/physical/basic/apply_post_snapshot_preferences(mob/living/human/character, is_preview_copy = FALSE)
	character.set_gender(pref.gender)

/datum/category_item/player_setup_item/physical/basic/preload_character(datum/pref_record_reader/R)
	pref.gender =         R.read("gender")
	pref.bodytype =       R.read("bodytype")

/datum/category_item/player_setup_item/physical/basic/load_character(datum/pref_record_reader/R)
	pref.real_name =      R.read("real_name")
	pref.be_random_name = R.read("name_is_always_random")
	var/decl/spawnpoint/loaded_spawnpoint = decls_repository.get_decl_by_id_or_var(R.read("spawnpoint"), /decl/spawnpoint)
	if(istype(loaded_spawnpoint) && (loaded_spawnpoint in global.using_map.allowed_latejoin_spawns))
		pref.spawnpoint = loaded_spawnpoint.type
	else
		pref.spawnpoint = global.using_map.default_spawn

/datum/category_item/player_setup_item/physical/basic/save_character(datum/pref_record_writer/writer)
	writer.write("gender",                pref.gender)
	writer.write("bodytype",              pref.bodytype)
	writer.write("real_name",             pref.real_name)
	writer.write("name_is_always_random", pref.be_random_name)
	var/decl/spawnpoint/spawnpoint = GET_DECL(pref.spawnpoint)
	if(spawnpoint)
		writer.write("spawnpoint", spawnpoint.uid)

/datum/category_item/player_setup_item/physical/basic/sanitize_character()

	var/valid_spawn = FALSE
	for(var/decl/spawnpoint/spawnpoint as anything in global.using_map.allowed_latejoin_spawns)
		if(pref.spawnpoint == spawnpoint.type)
			valid_spawn = TRUE
			break
	if(!valid_spawn)
		pref.spawnpoint = global.using_map.default_spawn

	var/decl/species/S = pref.get_species_decl()
	pref.be_random_name = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

	var/decl/pronouns/pronouns
	if(!pref.gender)
		pronouns = pick(S.available_pronouns)
	else
		pronouns = get_pronouns_by_gender(pref.gender)
		if(!istype(pronouns) || !(pronouns in S.available_pronouns))
			pronouns = pick(S.available_pronouns)
	pref.gender = pronouns.name

	var/decl/bodytype/bodytype = S.get_bodytype_by_name(pref.bodytype)
	if(!istype(bodytype) || !(bodytype in S.available_bodytypes))
		bodytype = S.get_bodytype_by_pronouns(pronouns)
		pref.set_bodytype(bodytype.name)

/datum/category_item/player_setup_item/physical/basic/populate_mob_snapshot(datum/mob_snapshot/snapshot, is_preview_copy = FALSE)
	snapshot.root_bodytype = pref.get_bodytype_decl()
	var/new_real_name = pref.real_name
	if(pref.be_random_name)
		var/decl/background_detail/background = pref.get_background_datum_by_flag(BACKGROUND_FLAG_NAMING)
		if(background)
			new_real_name = background.get_random_cultural_name(gender = pref.gender, species = pref.species)
	if(get_config_value(/decl/config/toggle/humans_need_surnames))
		var/firstspace = findtext(new_real_name, " ")
		var/name_length = length(new_real_name)
		if(!firstspace)	//we need a surname
			new_real_name += " [pick(global.using_map.last_names)]"
		else if(firstspace == name_length) // someone tried to cheese it by putting a space at the end
			new_real_name += "[pick(global.using_map.last_names)]"
	snapshot.real_name = new_real_name

/datum/category_item/player_setup_item/physical/basic/content()

	. = list()
	. += "<b>Name:</b> "
	. += "<a href='byond://?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "<a href='byond://?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='byond://?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a>"
	. += "<hr>"

	. += "<b>Bodytype:</b> "
	var/decl/species/S = pref.get_species_decl()
	for(var/decl/bodytype/B in S.available_bodytypes)
		if(B.name == pref.bodytype)
			. += "<span class='linkOn'>[capitalize(B.pref_name)]</span>"
		else
			. += "<a href='byond://?src=\ref[src];bodytype=\ref[B]'>[capitalize(B.pref_name)]</a>"

	. += "<br><b>Pronouns:</b> "
	for(var/decl/pronouns/pronouns in S.available_pronouns)
		if(pronouns.name == pref.gender)
			. += "<span class='linkOn'>[pronouns.pronoun_string]</span>"
		else
			. += "<a href='byond://?src=\ref[src];gender=\ref[pronouns]'>[pronouns.pronoun_string]</a>"

	. += "<br><b>Spawnpoint</b>:"
	var/decl/spawnpoint/spawnpoint = GET_DECL(pref.spawnpoint)
	for(var/decl/spawnpoint/allowed_spawnpoint in global.using_map.allowed_latejoin_spawns)
		if(spawnpoint == allowed_spawnpoint)
			. += "<span class='linkOn'>[allowed_spawnpoint.name]</span>"
		else
			. += "<a href='byond://?src=\ref[src];spawnpoint=\ref[allowed_spawnpoint]'>[allowed_spawnpoint.name]</a>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/decl/species/S = pref.get_species_decl()

	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))

			var/decl/background_detail/check = pref.get_background_datum_by_flag(BACKGROUND_FLAG_NAMING)
			if(!istype(check))
				return TOPIC_NOACTION

			var/new_name = check.sanitize_background_name(raw_name, pref.species)
			if(filter_block_message(user, new_name))
				return TOPIC_NOACTION

			if(new_name)
				pref.real_name = new_name
				// Update comments record, if it exists.
				if(pref.comments_record_id)
					var/datum/character_information/comments = SScharacter_info.get_record(pref.comments_record_id, TRUE)
					if(comments)
						comments.char_name = pref.real_name
						comments.update_fields()
				return TOPIC_REFRESH
			else
				to_chat(user, "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>")
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_name = pref.get_random_name()
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list["gender"])
		var/decl/pronouns/new_gender = locate(href_list["gender"])
		if(istype(new_gender) && CanUseTopic(user) && (new_gender in S.available_pronouns))
			pref.gender = new_gender.name
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["bodytype"])
		var/decl/bodytype/new_body = locate(href_list["bodytype"])
		if(istype(new_body) && CanUseTopic(user) && (new_body in S.available_bodytypes))
			pref.set_bodytype(new_body.name)
			if(get_config_value(/decl/config/toggle/on/cisnormativity) && new_body.associated_gender) // Let servers stuck in the 2010s set bodytype default to avoid "confusing" people
				pref.gender = new_body.associated_gender
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["spawnpoint"])
		var/decl/spawnpoint/choice = locate(href_list["spawnpoint"])
		if(!istype(choice) || !CanUseTopic(user) || !(choice in global.using_map.allowed_latejoin_spawns))
			return TOPIC_NOACTION
		pref.spawnpoint = choice.type
		return TOPIC_REFRESH

	return ..()
