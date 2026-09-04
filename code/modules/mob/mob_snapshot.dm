// Stub type used to replicate old DNA system's role in mob/organ initialization.
// Effectively a snapshot of a mob's state at a moment in time.
/datum/mob_snapshot
	var/real_name
	var/eye_color
	var/blood_type
	var/unique_enzymes
	var/skin_color
	var/skin_tone
	var/fingerprint

	var/decl/species/root_species
	var/decl/bodytype/root_bodytype

	var/list/sprite_accessories
	var/list/genetic_conditions
	/// Please find a better way to do this. This is done to add tails if we have the tail accessory selected...
	var/list/extra_limbs
	/// A list of trait levels to add. Should contain only 'heritable' traits... whatever that means.
	var/list/heritable_traits

/datum/mob_snapshot/New(mob/living/donor, genetic_info_only = FALSE)

	if(!istype(donor))
		return

	real_name      = donor.real_name        || "unknown"
	eye_color      = donor.get_eye_colour() || COLOR_BLACK
	blood_type     = donor.get_blood_type()
	unique_enzymes = donor.get_unique_enzymes()
	skin_color     = donor.get_skin_colour()
	skin_tone      = donor.get_skin_tone()
	fingerprint    = donor.get_full_print(ignore_blockers = TRUE)

	root_species   = donor.get_species()  || decls_repository.get_decl_by_id(global.using_map.default_species)
	root_bodytype  = donor.get_bodytype() || root_species.default_bodytype

	for(var/obj/item/organ/external/limb in donor?.get_external_organs())
		// Discard anything not relating to our core/original bodytype and species.
		// Does this need to be reviewed for Outreach serde?
		if(limb.bodytype == root_bodytype && limb.species == root_species && (!genetic_info_only || !BP_IS_PROSTHETIC(limb)))
			var/list/limb_sprite_acc = limb.get_sprite_accessories(copy = TRUE)
			if(length(limb_sprite_acc))
				LAZYSET(sprite_accessories, limb.organ_tag, limb_sprite_acc)

	genetic_conditions = donor?.get_genetic_conditions()?.Copy()
	for(var/decl/genetic_condition/condition as anything in genetic_conditions)
		if(!condition.is_heritable)
			LAZYREMOVE(genetic_conditions, condition)

/datum/mob_snapshot/PopulateClone(datum/mob_snapshot/clone)
	clone = ..()
	if(clone)
		clone.real_name          = real_name
		clone.eye_color          = eye_color
		clone.blood_type         = blood_type
		clone.unique_enzymes     = unique_enzymes
		clone.skin_color         = skin_color
		clone.skin_tone          = skin_tone
		clone.fingerprint        = fingerprint
		clone.genetic_conditions = genetic_conditions?.Copy()
		clone.root_species       = root_species
		clone.root_bodytype      = root_bodytype
		if(sprite_accessories)
			clone.sprite_accessories = deepCopyList(sprite_accessories)
	return clone

// Replaces UpdateAppearance().
/datum/mob_snapshot/proc/apply_appearance_to(mob/living/target, do_update = TRUE)

	if(istype(root_species) && root_species != target.get_species())
		if(istype(root_bodytype))
			target.set_species(root_species.uid, root_bodytype)
		else
			target.set_species(root_species.uid)
	else if(istype(root_bodytype) && target.get_bodytype() != root_bodytype)
		target.set_bodytype(root_bodytype)

	// we try to set traits as soon as possible after species set
	for(var/target_trait in heritable_traits)
		target.set_trait(target_trait, heritable_traits[target_trait])

	target.set_fingerprint(fingerprint)
	target.set_unique_enzymes(unique_enzymes)
	target.set_skin_colour(skin_color)
	target.set_eye_colour(eye_color)
	target.set_skin_tone(skin_tone)

	for(var/limb_data in extra_limbs)

		// Grab our limb type for checking.
		var/limb_path = extra_limbs[limb_data]["path"]

		// For whatever reason, we already have a limb in this slot.
		// Creating a new one without removing the old one would cause limb overwrite runtimes.
		var/obj/item/organ/external/limb = target.get_organ(limb_data)
		if(istype(limb))
			// TODO: some way to cleanly remove and restitch an organ up the limb chain.
			if(length(limb.children))
				continue
			// If it's already the appropriate type, we're probably safe to leave it.
			if(limb.type == limb_path)
				continue
			// Snip off the limb so we can replace it without issues.
			target.remove_organ(limb, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE)

		// Create and install the new limb.
		target.add_organ(new limb_path(null, null, src), null, TRUE, FALSE, FALSE, TRUE)

	extra_limbs = null // can't reuse it!

	for(var/obj/item/organ/organ in target.get_organs())
		organ.copy_from_mob_snapshot(src)

	for(var/decl/genetic_condition/condition as anything in genetic_conditions)
		target.add_genetic_condition(condition.type)

	if(do_update)
		target.force_update_limbs()
		target.update_hair(update_icons = FALSE)
		target.update_eyes()
	return TRUE

/mob/proc/get_mob_snapshot(check_dna = FALSE)
	RETURN_TYPE(/datum/mob_snapshot)
	return (!check_dna || has_genetic_information()) ? new /datum/mob_snapshot(src, genetic_info_only = check_dna) : null
