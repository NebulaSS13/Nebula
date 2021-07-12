/datum/preferences
	var/gender = MALE					//gender of character (well duh)
	var/bodytype
	var/spawnpoint = "Default" 			//where this character will spawn (0-2).
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round

/datum/category_item/player_setup_item/physical/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/physical/basic/load_character(datum/pref_record_reader/R)
	pref.gender =         R.read("gender")
	pref.bodytype =       R.read("bodytype")
	pref.spawnpoint =     R.read("spawnpoint")
	pref.real_name =      R.read("real_name")
	pref.be_random_name = R.read("name_is_always_random")

/datum/category_item/player_setup_item/physical/basic/save_character(datum/pref_record_writer/W)
	W.write("gender",                pref.gender)
	W.write("bodytype",              pref.bodytype)
	W.write("spawnpoint",            pref.spawnpoint)
	W.write("real_name",             pref.real_name)
	W.write("name_is_always_random", pref.be_random_name)

/datum/category_item/player_setup_item/physical/basic/sanitize_character()

	var/decl/species/S  = get_species_by_key(pref.species) || get_species_by_key(global.using_map.default_species)
	pref.spawnpoint     = sanitize_inlist(pref.spawnpoint, spawntypes(), initial(pref.spawnpoint))
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
		pref.bodytype = bodytype.name

/datum/category_item/player_setup_item/physical/basic/content()

	. = list()
	. += "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a>"
	. += "<hr>"

	var/decl/species/S = get_species_by_key(pref.species)
	var/decl/bodytype/B = S.get_bodytype_by_name(pref.bodytype)
	. += "<b>Bodytype:</b> <a href='?src=\ref[src];bodytype=1'>[capitalize(B.name)]</a><br>"

	var/decl/pronouns/G = get_pronouns_by_gender(pref.gender)
	. += "<b>Pronouns:</b> <a href='?src=\ref[src];gender=1'>[capitalize(G.name)]</a><br>"

	. += "<b>Spawn point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/decl/species/S = get_species_by_key(pref.species)

	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))

			var/decl/cultural_info/check = GET_DECL(pref.cultural_info[TAG_CULTURE])
			var/new_name = check.sanitize_name(raw_name, pref.species)
			if(filter_block_message(user, new_name))
				return TOPIC_NOACTION

			if(new_name)
				pref.real_name = new_name
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
		var/decl/pronouns/new_gender = input(user, "Choose your character's pronouns:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in S.available_pronouns
		S = get_species_by_key(pref.species)
		if(istype(new_gender) && CanUseTopic(user) && (new_gender in S.available_pronouns))
			pref.gender = new_gender.name
			if(!(pref.f_style in S.get_facial_hair_styles(pref.gender)))
				ResetFacialHair()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["bodytype"])
		var/decl/bodytype/new_body = input(user, "Choose your character's bodytype:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in S.available_bodytypes
		S = get_species_by_key(pref.species)
		if(istype(new_body) && CanUseTopic(user) && (new_body in S.available_bodytypes))
			pref.bodytype = new_body.name
			if(new_body.associated_gender) // Set to default for male/female to avoid confusing people
				pref.gender = new_body.associated_gender
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes())
			spawnkeys += spawntype
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !spawntypes()[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	return ..()
