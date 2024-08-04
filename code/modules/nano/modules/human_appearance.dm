/datum/nano_module/appearance_changer
	name = "Appearance Editor"
	available_to_ai = FALSE
	var/flags = APPEARANCE_ALL_HAIR
	var/mob/living/human/owner = null
	var/check_whitelist
	var/list/whitelist
	var/list/blacklist

/datum/nano_module/appearance_changer/New(var/location, var/mob/living/human/H, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list())
	..()
	owner = H
	src.check_whitelist = check_species_whitelist
	src.whitelist = species_whitelist
	src.blacklist = species_blacklist

/datum/nano_module/appearance_changer/Topic(ref, href_list, var/datum/topic_state/state = global.default_topic_state)
	if(..())
		return 1

	if(href_list["race"] && can_change(APPEARANCE_RACE) && (href_list["race"] in owner.generate_valid_species(check_whitelist, whitelist, blacklist)) && owner.change_species(href_list["race"]))
		return TRUE

	if(href_list["gender"] && can_change(APPEARANCE_GENDER))
		var/decl/pronouns/pronouns = get_pronouns_by_gender(href_list["gender"])
		if(istype(pronouns) && (pronouns in owner.species.available_pronouns) && owner.set_gender(pronouns.name, TRUE))
			return TRUE

	if(href_list["bodytype"] && can_change(APPEARANCE_BODY))
		var/decl/species/species = owner.get_species()
		var/decl/bodytype/B = species.get_bodytype_by_name(href_list["bodytype"])
		if(istype(B) && (B in owner.species.available_bodytypes) && owner.set_bodytype(B))
			return TRUE

	if(href_list["skin_tone"] && can_change_skin_tone())
		var/decl/bodytype/root_bodytype = owner.get_bodytype()
		var/new_s_tone = input(usr, "Choose your character's skin-tone:\n1 (lighter) - [root_bodytype.max_skin_tone()] (darker)", "Skin Tone", -owner.skin_tone + 35) as num|null
		root_bodytype = owner.get_bodytype() // gotta make sure just in case, since input sleeps
		if(isnum(new_s_tone) && can_still_topic(state) && root_bodytype.appearance_flags & HAS_SKIN_TONE_NORMAL)
			new_s_tone = 35 - max(min(round(new_s_tone), root_bodytype.max_skin_tone()), 1)
			return owner.change_skin_tone(new_s_tone)

	if(href_list["skin_color"] && can_change_skin_color())
		var/new_skin = input(usr, "Choose your character's skin colour: ", "Skin Color", owner.get_skin_colour()) as color|null
		if(new_skin && can_still_topic(state) && owner.set_skin_colour(new_skin))
			return TRUE

	if(href_list["hair"])
		var/decl/sprite_accessory/hair = locate(href_list["hair"])
		if(can_change(APPEARANCE_HAIR) && istype(hair) && (hair.type in owner.get_species()?.get_available_accessory_types(owner.get_bodytype(), SAC_HAIR)) && SET_HAIR_STYLE(owner, hair.type, FALSE))
			owner.update_hair() // No idea why this is necessary, setting the accessory above should be fine.
			return TRUE

	if(href_list["hair_color"] && can_change(APPEARANCE_HAIR_COLOR))
		var/new_hair_color = input("Please select hair color.", "Hair Color", GET_HAIR_COLOR(owner)) as color|null
		if(new_hair_color && can_still_topic(state) && SET_HAIR_COLOR(owner, new_hair_color, FALSE))
			return TRUE

	if(href_list["facial_hair"])
		var/decl/sprite_accessory/facial_hair = locate(href_list["facial_hair"])
		if(can_change(APPEARANCE_FACIAL_HAIR) && istype(facial_hair) && (facial_hair.type in owner.get_species()?.get_available_accessory_types(owner.get_bodytype(), SAC_FACIAL_HAIR)) && SET_FACIAL_HAIR_STYLE(owner, facial_hair.type, FALSE))
			owner.update_hair() // No idea why this is necessary, setting the accessory above should be fine.
			return TRUE

	if(href_list["facial_hair_color"] && can_change(APPEARANCE_FACIAL_HAIR_COLOR))
		var/new_facial = input("Please select facial hair color.", "Facial Hair Color", GET_FACIAL_HAIR_COLOR(owner)) as color|null
		if(new_facial && can_still_topic(state) && SET_FACIAL_HAIR_COLOR(owner, new_facial, FALSE))
			return TRUE

	if(href_list["eye_color"])
		if(can_change(APPEARANCE_EYE_COLOR))
			var/new_eyes = input("Please select eye color.", "Eye Color", owner.get_eye_colour()) as color|null
			if(new_eyes && can_still_topic(state) && owner.set_eye_colour(new_eyes))
				return TRUE

	return FALSE

