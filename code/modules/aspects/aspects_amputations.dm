/decl/aspect/amputation
	aspect_cost = -1
	category = "Missing Limbs"
	aspect_flags = ASPECTS_PHYSICAL
	sort_value = 1
	var/list/apply_to_limbs

/decl/aspect/amputation/left_hand
	name = "Amputated Left Hand"
	desc = "You are missing your left hand."
	incompatible_with = list(
		/decl/aspect/amputation/left_arm,
		/decl/aspect/prosthetic_limb/left_hand,
		/decl/aspect/prosthetic_limb/left_arm
	)
	apply_to_limbs = list(BP_L_HAND)

/decl/aspect/amputation/applies_to_organ(var/organ)
	return (organ in apply_to_limbs)

/decl/aspect/amputation/is_available_to(datum/preferences/pref)
	. = ..()
	if(. && pref.species)
		var/decl/species/species = global.all_species[pref.species]
		if(!istype(species))
			return FALSE
		for(var/limb in apply_to_limbs)
			if(!(limb in species.has_limbs))
				return FALSE

/decl/aspect/amputation/apply(var/mob/living/carbon/human/holder)
	. = ..()
	if(. && apply_to_limbs)
		for(var/limb in apply_to_limbs)
			var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(holder, limb)
			if(istype(O))
				holder.remove_organ(O, FALSE, FALSE, FALSE, TRUE, FALSE)
				qdel(O)
		holder.update_body(TRUE)

/decl/aspect/amputation/left_arm
	name = "Amputated Left Arm"
	desc = "You are missing your left arm."
	apply_to_limbs = list(BP_L_ARM, BP_L_HAND)
	aspect_cost = -2
	incompatible_with = list(
		/decl/aspect/amputation/left_hand,
		/decl/aspect/prosthetic_limb/left_arm,
		/decl/aspect/prosthetic_limb/left_hand
	)

/decl/aspect/amputation/right_hand
	name = "Amputated Right Hand"
	desc = "You are missing your right hand."
	apply_to_limbs = list(BP_R_HAND)
	incompatible_with = list(
		/decl/aspect/amputation/right_arm,
		/decl/aspect/prosthetic_limb/right_hand,
		/decl/aspect/prosthetic_limb/right_arm
	)

/decl/aspect/amputation/right_arm
	name = "Amputated Right Arm"
	desc = "You are missing your right arm."
	apply_to_limbs = list(BP_R_ARM, BP_R_HAND)
	aspect_cost = -2
	incompatible_with = list(
		/decl/aspect/amputation/right_hand,
		/decl/aspect/prosthetic_limb/right_arm,
		/decl/aspect/prosthetic_limb/right_hand
	)

/decl/aspect/amputation/left_foot
	name = "Amputated Left Foot"
	desc = "You are missing your left foot."
	apply_to_limbs = list(BP_L_FOOT)
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/left_leg,
		/decl/aspect/prosthetic_limb/left_foot,
		/decl/aspect/amputation/left_leg
	)

/decl/aspect/amputation/left_leg
	name = "Amputated Left Leg"
	desc = "You are missing your left leg."
	incompatible_with = list(
		/decl/aspect/amputation/left_foot,
		/decl/aspect/prosthetic_limb/left_leg,
		/decl/aspect/prosthetic_limb/left_foot
	)
	apply_to_limbs = list(BP_L_LEG, BP_L_FOOT)
	aspect_cost = -2

/decl/aspect/amputation/right_foot
	name = "Amputated Right Foot"
	desc = "You are missing your right foot."
	apply_to_limbs = list(BP_R_FOOT)
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/right_leg,
		/decl/aspect/prosthetic_limb/right_foot,
		/decl/aspect/amputation/right_leg
	)
/decl/aspect/amputation/right_leg
	name = "Amputated Right Leg"
	desc = "You are missing your right leg."
	apply_to_limbs = list(BP_R_LEG, BP_R_FOOT)
	aspect_cost = -2
	incompatible_with = list(
		/decl/aspect/amputation/right_foot,
		/decl/aspect/prosthetic_limb/right_leg,
		/decl/aspect/prosthetic_limb/right_foot
	)
