
/obj/structure/mineral_bath/should_dissolve_implant(obj/implanted_object)
	if(istype(implanted_object, /obj/item/organ/internal/augment))
		return FALSE
	return ..()

// Cause arm and hand augments to trigger fault ailments.
/datum/ailment/fault/locking_thumbs/New(obj/item/organ/_organ)
	var/static/did_injection = FALSE
	if(!did_injection)
		did_injection = TRUE
		applies_to_organ |= list(
			BP_AUGMENT_R_ARM,
			BP_AUGMENT_L_ARM,
			BP_AUGMENT_R_HAND,
			BP_AUGMENT_L_HAND
		)
	. = ..()

/datum/ailment/fault/locking_thumbs/resolve_tag_to_slot(organ_tag)
	switch(organ_tag)
		if(BP_AUGMENT_L_ARM, BP_AUGMENT_L_HAND)
			return BP_L_HAND
		if(BP_AUGMENT_R_ARM, BP_AUGMENT_R_HAND)
			return BP_R_HAND
	return ..()

// Add augments to scan results
/obj/item/organ/external/get_scan_results()
	for(var/obj/item/organ/internal/augment/aug in internal_organs)
		if(istype(aug) && aug.known)
			. += "[capitalize(aug.name)] implanted"