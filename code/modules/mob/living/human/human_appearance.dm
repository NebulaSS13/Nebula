/mob/living/human
	var/_skin_colour

/mob/living/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/location = src, var/mob/user = src, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/datum/topic_state/state = global.default_topic_state)
	var/datum/nano_module/appearance_changer/AC = new(location, src, check_species_whitelist, species_whitelist, species_blacklist)
	AC.flags = flags
	AC.ui_interact(user, state = state)

/mob/living/human/get_skin_colour()
	if(get_bodytype()?.appearance_flags & HAS_SKIN_COLOR)
		return _skin_colour
	return null

/mob/living/human/set_skin_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		_skin_colour = new_color
		if(!skip_update)
			force_update_limbs()
			update_body()

/mob/living/human/proc/change_species(var/new_species, var/new_bodytype = null)

	if(!new_species)
		return

	if(species?.uid == new_species)
		return

	set_species(new_species, new_bodytype)

	//Handle spawning stuff
	species.handle_pre_spawn(src)
	apply_species_appearance()
	apply_bodytype_appearance()
	apply_species_background_info()
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

/mob/living/human/proc/reset_accessory(accessory_category, organ_tag, skip_update = FALSE)
	if(!accessory_category)
		return

	var/decl/bodytype/root_bodytype = get_bodytype()
	var/decl/sprite_accessory_category/acc_category = GET_DECL(accessory_category)
	var/list/valid_styles = species?.get_available_accessories(root_bodytype, accessory_category)

	var/decl/sprite_accessory/new_style
	if(length(valid_styles))
		new_style = pick(valid_styles)
	else
		var/list/default_data = LAZYACCESS(root_bodytype?.default_sprite_accessories, accessory_category)
		new_style = islist(default_data) ? pick(default_data) : acc_category.default_accessory
	if(ispath(new_style))
		new_style = GET_DECL(new_style)

	var/list/metadata = new_style.update_metadata(get_organ_sprite_accessory_metadata(get_organ_sprite_accessory_by_category(accessory_category, organ_tag), organ_tag))
	set_organ_sprite_accessory_by_category(new_style.type, accessory_category, metadata, TRUE, TRUE, organ_tag, skip_update)

/mob/living/human/proc/reset_hair()
	reset_accessory(SAC_HAIR, BP_HEAD, TRUE)
	reset_accessory(SAC_FACIAL_HAIR, BP_HEAD, TRUE)
	update_hair(TRUE)

/mob/living/human/proc/change_skin_tone(var/tone)
	if(skin_tone == tone || !(get_bodytype().appearance_flags & HAS_A_SKIN_TONE))
		return
	skin_tone = tone
	force_update_limbs()
	update_body()
	return 1

/mob/living/human/proc/generate_valid_species(var/check_whitelist = 1, var/list/whitelist = list(), var/list/blacklist = list())
	var/list/valid_species = new()
	for(var/decl/species/current_species as anything in decls_repository.get_decls_of_subtype_unassociated(/decl/species))
		if(check_whitelist) //If we're using the whitelist, make sure to check it!
			if((current_species.spawn_flags & SPECIES_IS_RESTRICTED) && !check_rights(R_ADMIN, 0, src))
				continue
			if(!is_alien_whitelisted(src, current_species))
				continue
		if(whitelist.len && !(current_species.uid in whitelist))
			continue
		if(blacklist.len && (current_species.uid in blacklist))
			continue

		valid_species += current_species.uid

	return valid_species
