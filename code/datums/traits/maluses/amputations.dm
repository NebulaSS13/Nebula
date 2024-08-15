/decl/trait/malus/amputation
	trait_cost = -1
	category = "Missing Limbs"
	abstract_type = /decl/trait/malus/amputation
	reapply_on_rejuvenation = TRUE
	var/list/apply_to_limbs
	var/list/ban_traits_relating_to_limbs

/decl/trait/malus/amputation/build_references()
	if(length(ban_traits_relating_to_limbs))
		var/list/check_traits = decls_repository.get_decls_of_subtype(/decl/trait/malus/amputation)

		// Ban amputations that descend from us.
		for(var/trait_type in check_traits)
			if(trait_type == type)
				continue
			var/decl/trait/malus/amputation/trait = check_traits[trait_type]
			if(!trait.name)
				continue // remove when abstract decl handling from dev is merged
			for(var/limb in trait.apply_to_limbs)
				if(limb in ban_traits_relating_to_limbs)
					LAZYDISTINCTADD(incompatible_with, trait_type)
					LAZYDISTINCTADD(trait.incompatible_with, type)
					break

		// Ban prosthetic types that require this limb to exist.
		check_traits = decls_repository.get_decls_of_subtype(/decl/trait/prosthetic_limb)
		for(var/trait_type in check_traits)
			if(trait_type == type)
				continue
			var/decl/trait/prosthetic_limb/trait = check_traits[trait_type]
			if(trait.apply_to_limb in ban_traits_relating_to_limbs)
				LAZYDISTINCTADD(incompatible_with, trait_type)
				LAZYDISTINCTADD(trait.incompatible_with, type)

	. = ..()

/decl/trait/malus/amputation/applies_to_organ(var/organ)
	return (organ in apply_to_limbs)

/decl/trait/malus/amputation/is_available_to_select(datum/preferences/pref)
	. = ..()
	if(. && pref.bodytype)
		var/decl/bodytype/mob_bodytype = pref.get_bodytype_decl()
		if(!istype(mob_bodytype))
			return FALSE
		for(var/limb in apply_to_limbs)
			if(!(limb in mob_bodytype.has_limbs))
				return FALSE

/decl/trait/malus/amputation/apply_trait(mob/living/holder)
	. = ..()
	if(. && apply_to_limbs)
		for(var/limb in apply_to_limbs)
			var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(holder, limb)
			if(istype(O))
				holder.remove_organ(O, FALSE, FALSE, FALSE, TRUE, FALSE)
				qdel(O)
		holder.update_body(TRUE)

/decl/trait/malus/amputation/left_hand
	name = "Amputated Left Hand"
	description = "You are missing your left hand."
	apply_to_limbs = list(BP_L_HAND)
	ban_traits_relating_to_limbs = list(BP_L_HAND, BP_L_ARM)
	uid = "trait_amputated_left_hand"

/decl/trait/malus/amputation/left_arm
	name = "Amputated Left Arm"
	description = "You are missing your left arm."
	apply_to_limbs = list(BP_L_ARM, BP_L_HAND)
	ban_traits_relating_to_limbs = list(BP_L_ARM, BP_L_HAND)
	trait_cost = -2
	uid = "trait_amputated_left_arm"

/decl/trait/malus/amputation/right_hand
	name = "Amputated Right Hand"
	description = "You are missing your right hand."
	apply_to_limbs = list(BP_R_HAND)
	ban_traits_relating_to_limbs = list(BP_R_HAND, BP_R_ARM)
	uid = "trait_amputated_right_hand"

/decl/trait/malus/amputation/right_arm
	name = "Amputated Right Arm"
	description = "You are missing your right arm."
	apply_to_limbs = list(BP_R_ARM, BP_R_HAND)
	ban_traits_relating_to_limbs = list(BP_R_ARM, BP_R_HAND)
	trait_cost = -2
	uid = "trait_amputated_right_arm"

/decl/trait/malus/amputation/left_foot
	name = "Amputated Left Foot"
	description = "You are missing your left foot."
	apply_to_limbs = list(BP_L_FOOT)
	ban_traits_relating_to_limbs = list(BP_L_LEG, BP_L_FOOT)
	uid = "trait_amputated_left_foot"

/decl/trait/malus/amputation/left_leg
	name = "Amputated Left Leg"
	description = "You are missing your left leg."
	apply_to_limbs = list(BP_L_LEG, BP_L_FOOT)
	ban_traits_relating_to_limbs = list(BP_L_LEG, BP_L_FOOT)
	trait_cost = -2
	uid = "trait_amputated_left_leg"

/decl/trait/malus/amputation/right_foot
	name = "Amputated Right Foot"
	description = "You are missing your right foot."
	apply_to_limbs = list(BP_R_FOOT)
	ban_traits_relating_to_limbs = list(BP_R_LEG, BP_R_FOOT)
	uid = "trait_amputated_right_foot"

/decl/trait/malus/amputation/right_leg
	name = "Amputated Right Leg"
	description = "You are missing your right leg."
	apply_to_limbs = list(BP_R_LEG, BP_R_FOOT)
	ban_traits_relating_to_limbs = list(BP_R_LEG, BP_R_FOOT)
	trait_cost = -2
	uid = "trait_amputated_right_leg"
