/datum/preferences/proc/randomize_appearance_and_body_for(var/mob/living/human/H)

	if(!H)
		H = client?.mob

	var/decl/species/current_species = get_species_decl()
	var/decl/bodytype/current_bodytype = current_species.get_bodytype_by_name(bodytype) || current_species.default_bodytype
	var/decl/pronouns/pronouns = pick(current_species.available_pronouns)
	gender = pronouns.name

	for(var/acc_cat in sprite_accessories)
		var/decl/sprite_accessory_category/accessory_category_decl = GET_DECL(acc_cat)
		if(accessory_category_decl.single_selection)
			var/list/available_styles = get_usable_sprite_accessories(H, current_species, current_bodytype, acc_cat, null)
			if(length(available_styles))
				sprite_accessories[acc_cat][1] = pick(available_styles)
			sprite_accessories[acc_cat][sprite_accessories[acc_cat][1]] = get_random_colour()
			continue
		for(var/accessory in sprite_accessories[acc_cat])
			sprite_accessories[acc_cat][accessory] = get_random_colour()

	if(bodytype)
		if(current_bodytype.appearance_flags & HAS_A_SKIN_TONE)
			skin_tone = current_bodytype.get_random_skin_tone() || skin_tone
		if(current_bodytype.appearance_flags & HAS_EYE_COLOR)
			eye_colour = current_bodytype.get_random_eye_color()
		if(current_bodytype.appearance_flags & HAS_SKIN_COLOR)
			skin_colour = current_bodytype.get_random_skin_color()

	if(!islist(all_underwear))
		all_underwear = list()
	else if(length(all_underwear))
		all_underwear.Cut()

	if(current_bodytype.appearance_flags & HAS_UNDERWEAR)
		for(var/datum/category_group/underwear/WRC in global.underwear.categories)
			var/datum/category_item/underwear/WRI = pick(WRC.items)
			all_underwear[WRC.name] = WRI.name

	for(var/entry in current_bodytype.appearance_descriptors)
		var/datum/appearance_descriptor/descriptor = current_bodytype.appearance_descriptors[entry]
		if(istype(descriptor))
			appearance_descriptors[descriptor.name] = descriptor.randomize_value()

	var/list/all_backpacks = global.using_map.get_available_backpacks()
	backpack = all_backpacks[pick(all_backpacks)]
	blood_type = pickweight(current_species.blood_types)
	if(H)
		copy_to(H)

/datum/preferences/proc/dress_preview_mob(var/mob/living/human/dummy/mannequin)

	if(!mannequin)
		return

	var/update_icon = FALSE
	copy_to(mannequin, TRUE)

	// Apply any species-specific preview modification.
	mannequin = mannequin.species?.modify_preview_appearance(mannequin)

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
		for(var/thing in Gear())
			var/decl/loadout_option/G = decls_repository.get_decl_by_id_or_var(thing, /decl/loadout_option)
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

				if(G.slot && G.spawn_on_mob(mannequin, gear_list[gear_slot][G.uid]))
					update_icon = TRUE

	if(update_icon)
		mannequin.update_icon()
		mannequin.compile_overlays()

/datum/preferences/proc/update_preview_icon()
	var/mob/living/human/dummy/mannequin/mannequin = get_mannequin(client?.ckey)
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