/datum/nano_module/appearance_changer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	if(!owner || !owner.species)
		return

	var/list/data = host.initial_data()
	data["specimen"] = owner.species.name
	data["gender"] = owner.gender
	data["change_race"] = can_change(APPEARANCE_RACE)
	if(data["change_race"])
		var/species[0]
		for(var/specimen in owner.generate_valid_species(check_whitelist, whitelist, blacklist))
			species[++species.len] =  list("specimen" = specimen)
		data["species"] = species

	data["change_gender"] = can_change(APPEARANCE_GENDER)
	if(data["change_gender"])
		var/genders[0]
		for(var/decl/pronouns/pronouns as anything in owner.species.available_pronouns)
			genders[++genders.len] =  list("gender_name" = pronouns.pronoun_string, "gender_key" = pronouns.name)
		data["genders"] = genders

	data["bodytype"] = capitalize(owner.get_bodytype().name)
	data["change_bodytype"] = can_change(APPEARANCE_BODY)
	if(data["change_bodytype"])
		var/bodytypes[0]
		for(var/decl/bodytype/B as anything in owner.species.available_bodytypes)
			bodytypes += capitalize(B.name)
		data["bodytypes"] = bodytypes

	data["change_skin_tone"] = can_change_skin_tone()
	data["change_skin_color"] = can_change_skin_color()
	data["change_eye_color"] = can_change(APPEARANCE_EYE_COLOR)
	data["change_hair"] = can_change(APPEARANCE_HAIR)

	if(data["change_hair"])
		var/hair_styles[0]
		for(var/hair_style in owner.get_species()?.get_available_accessory_types(owner.get_bodytype(), SAC_HAIR))
			var/decl/sprite_accessory/hair_decl = GET_DECL(hair_style)
			hair_styles[++hair_styles.len] = list("hairstyle" = hair_decl.name, "ref" = "\ref[hair_decl]")
		data["hair_styles"] = hair_styles
		var/hairstyle = GET_HAIR_STYLE(owner)
		var/decl/sprite_accessory/hair = GET_DECL(hairstyle)
		data["hair_style"] = hair.name

	data["change_facial_hair"] = can_change(APPEARANCE_FACIAL_HAIR)
	if(data["change_facial_hair"])
		var/facial_hair_styles[0]
		for(var/facial_hair_style in owner.get_species()?.get_available_accessory_types(owner.get_bodytype(), SAC_FACIAL_HAIR))
			var/decl/sprite_accessory/facial_hair_decl = GET_DECL(facial_hair_style)
			facial_hair_styles[++facial_hair_styles.len] = list("facialhairstyle" = facial_hair_decl.name, "ref" = "\ref[facial_hair_decl]")
		data["facial_hair_styles"] = facial_hair_styles
		var/facial_hairstyle = GET_FACIAL_HAIR_STYLE(owner)
		var/decl/sprite_accessory/facial_hair = GET_DECL(facial_hairstyle)
		data["facial_hair_style"] = facial_hair.name

	data["change_hair_color"] = can_change(APPEARANCE_HAIR_COLOR)
	data["change_facial_hair_color"] = can_change(APPEARANCE_FACIAL_HAIR_COLOR)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "appearance_changer.tmpl", "[src]", 800, 450, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/appearance_changer/proc/can_change(var/flag)
	return owner && (flags & flag)

/datum/nano_module/appearance_changer/proc/can_change_skin_tone()
	return owner && (flags & APPEARANCE_SKIN) && owner.get_bodytype().appearance_flags & HAS_A_SKIN_TONE

/datum/nano_module/appearance_changer/proc/can_change_skin_color()
	return owner && (flags & APPEARANCE_SKIN) && owner.get_bodytype().appearance_flags & HAS_SKIN_COLOR
