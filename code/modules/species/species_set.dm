// Initializes species logic, small misc stuff.
/decl/species/proc/initialize_species_for_mob(var/mob/living/carbon/human/H)
	H.mob_size = mob_size
	if(holder_type)
		H.holder_type = holder_type
	if(H.dna)
		H.dna.species = type

// Updates bodytype, pronouns and other misc appearance.
/decl/species/proc/apply_appearance_to_mob(var/mob/living/carbon/human/H)

	H.icon_state = lowertext(name)
	H.skin_colour = base_color || COLOR_BLACK

	if(!istype(H.pronouns) || !(H.pronouns in available_pronouns))
		H.set_gender(default_pronouns.name)

	if(!istype(H.bodytype) || !(H.bodytype in available_bodytypes))
		H.set_bodytype(default_bodytype, TRUE)

	LAZYCLEARLIST(H.appearance_descriptors)
	if(LAZYLEN(appearance_descriptors))
		for(var/desctype in appearance_descriptors)
			var/datum/appearance_descriptor/descriptor = appearance_descriptors[desctype]
			LAZYSET(H.appearance_descriptors, descriptor.name, descriptor.default_value)

	if(!(appearance_flags & HAS_UNDERWEAR))
		QDEL_NULL_LIST(H.worn_underwear)

// Sets up butchery products for the mob.
/decl/species/proc/apply_butchery_products_to_mob(var/mob/living/carbon/human/H)
	H.meat_type =     meat_type
	H.meat_amount =   meat_amount
	H.skin_material = skin_material
	H.skin_amount =   skin_amount
	H.bone_material = bone_material
	H.bone_amount =   bone_amount

//Handles anything not already covered by basic species assignment.
/decl/species/proc/finalize_species_for_mob(var/mob/living/carbon/human/H) 
	add_inherent_verbs(H)
	add_base_auras(H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags
	handle_limbs_setup(H)

/decl/species/proc/apply_culture_to_mob(var/mob/living/carbon/human/H)
	var/update_lang
	for(var/token in ALL_CULTURAL_TAGS)
		if(force_cultural_info && force_cultural_info[token])
			update_lang = TRUE
			H.set_cultural_value(token, force_cultural_info[token], defer_language_update = TRUE)
		else if(!H.cultural_info[token] || !(H.cultural_info[token] in available_cultural_info[token]))
			update_lang = TRUE
			H.set_cultural_value(token, default_cultural_info[token], defer_language_update = TRUE)
	if(update_lang)
		H.languages.Cut()
		H.default_language = null
		H.update_languages()

/decl/species/proc/apply_movement_to_mob(var/mob/living/carbon/human/H)
	H.available_maneuvers = maneuvers?.Copy() || list()
	H.default_walk_intent = null
	H.default_run_intent = null
	H.move_intent = null
	H.move_intents = move_intents.Copy()
	H.set_move_intent(GET_DECL(H.move_intents[1]))
	if(!istype(H.move_intent))
		H.set_next_usable_move_intent()

// Handles creation of mob organs. Does not heal damage or restore prosthetics etc.
/decl/species/proc/populate_mob_organs(var/mob/living/carbon/human/H)
	world << "[type] [H] pop"

	// Update external organs.
	for(var/bp in has_limbs)
		var/list/organ_data = has_limbs[bp]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/existing_organ = H.get_organ(bp)
		if(!istype(existing_organ, limb_path))
			if(existing_organ)
				qdel(existing_organ)
			new limb_path(H)
		else
			existing_organ.set_species(src)

	// Update internal organs.
	for(var/bp in has_organ)
		var/organ_type = has_organ[bp]
		var/obj/item/organ/existing_organ = H.get_organ(bp)
		if(!istype(existing_organ, organ_type))
			if(existing_organ)
				qdel(existing_organ)
			existing_organ = new organ_type(H)
		else
			existing_organ.set_species(src)

		if(bp != existing_organ.organ_tag)
			warning("[existing_organ.type] has a default organ tag \"[existing_organ.organ_tag]\" that differs from the species' organ tag \"[bp]\". Updating organ_tag to match.")
			existing_organ.organ_tag = bp

// Handle any additional post-population logic.
/decl/species/proc/finalize_mob_organs(var/mob/living/carbon/human/H)
	world << "[type] [H] final"
	H.update_body()
	H.refresh_visible_overlays()
