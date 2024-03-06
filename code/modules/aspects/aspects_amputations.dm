/decl/aspect/amputation
	aspect_cost = -1
	category = "Missing Limbs"
	aspect_flags = ASPECTS_PHYSICAL
	sort_value = 1
	abstract_type = /decl/aspect/amputation
	var/list/apply_to_limbs
	var/list/ban_aspects_relating_to_limbs

/decl/aspect/amputation/build_references()
	if(length(ban_aspects_relating_to_limbs))
		var/list/check_aspects = decls_repository.get_decls_of_subtype(/decl/aspect/amputation)

		// Ban amputations that descend from us.
		for(var/aspect_type in check_aspects)
			if(aspect_type == type)
				continue
			var/decl/aspect/amputation/aspect = check_aspects[aspect_type]
			if(!aspect.name)
				continue // remove when abstract decl handling from dev is merged
			for(var/limb in aspect.apply_to_limbs)
				if(limb in ban_aspects_relating_to_limbs)
					LAZYDISTINCTADD(incompatible_with, aspect_type)
					LAZYDISTINCTADD(aspect.incompatible_with, type)
					break

		// Ban prosthetic types that require this limb to exist.
		check_aspects = decls_repository.get_decls_of_subtype(/decl/aspect/prosthetic_limb)
		for(var/aspect_type in check_aspects)
			if(aspect_type == type)
				continue
			var/decl/aspect/prosthetic_limb/aspect = check_aspects[aspect_type]
			if(aspect.apply_to_limb in ban_aspects_relating_to_limbs)
				LAZYDISTINCTADD(incompatible_with, aspect_type)
				LAZYDISTINCTADD(aspect.incompatible_with, type)

	. = ..()

/decl/aspect/amputation/applies_to_organ(var/organ)
	return (organ in apply_to_limbs)

/decl/aspect/amputation/is_available_to(datum/preferences/pref)
	. = ..()
	if(. && pref.bodytype)
		var/decl/bodytype/mob_bodytype = pref.get_bodytype_decl()
		if(!istype(mob_bodytype))
			return FALSE
		for(var/limb in apply_to_limbs)
			if(!(limb in mob_bodytype.has_limbs))
				return FALSE

/decl/aspect/amputation/apply(mob/living/holder)
	. = ..()
	if(. && apply_to_limbs)
		for(var/limb in apply_to_limbs)
			var/obj/item/organ/external/O = GET_EXTERNAL_ORGAN(holder, limb)
			if(istype(O))
				holder.remove_organ(O, FALSE, FALSE, FALSE, TRUE, FALSE)
				qdel(O)
		holder.update_body(TRUE)

/decl/aspect/amputation/left_hand
	name = "Amputated Left Hand"
	desc = "You are missing your left hand."
	apply_to_limbs = list(BP_L_HAND)
	ban_aspects_relating_to_limbs = list(BP_L_HAND, BP_L_ARM)

/decl/aspect/amputation/left_arm
	name = "Amputated Left Arm"
	desc = "You are missing your left arm."
	apply_to_limbs = list(BP_L_ARM, BP_L_HAND)
	ban_aspects_relating_to_limbs = list(BP_L_ARM, BP_L_HAND)
	aspect_cost = -2

/decl/aspect/amputation/right_hand
	name = "Amputated Right Hand"
	desc = "You are missing your right hand."
	apply_to_limbs = list(BP_R_HAND)
	ban_aspects_relating_to_limbs = list(BP_R_HAND, BP_R_ARM)

/decl/aspect/amputation/right_arm
	name = "Amputated Right Arm"
	desc = "You are missing your right arm."
	apply_to_limbs = list(BP_R_ARM, BP_R_HAND)
	ban_aspects_relating_to_limbs = list(BP_R_ARM, BP_R_HAND)
	aspect_cost = -2

/decl/aspect/amputation/left_foot
	name = "Amputated Left Foot"
	desc = "You are missing your left foot."
	apply_to_limbs = list(BP_L_FOOT)
	ban_aspects_relating_to_limbs = list(BP_L_LEG, BP_L_FOOT)

/decl/aspect/amputation/left_leg
	name = "Amputated Left Leg"
	desc = "You are missing your left leg."
	apply_to_limbs = list(BP_L_LEG, BP_L_FOOT)
	ban_aspects_relating_to_limbs = list(BP_L_LEG, BP_L_FOOT)
	aspect_cost = -2

/decl/aspect/amputation/right_foot
	name = "Amputated Right Foot"
	desc = "You are missing your right foot."
	apply_to_limbs = list(BP_R_FOOT)
	ban_aspects_relating_to_limbs = list(BP_R_LEG, BP_R_FOOT)

/decl/aspect/amputation/right_leg
	name = "Amputated Right Leg"
	desc = "You are missing your right leg."
	apply_to_limbs = list(BP_R_LEG, BP_R_FOOT)
	ban_aspects_relating_to_limbs = list(BP_R_LEG, BP_R_FOOT)
	aspect_cost = -2
