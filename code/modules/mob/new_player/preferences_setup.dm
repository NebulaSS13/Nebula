/datum/preferences/proc/random_hair_style()
	var/decl/species/mob_species = get_species_decl()
	var/list/valid_styles = mob_species?.get_hair_style_types(get_bodytype_decl())
	return length(valid_styles) ? pick(valid_styles) : /decl/sprite_accessory/hair/bald

/datum/preferences/proc/random_facial_hair_style()
	var/decl/species/mob_species = get_species_decl()
	var/list/valid_styles = mob_species?.get_facial_hair_style_types(get_bodytype_decl())
	return length(valid_styles) ? pick(valid_styles) : /decl/sprite_accessory/facial_hair/shaved

/datum/preferences/proc/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)

	var/decl/species/current_species = get_species_decl()
	var/decl/bodytype/current_bodytype = current_species.get_bodytype_by_name(bodytype) || current_species.default_bodytype
	var/decl/pronouns/pronouns = pick(current_species.available_pronouns)
	gender = pronouns.name

	h_style = random_hair_style()
	f_style = random_facial_hair_style()
	if(bodytype)
		if(current_bodytype.appearance_flags & HAS_A_SKIN_TONE)
			skin_tone = current_bodytype.get_random_skin_tone() || skin_tone
		if(current_bodytype.appearance_flags & HAS_EYE_COLOR)
			eye_colour = current_bodytype.get_random_eye_color()
		if(current_bodytype.appearance_flags & HAS_SKIN_COLOR)
			skin_colour = current_bodytype.get_random_skin_color()
		if(current_bodytype.appearance_flags & HAS_HAIR_COLOR)
			hair_colour = current_bodytype.get_random_hair_color()
			facial_hair_colour = prob(75) ? hair_colour : current_bodytype.get_random_facial_hair_color()

	if(all_underwear)
		all_underwear.Cut()
	if(current_bodytype.appearance_flags & HAS_UNDERWEAR)
		for(var/datum/category_group/underwear/WRC in global.underwear.categories)
			var/datum/category_item/underwear/WRI = pick(WRC.items)
			all_underwear[WRC.name] = WRI.name

	for(var/M in body_markings)
		body_markings[M] = get_random_colour()

	for(var/entry in current_species.appearance_descriptors)
		var/datum/appearance_descriptor/descriptor = current_species.appearance_descriptors[entry]
		if(istype(descriptor))
			appearance_descriptors[descriptor.name] = descriptor.randomize_value()

	var/list/all_backpacks = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
	backpack = all_backpacks[pick(all_backpacks)]
	blood_type = pickweight(current_species.blood_types)
	if(H)
		copy_to(H)

/datum/preferences/proc/dress_preview_mob(var/mob/living/carbon/human/dummy/mannequin)

	if(!mannequin)
		return

	var/update_icon = FALSE
	copy_to(mannequin, TRUE)

	var/datum/job/previewJob
	if(equip_preview_mob)
		// Determine what job is marked as 'High' priority, and dress them up as such.
		if(global.using_map.default_job_title in job_low)
			previewJob = SSjobs.get_by_title(global.using_map.default_job_title)
		else
			previewJob = SSjobs.get_by_title(job_high)
	else
		return

	if((equip_preview_mob & EQUIP_PREVIEW_JOB) && previewJob)
		mannequin.job = previewJob.title
		var/datum/mil_branch/branch = mil_branches.get_branch(branches[previewJob.title])
		var/datum/mil_rank/rank = mil_branches.get_rank(branches[previewJob.title], ranks[previewJob.title])
		previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title], branch, rank)
		update_icon = TRUE

	if(!(mannequin.get_bodytype()?.appearance_flags & HAS_UNDERWEAR) && length(all_underwear))
		all_underwear.Cut()

	if((equip_preview_mob & EQUIP_PREVIEW_LOADOUT) && !(previewJob && (equip_preview_mob & EQUIP_PREVIEW_JOB) && previewJob.skip_loadout_preview))
		// Equip custom gear loadout, replacing any job items
		var/list/loadout_taken_slots = list()
		for(var/thing in Gear())
			var/decl/loadout_option/G = global.gear_datums[thing]
			if(G)
				var/permitted = FALSE
				if(G.allowed_roles && G.allowed_roles.len)
					if(previewJob)
						for(var/job_type in G.allowed_roles)
							if(previewJob.type == job_type)
								permitted = TRUE
				else
					permitted = TRUE

				if(G.whitelisted && !(mannequin.species.name in G.whitelisted))
					permitted = FALSE

				if(!permitted)
					continue

				if(G.slot && G.slot != slot_tie_str && !(G.slot in loadout_taken_slots) && G.spawn_on_mob(mannequin, gear_list[gear_slot][G.name]))
					loadout_taken_slots.Add(G.slot)
					update_icon = TRUE

	if(update_icon)
		mannequin.update_icon()

/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	if(mannequin)
		mannequin.delete_inventory(TRUE)
		dress_preview_mob(mannequin)
		update_character_previews(mannequin)

/datum/preferences/proc/get_random_name()
	var/decl/cultural_info/culture/check_culture = cultural_info[TAG_CULTURE]
	if(ispath(check_culture, /decl/cultural_info))
		check_culture = GET_DECL(check_culture)
		return check_culture.get_random_name(client?.mob, gender)
	else
		return random_name(gender, species)
