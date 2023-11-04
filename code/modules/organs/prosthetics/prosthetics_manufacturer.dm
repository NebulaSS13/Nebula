/decl/bodytype/prosthetic
	abstract_type = /decl/bodytype/prosthetic
	icon_base = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
	desc = "A generic unbranded robotic prosthesis."
	limb_tech = "{'engineering':1,'materials':1,'magnets':1}"
	modifier_string = "robotic"
	is_robotic = TRUE
	body_flags = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS | BODY_FLAG_NO_PAIN | BODY_FLAG_NO_EAT
	material = /decl/material/solid/metal/steel
	eye_flash_mod = 1
	eye_darksight_range = 2
	associated_gender = PLURAL
	bodyfall_sounds = list(
		'sound/foley/metal1.ogg'
	)
	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/mmi_holder,
		BP_EYES  = /obj/item/organ/internal/eyes,
		BP_CELL  = /obj/item/organ/internal/cell
	)
	/// Determines which bodyparts can use this limb.
	var/list/applies_to_part

/decl/bodytype/prosthetic/apply_bodytype_organ_modifications(obj/item/organ/org)
	..()
	BP_SET_PROSTHETIC(org)
	if(istype(org, /obj/item/organ/external))
		var/obj/item/organ/external/external_organ = org
		external_organ.limb_flags &= (~ORGAN_FLAG_CAN_DISLOCATE)
		if(external_organ.owner)
			for(var/obj/item/organ/thing in external_organ.internal_organs)
				if(!thing.is_vital_to_owner() && !BP_IS_PROSTHETIC(thing))
					qdel(thing)
			external_organ.owner.refresh_modular_limb_verbs()

/**
 * Used to check if a prosthetic bodytype can be installed with a certain base bodytype/for a certain organ slot.
 * Parameters: var/target_slot
 * Parameters: var/target_bodytype - the bodytype_category we're checking
 */
/decl/bodytype/prosthetic/proc/check_can_install(target_slot, target_bodytype)
	. = istext(target_slot)
	if(.)
		if(islist(applies_to_part) && !(target_slot in applies_to_part))
			return FALSE
		if(target_bodytype && bodytype_category != target_bodytype)
			return FALSE
