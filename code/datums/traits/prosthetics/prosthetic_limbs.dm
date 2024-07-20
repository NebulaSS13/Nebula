// Prosthetics.
/decl/trait/prosthetic_limb
	trait_cost = 1
	category = "Prosthetic Limbs"
	available_at_chargen = TRUE
	available_at_map_tech = MAP_TECH_LEVEL_SPACE
	abstract_type = /decl/trait/prosthetic_limb
	reapply_on_rejuvenation = TRUE
	var/fullbody_synthetic_only = FALSE
	var/replace_children = TRUE
	var/check_bodytype
	var/bodypart_name
	var/apply_to_limb = BP_L_HAND
	var/list/incompatible_with_limbs = list(BP_L_HAND)
	var/model

/decl/trait/prosthetic_limb/proc/get_base_model(var/species_name)
	if(!species_name)
		return /decl/bodytype/prosthetic/basic_human
	var/decl/species/species = species_name ? get_species_by_key(species_name) : global.using_map.default_species
	return species?.base_external_prosthetics_model

/decl/trait/prosthetic_limb/Initialize()
	. = ..()
	// Macro can generate float costs, round to closest point value.
	if(trait_cost)
		trait_cost = CEILING(trait_cost)
	if(bodypart_name)
		if(model)
			var/decl/bodytype/prosthetic/model_manufacturer = GET_DECL(model)
			name = "[capitalize(model_manufacturer.name)] [bodypart_name]"
			description = "You have been fitted with [ADD_ARTICLE(model_manufacturer.name)] [lowertext(bodypart_name)] prosthesis."
			available_at_map_tech = model_manufacturer.required_map_tech
		else
			name = "Prosthetic [bodypart_name]"
			description = "You have been fitted with a basic [lowertext(bodypart_name)] prosthesis."

/decl/trait/prosthetic_limb/build_references()
	. = ..()
	// Build our mutual exclusion list with other models/children.
	if(length(incompatible_with_limbs))
		var/list/check_traits = decls_repository.get_decls_of_subtype(/decl/trait/prosthetic_limb)
		for(var/trait_type in check_traits)
			// Can't exclude ourselves.
			if(trait_type == type)
				continue
			// The base model trait does not exclude itself from specific models, but specific models will exclude from all others.
			var/decl/trait/prosthetic_limb/trait = check_traits[trait_type]
			if(!(trait.apply_to_limb in incompatible_with_limbs))
				continue
			// Base model is only incompatible with itself.
			if(isnull(model) != isnull(trait.model) && (!isnull(model) || !isnull(trait.model)))
				continue
			// Specific models are incompatible with everything.
			LAZYDISTINCTADD(incompatible_with, trait_type)
			LAZYDISTINCTADD(trait.incompatible_with, type)

	// We will also exclude from relevant amputations, but they will be handled by amputation trait build_references()

	// If our model has any additional trait handling, do it here.
	// Without a model, we will rely on is_available_to() to check get_base_model() for the user species.
	blocked_species = null

/decl/trait/prosthetic_limb/applies_to_organ(var/organ)
	return apply_to_limb && organ == apply_to_limb

/decl/trait/prosthetic_limb/is_available_to(datum/preferences/pref)
	. = ..()
	if(.)
		if(fullbody_synthetic_only)
			var/decl/bodytype/bodytype = pref.get_bodytype_decl()
			if(!bodytype?.is_robotic)
				return FALSE
		if(model)
			var/decl/bodytype/prosthetic/R = GET_DECL(model)
			if(!istype(R))
				return FALSE
			var/decl/species/S = get_species_by_key(pref.species) || get_species_by_key(global.using_map.default_species)
			var/decl/bodytype/B = S.get_bodytype_by_name(pref.bodytype)
			if(!R.check_can_install(apply_to_limb, target_bodytype = (check_bodytype || B.bodytype_category)))
				return FALSE
		else if(!get_base_model(pref.species))
			return FALSE

