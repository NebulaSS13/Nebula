/mob/living/carbon/human
	var/_skin_colour

/mob/living/carbon/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/location = src, var/mob/user = src, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/datum/topic_state/state = global.default_topic_state)
	var/datum/nano_module/appearance_changer/AC = new(location, src, check_species_whitelist, species_whitelist, species_blacklist)
	AC.flags = flags
	AC.ui_interact(user, state = state)

/mob/living/carbon/human/get_skin_colour()
	return _skin_colour

/mob/living/carbon/human/set_skin_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		_skin_colour = new_color
		if(!skip_update)
			force_update_limbs()
			update_body()

/mob/living/carbon/human/proc/change_species(var/new_species, var/new_bodytype = null)
	if(!new_species)
		return

	if(species == new_species)
		return

	if(!(new_species in get_all_species()))
		return

	set_species(new_species, new_bodytype)
	dna.ready_dna(src)

	//Handle spawning stuff
	species.handle_pre_spawn(src)
	UpdateAppearance()
	apply_species_appearance()
	apply_bodytype_appearance()
	apply_species_cultural_info()
	species.handle_post_spawn(src)
	reset_blood()
	full_prosthetic = null
	apply_species_inventory_restrictions()

	var/decl/special_role/antag = mind && player_is_antag(mind)
	if (antag && antag.required_language)
		add_language(antag.required_language)
		set_default_language(antag.required_language)
	reset_hair()
	try_refresh_visible_overlays()
	return 1

/mob/living/carbon/human/set_gender(var/new_gender, var/update_body = FALSE)
	. = ..()
	if(. && update_body)
		reset_hair()
		update_body()
		update_dna()

/mob/living/carbon/human/proc/randomize_gender()
	var/decl/pronouns/pronouns = pick(species.available_pronouns)
	set_gender(pronouns.name, TRUE)

/mob/living/carbon/human/proc/reset_hair()
	var/list/valid_hairstyles = get_valid_hairstyle_types()
	if(length(valid_hairstyles))
		SET_HAIR_STYLE(src, pick(valid_hairstyles), TRUE)
	else
		//this shouldn't happen
		SET_HAIR_STYLE(src, get_bodytype()?.default_h_style || /decl/sprite_accessory/hair/bald, TRUE)

	var/list/valid_facial_hairstyles =  get_valid_facial_hairstyle_types()
	if(length(valid_facial_hairstyles))
		SET_FACIAL_HAIR_STYLE(src, pick(valid_facial_hairstyles), TRUE)
	else
		//this shouldn't happen
		SET_FACIAL_HAIR_STYLE(src, get_bodytype()?.default_f_style || /decl/sprite_accessory/facial_hair/shaved, TRUE)

	update_hair()

/mob/living/carbon/human/proc/change_skin_tone(var/tone)
	if(skin_tone == tone || !(get_bodytype().appearance_flags & HAS_A_SKIN_TONE))
		return
	skin_tone = tone
	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/update_dna()
	check_dna()
	dna.ready_dna(src)

/mob/living/carbon/human/proc/generate_valid_species(var/check_whitelist = 1, var/list/whitelist = list(), var/list/blacklist = list())
	var/list/valid_species = new()
	for(var/current_species_name in get_all_species())
		var/decl/species/current_species = get_species_by_key(current_species_name)

		if(check_whitelist) //If we're using the whitelist, make sure to check it!
			if((current_species.spawn_flags & SPECIES_IS_RESTRICTED) && !check_rights(R_ADMIN, 0, src))
				continue
			if(!is_alien_whitelisted(src, current_species))
				continue
		if(whitelist.len && !(current_species_name in whitelist))
			continue
		if(blacklist.len && (current_species_name in blacklist))
			continue

		valid_species += current_species_name

	return valid_species

/mob/living/carbon/human/proc/get_valid_hairstyle_types()
	return species.get_hair_style_types(get_bodytype())

/mob/living/carbon/human/proc/get_valid_facial_hairstyle_types()
	return species.get_facial_hair_style_types(get_bodytype())

/mob/living/carbon/human/proc/force_update_limbs()
	for(var/obj/item/organ/external/O in get_external_organs())
		O.sync_colour_to_human(src)
	update_body(0)
