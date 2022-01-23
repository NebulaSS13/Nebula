/decl/aspect/amputation
	aspect_cost = -1
	category = "Missing Limbs"
	aspect_flags = ASPECTS_PHYSICAL
	sort_value = 1
	var/apply_to_limb

/decl/aspect/amputation/left_hand
	name = "Amputated Left Hand"
	desc = "You are missing your left hand."
	incompatible_with = list(
		/decl/aspect/amputation/left_arm,
		/decl/aspect/prosthetic_limb/left_hand,
		/decl/aspect/prosthetic_limb/left_arm
	)
	apply_to_limb = BP_L_HAND

/decl/aspect/amputation/applies_to_organ(var/organ)
	return apply_to_limb && organ == apply_to_limb

/decl/aspect/amputation/is_available_to(datum/preferences/pref)
	. = ..()
	if(. && pref.species)
		var/decl/species/species = global.all_species[pref.species]
		return istype(species) && (apply_to_limb in species.has_limbs)

/decl/aspect/amputation/apply(var/mob/living/carbon/human/holder)
	. = ..()
	if(. && apply_to_limb)
		var/obj/item/organ/external/O = holder.get_organ(apply_to_limb)
		if(istype(O))
			qdel(O)

/decl/aspect/amputation/left_arm
	name = "Amputated Left Arm"
	desc = "You are missing your left arm."
	apply_to_limb = BP_L_ARM
	aspect_cost = -2
	incompatible_with = list(
		/decl/aspect/amputation/left_hand,
		/decl/aspect/prosthetic_limb/left_arm,
		/decl/aspect/prosthetic_limb/left_hand
	)

/decl/aspect/amputation/right_hand
	name = "Amputated Right Hand"
	desc = "You are missing your right hand."
	apply_to_limb = BP_R_HAND
	incompatible_with = list(
		/decl/aspect/amputation/right_arm,
		/decl/aspect/prosthetic_limb/right_hand,
		/decl/aspect/prosthetic_limb/right_arm
	)

/decl/aspect/amputation/right_arm
	name = "Amputated Right Arm"
	desc = "You are missing your right arm."
	apply_to_limb = BP_R_ARM
	aspect_cost = -2
	incompatible_with = list(
		/decl/aspect/amputation/right_hand,
		/decl/aspect/prosthetic_limb/right_arm,
		/decl/aspect/prosthetic_limb/right_hand
	)

/decl/aspect/amputation/left_foot
	name = "Amputated Left Foot"
	desc = "You are missing your left foot."
	apply_to_limb = BP_L_FOOT
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
	apply_to_limb = BP_L_LEG
	aspect_cost = -2

/decl/aspect/amputation/right_foot
	name = "Amputated Right Foot"
	desc = "You are missing your right foot."
	apply_to_limb = BP_R_FOOT
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/right_leg,
		/decl/aspect/prosthetic_limb/right_foot,
		/decl/aspect/amputation/right_leg
	)
/decl/aspect/amputation/right_leg
	name = "Amputated Right Leg"
	desc = "You are missing your right leg."
	apply_to_limb = BP_R_LEG
	aspect_cost = -2
	incompatible_with = list(
		/decl/aspect/amputation/right_foot,
		/decl/aspect/prosthetic_limb/right_leg,
		/decl/aspect/prosthetic_limb/right_foot
	)