/decl/trait/prosthetic_limb/apply_trait(mob/living/holder)
	. = ..()

	// Don't apply if there's a specific model selected.
	if(!model && holder)
		var/has_specific_model = FALSE
		for(var/trait_type in holder.get_traits())
			var/decl/trait/trait = GET_DECL(trait_type)
			if(trait != src && istype(trait, type))
				has_specific_model = TRUE
				break
		if(has_specific_model)
			return

	// Robotize the selected limb.
	if(. && apply_to_limb)
		var/use_model = model || get_base_model(holder.get_species_name())
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(holder, apply_to_limb)
		if(!istype(E))
			var/list/organ_data = holder.should_have_limb(apply_to_limb)
			var/limb_path = organ_data["path"]
			if("path" in organ_data)
				E = new limb_path(holder, null, use_model)
		if(istype(E) && E.bodytype != model) // sometimes in the last line we save ourselves some work here
			// this should be pre-validated by is_available_to()
			if(replace_children)
				E.set_bodytype_with_children(use_model)
			else
				E.set_bodytype(use_model)

/decl/trait/prosthetic_limb/left_hand
	bodypart_name = "Left Hand"
	apply_to_limb = BP_L_HAND
	incompatible_with_limbs = list(BP_L_HAND, BP_L_ARM)

/decl/trait/prosthetic_limb/left_arm
	bodypart_name = "Left Arm"
	trait_cost = 2
	apply_to_limb = BP_L_ARM
	incompatible_with_limbs = list(BP_L_HAND, BP_L_ARM)

/decl/trait/prosthetic_limb/right_hand
	bodypart_name = "Right Hand"
	apply_to_limb = BP_R_HAND
	incompatible_with_limbs = list(BP_R_HAND, BP_R_ARM)

/decl/trait/prosthetic_limb/right_arm
	bodypart_name = "Right Arm"
	trait_cost = 2
	apply_to_limb = BP_R_ARM
	incompatible_with_limbs = list(BP_R_HAND, BP_R_ARM)

/decl/trait/prosthetic_limb/left_foot
	bodypart_name = "Left Foot"
	apply_to_limb = BP_L_FOOT
	incompatible_with_limbs = list(BP_L_FOOT, BP_L_LEG)

/decl/trait/prosthetic_limb/left_leg
	bodypart_name = "Left Leg"
	trait_cost = 2
	apply_to_limb = BP_L_LEG
	incompatible_with_limbs = list(BP_L_FOOT, BP_L_LEG)

/decl/trait/prosthetic_limb/right_foot
	bodypart_name = "Right Foot"
	apply_to_limb = BP_R_FOOT
	incompatible_with_limbs = list(BP_R_FOOT, BP_R_LEG)

/decl/trait/prosthetic_limb/right_leg
	bodypart_name = "Right Leg"
	trait_cost = 2
	apply_to_limb = BP_R_LEG
	incompatible_with_limbs = list(BP_R_FOOT, BP_R_LEG)

/decl/trait/prosthetic_limb/head
	bodypart_name = "Head"
	trait_cost = 1
	apply_to_limb = BP_HEAD
	incompatible_with_limbs = list(BP_HEAD)
	fullbody_synthetic_only = TRUE
	replace_children = FALSE

/decl/trait/prosthetic_limb/chest
	bodypart_name = "Upper Body"
	trait_cost = 1
	apply_to_limb = BP_CHEST
	incompatible_with_limbs = list(BP_CHEST)
	fullbody_synthetic_only = TRUE
	replace_children = FALSE

/decl/trait/prosthetic_limb/groin
	bodypart_name = "Lower Body"
	trait_cost = 1
	apply_to_limb = BP_GROIN
	incompatible_with_limbs = list(BP_GROIN)
	fullbody_synthetic_only = TRUE
	replace_children = FALSE
