/decl/bodytype
	// An associative list of target zones (ex. BP_CHEST, BP_MOUTH) mapped to all possible keys associated
	// with the zone. Used for species with body layouts that do not map directly to a standard humanoid body.
	var/list/limb_mapping

	var/list/has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
	)
	var/list/override_limb_types // Used for species that only need to change one or two entries in has_limbs.

	var/list/has_organs = list(    // which required-organ checks are conducted.
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes
		)
	var/list/override_organ_types // Used for species that only need to change one or two entries in has_organ.

	var/vision_organ              // If set, this organ is required for vision.
	var/breathing_organ           // If set, this organ is required for breathing.
	var/mob_size = MOB_SIZE_MEDIUM

/decl/bodytype/proc/setup_organs()
	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organs[BP_EYES])
		vision_organ = BP_EYES
	//If the species has lungs, they are the default breathing organ
	if(!breathing_organ && has_organs[BP_LUNGS])
		breathing_organ = BP_LUNGS

	// Modify organ lists if necessary.
	if(islist(override_organ_types))
		for(var/ltag in override_organ_types)
			has_organs[ltag] = override_organ_types[ltag]

	if(islist(override_limb_types))
		for(var/ltag in override_limb_types)
			has_limbs[ltag] = list("path" = override_limb_types[ltag])

	//Build organ descriptors
	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/obj/item/organ/limb_path = organ_data["path"]
		organ_data["descriptor"] = initial(limb_path.name)

/decl/bodytype/proc/get_limb_from_zone(var/limb)
	. = length(LAZYACCESS(limb_mapping, limb)) ? pick(limb_mapping[limb]) : limb

/decl/bodytype/proc/resize_organ(var/obj/item/organ/organ)
	if(!istype(organ))
		return
	organ.w_class = get_resized_organ_w_class(initial(organ.w_class))
	if(!istype(organ, /obj/item/organ/external))
		return
	var/obj/item/organ/external/limb = organ
	for(var/bp_tag in has_organs)
		var/obj/item/organ/internal/I = has_organs[bp_tag]
		if(initial(I.parent_organ) == organ.organ_tag)
			limb.cavity_max_w_class = max(limb.cavity_max_w_class, get_resized_organ_w_class(initial(I.w_class)))

/decl/bodytype/proc/get_resized_organ_w_class(var/organ_w_class)
	. = Clamp(organ_w_class + mob_size_difference(mob_size, MOB_SIZE_MEDIUM), ITEM_SIZE_TINY, ITEM_SIZE_GARGANTUAN)

//Checks if an existing organ is the species default
/decl/bodytype/proc/is_default_organ(var/obj/item/organ/O, var/decl/species/species)
	for(var/tag in has_organs)
		if(O.organ_tag == tag)
			if(ispath(O.type, has_organs[tag]))
				return TRUE
	return FALSE

//Checks if an existing limbs is the species default
/decl/bodytype/proc/is_default_limb(var/obj/item/organ/external/E, var/decl/species/species)
	// Crystalline/synthetic species should only count crystalline/synthetic limbs as default.
	// DO NOT change to (species_flags & SPECIES_FLAG_X) && !BP_IS_X(E)
	if(!(species.species_flags & SPECIES_FLAG_CRYSTALLINE) != !BP_IS_CRYSTAL(E))
		return FALSE
	if(!(species.species_flags & SPECIES_FLAG_SYNTHETIC) != !BP_IS_PROSTHETIC(E))
		return FALSE
	for(var/tag in E.bodytype.has_limbs)
		if(E.organ_tag == tag)
			var/list/organ_data = has_limbs[tag]
			if(ispath(E.type, organ_data["path"]))
				return TRUE
	return FALSE

//fully_replace: If true, all existing organs will be discarded. Useful when doing mob transformations, and not caring about the existing organs
/decl/bodytype/proc/create_missing_organs(var/mob/living/carbon/human/H, var/fully_replace = FALSE)
	if(fully_replace)
		H.delete_organs()

	//Clear invalid limbs
	if(H.has_external_organs())
		for(var/obj/item/organ/external/E in H.get_external_organs())
			if(!is_default_limb(E, H.species))
				H.remove_organ(E, FALSE, FALSE, TRUE, TRUE, FALSE) //Remove them first so we don't trigger removal effects by just calling delete on them
				qdel(E)

	//Clear invalid internal organs
	if(H.has_internal_organs())
		for(var/obj/item/organ/O in H.get_internal_organs())
			if(!is_default_organ(O, H.species))
				H.remove_organ(O, FALSE, FALSE, TRUE, TRUE, FALSE) //Remove them first so we don't trigger removal effects by just calling delete on them
				qdel(O)

	//Create missing limbs
	for(var/limb_type in has_limbs)
		if(GET_EXTERNAL_ORGAN(H, limb_type)) //Skip existing
			continue
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/external/E = new limb_path(H, null, H.dna) //explicitly specify the dna
		H.add_organ(E, null, FALSE, FALSE)

	//Create missing internal organs
	for(var/organ_tag in has_organs)
		if(GET_INTERNAL_ORGAN(H, organ_tag)) //Skip existing
			continue
		var/organ_type = has_organs[organ_tag]
		var/obj/item/organ/O = new organ_type(H, null, H.dna)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.add_organ(O, GET_EXTERNAL_ORGAN(H, O.parent_organ), FALSE, FALSE)
