/mob/living/human
	var/_skin_colour

/mob/living/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/location = src, var/mob/user = src, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/datum/topic_state/state = global.default_topic_state)
	var/datum/nano_module/appearance_changer/AC = new(location, src, check_species_whitelist, species_whitelist, species_blacklist)
	AC.flags = flags
	AC.ui_interact(user, state = state)

/mob/living/human/get_skin_colour()
	return _skin_colour

/mob/living/human/set_skin_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		_skin_colour = new_color
		if(!skip_update)
			force_update_limbs()
			update_body()

/mob/living/human/proc/change_species(var/new_species, var/new_bodytype = null)

	if(!new_species)
		return

	if(species?.name == new_species)
		return

	if(!(new_species in get_all_species()))
		return

	set_species(new_species, new_bodytype)

	//Handle spawning stuff
	species.handle_pre_spawn(src)
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
	try_refresh_visible_overlays()
	return 1

/mob/living/human/set_gender(var/new_gender, var/update_body = FALSE)
	. = ..()
	if(. && update_body)
		update_body()

/mob/living/human/proc/randomize_gender()
	var/decl/pronouns/pronouns = pick(species.available_pronouns)
	set_gender(pronouns.name, TRUE)

/mob/living/human/proc/reset_hair()
	var/decl/bodytype/root_bodytype = get_bodytype()
	var/decl/sprite_accessory_category/hair/hair_category = GET_DECL(SAC_HAIR)
	var/list/valid_hairstyles = species?.get_available_accessories(root_bodytype, SAC_HAIR)
	if(length(valid_hairstyles))
		var/body_default_hairstyles = LAZYACCESS(root_bodytype?.default_sprite_accessories, SAC_HAIR)
		// Forgive us, but we need to set both hair color AND style at the same time...
		set_organ_sprite_accessory_by_category(pick(valid_hairstyles), SAC_HAIR, GET_HAIR_COLOUR(src) || body_default_hairstyles?[body_default_hairstyles[1]] || hair_category.default_accessory_color, TRUE, TRUE, BP_HEAD, TRUE)
	else
		//this shouldn't happen
		var/new_hair = LAZYACCESS(root_bodytype?.default_sprite_accessories, SAC_HAIR) || /decl/sprite_accessory/hair/bald
		if(new_hair)
			set_organ_sprite_accessory_by_category(new_hair[1], SAC_HAIR, new_hair[new_hair[1]] || hair_category.default_accessory_color, TRUE, TRUE, BP_HEAD, TRUE)

	var/decl/sprite_accessory_category/facial_hair/facial_hair_category = GET_DECL(SAC_FACIAL_HAIR)
	var/list/valid_facial_hairstyles = species?.get_available_accessories(root_bodytype, SAC_FACIAL_HAIR)
	if(length(valid_facial_hairstyles))
		var/body_default_facial_hairstyles = LAZYACCESS(root_bodytype?.default_sprite_accessories, SAC_FACIAL_HAIR)
		set_organ_sprite_accessory_by_category(pick(valid_facial_hairstyles), SAC_FACIAL_HAIR, GET_FACIAL_HAIR_COLOUR(src) || body_default_facial_hairstyles?[body_default_facial_hairstyles[1]] || facial_hair_category.default_accessory_color, TRUE, TRUE, BP_HEAD, TRUE)
	else
		//this shouldn't happen
		var/new_facial_hair = LAZYACCESS(root_bodytype?.default_sprite_accessories, SAC_FACIAL_HAIR) || /decl/sprite_accessory/facial_hair/shaved
		if(new_facial_hair)
			set_organ_sprite_accessory_by_category(new_facial_hair[1], SAC_FACIAL_HAIR, new_facial_hair[new_facial_hair[1]] || facial_hair_category.default_accessory_color, TRUE, TRUE, BP_HEAD, TRUE)

	update_hair()

/mob/living/human/proc/change_skin_tone(var/tone)
	if(skin_tone == tone || !(get_bodytype().appearance_flags & HAS_A_SKIN_TONE))
		return
	skin_tone = tone
	force_update_limbs()
	update_body()
	return 1

/mob/living/human/proc/generate_valid_species(var/check_whitelist = 1, var/list/whitelist = list(), var/list/blacklist = list())
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
