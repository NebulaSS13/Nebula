// Prosthetics.
/decl/aspect/prosthetic_limb
	aspect_cost = 1
	category = "Prosthetic Limbs"
	sort_value = 2
	aspect_flags = ASPECTS_PHYSICAL
	var/base_type
	var/bodypart_name
	var/apply_to_limb = BP_L_HAND
	var/model = /decl/prosthetics_manufacturer

/decl/aspect/prosthetic_limb/Initialize()
	. = ..()
	if(bodypart_name)
		if(model && model != /decl/prosthetics_manufacturer)
			var/decl/prosthetics_manufacturer/model_manufacturer = GET_DECL(model)
			name = "[model_manufacturer.name] [bodypart_name]"
			desc = "You have been fitted with [ADD_ARTICLE(model_manufacturer.name)] [lowertext(bodypart_name)] prosthesis."
		else
			name = "Prosthetic [bodypart_name]"
			desc = "You have been fitted with a basic [lowertext(bodypart_name)] prosthesis."
	if(base_type)
		LAZYINITLIST(incompatible_with)
		incompatible_with |= typesof(base_type)
		incompatible_with -= type
		if(parent)
			incompatible_with -= parent.type
		UNSETEMPTY(incompatible_with)

/decl/aspect/prosthetic_limb/applies_to_organ(var/organ)
	return apply_to_limb && organ == apply_to_limb

/decl/aspect/prosthetic_limb/is_available_to(datum/preferences/pref)
	. = ..()
	if(. && model)
		var/decl/prosthetics_manufacturer/R = GET_DECL(model)
		if(!istype(R))
			return FALSE
		var/decl/species/S = get_species_by_key(pref.species) || get_species_by_key(global.using_map.default_species)
		var/decl/bodytype/B = S.get_bodytype_by_name(pref.bodytype)
		if(!R.check_can_install(apply_to_limb, B.bodytype_category, S.name))
			return FALSE

/decl/aspect/prosthetic_limb/apply(var/mob/living/carbon/human/holder)
	. = ..()

	// Don't apply if there's a specific model selected.
	if(model == /decl/prosthetics_manufacturer && !base_type && holder)
		var/has_specific_model = FALSE
		for(var/decl/aspect/A as anything in holder.personal_aspects)
			if(A != src && istype(A, type))
				has_specific_model = TRUE
				break
		if(has_specific_model)
			return

	// Robotize the selected limb.
	if(. && apply_to_limb)
		var/obj/item/organ/external/E = holder.organs_by_name[apply_to_limb]
		if(!istype(E))
			var/list/organ_data = holder.species.has_limbs[apply_to_limb]
			if("path" in organ_data)
				var/limb_path = organ_data["path"]
				E = new limb_path(holder)
		if(istype(E))
			E.robotize(model)

/decl/aspect/prosthetic_limb/left_hand
	bodypart_name = "Left Hand"
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/left_arm,
		/decl/aspect/amputation/left_hand,
		/decl/aspect/amputation/left_arm
	)
	apply_to_limb = BP_L_HAND

/decl/aspect/prosthetic_limb/left_arm
	bodypart_name = "Left Arm"
	aspect_cost = 2
	apply_to_limb = BP_L_ARM
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/left_hand,
		/decl/aspect/amputation/left_arm,
		/decl/aspect/amputation/left_hand
	)

/decl/aspect/prosthetic_limb/right_hand
	bodypart_name = "Right Hand"
	apply_to_limb = BP_R_HAND
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/right_arm,
		/decl/aspect/amputation/right_hand,
		/decl/aspect/amputation/right_arm
	)

/decl/aspect/prosthetic_limb/right_arm
	bodypart_name = "Right Arm"
	aspect_cost = 2
	apply_to_limb = BP_R_ARM
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/right_hand,
		/decl/aspect/amputation/right_arm,
		/decl/aspect/amputation/right_hand
	)

/decl/aspect/prosthetic_limb/left_foot
	bodypart_name = "Left Foot"
	apply_to_limb = BP_L_FOOT
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/left_leg,
		/decl/aspect/amputation/left_foot,
		/decl/aspect/amputation/left_leg
	)

/decl/aspect/prosthetic_limb/left_leg
	bodypart_name = "Left Leg"
	aspect_cost = 2
	apply_to_limb = BP_L_LEG
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/left_foot,
		/decl/aspect/amputation/left_foot,
		/decl/aspect/amputation/left_leg
	)

/decl/aspect/prosthetic_limb/right_foot
	bodypart_name = "Right Foot"
	apply_to_limb = BP_R_FOOT
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/right_leg,
		/decl/aspect/amputation/right_foot,
		/decl/aspect/amputation/right_leg
	)

/decl/aspect/prosthetic_limb/right_leg
	bodypart_name = "Right Leg"
	aspect_cost = 2
	apply_to_limb = BP_R_LEG
	incompatible_with = list(
		/decl/aspect/prosthetic_limb/right_foot,
		/decl/aspect/amputation/right_leg,
		/decl/aspect/amputation/right_foot
	)
