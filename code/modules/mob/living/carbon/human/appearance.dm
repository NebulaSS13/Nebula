/mob/living/carbon/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/location = src, var/mob/user = src, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/datum/topic_state/state = global.default_topic_state)
	var/datum/nano_module/appearance_changer/AC = new(location, src, check_species_whitelist, species_whitelist, species_blacklist)
	AC.flags = flags
	AC.ui_interact(user, state = state)

/mob/living/carbon/human/proc/change_species(var/new_species)
	if(!new_species)
		return

	if(species == new_species)
		return

	if(!(new_species in get_all_species()))
		return

	set_species(new_species)
	var/decl/special_role/antag = mind && player_is_antag(mind)
	if (antag && antag.required_language)
		add_language(antag.required_language)
		set_default_language(antag.required_language)
	reset_hair()
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

/mob/living/carbon/human/proc/change_hair(var/hair_style)
	if(!hair_style)
		return

	if(h_style == hair_style)
		return

	if(!(hair_style in global.hair_styles_list))
		return

	h_style = hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair(var/facial_hair_style)
	if(!facial_hair_style)
		return

	if(f_style == facial_hair_style)
		return

	if(!(facial_hair_style in global.facial_hair_styles_list))
		return

	f_style = facial_hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/reset_hair()
	var/list/valid_hairstyles = generate_valid_hairstyles()
	var/list/valid_facial_hairstyles = generate_valid_facial_hairstyles()

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		h_style = "Bald"

	if(valid_facial_hairstyles.len)
		f_style = pick(valid_facial_hairstyles)
	else
		//this shouldn't happen
		f_style = "Shaved"

	update_hair()

/mob/living/carbon/human/proc/change_eye_color(var/new_colour)
	if(eye_colour != new_colour)
		eye_colour = new_colour
		update_eyes()
		update_body()
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/change_hair_color(var/new_colour)
	if(hair_colour != new_colour)
		hair_colour = new_colour
		force_update_limbs()
		update_body()
		update_hair()
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/change_facial_hair_color(var/new_colour)
	if(facial_hair_colour != new_colour)
		facial_hair_colour = new_colour
		update_hair()
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/change_skin_color(var/new_colour)
	if(skin_colour == new_colour || !(species.appearance_flags & HAS_SKIN_COLOR))
		return FALSE
	skin_colour = new_colour
	force_update_limbs()
	update_body()
	return TRUE

/mob/living/carbon/human/proc/change_skin_tone(var/tone)
	if(skin_tone == tone || !(species.appearance_flags & HAS_A_SKIN_TONE))
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

/mob/living/carbon/human/proc/generate_valid_hairstyles(var/check_gender = 1)
	. = list()
	var/list/hair_styles = species.get_hair_styles()
	for(var/hair_style in hair_styles)
		var/datum/sprite_accessory/S = hair_styles[hair_style]
		if(check_gender)
			if(gender == MALE && S.gender == FEMALE)
				continue
			if(gender == FEMALE && S.gender == MALE)
				continue
		.[hair_style] = S

/mob/living/carbon/human/proc/generate_valid_facial_hairstyles()
	return species.get_facial_hair_styles(gender)

/mob/living/carbon/human/proc/force_update_limbs()
	for(var/obj/item/organ/external/O in organs)
		O.sync_colour_to_human(src)
	update_body(0)
