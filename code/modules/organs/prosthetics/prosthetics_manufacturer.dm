/decl/bodytype/prosthetic
	abstract_type = /decl/bodytype/prosthetic
	icon_base = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
	desc = "A generic unbranded robotic prosthesis."
	limb_tech = @'{"engineering":1,"materials":1,"magnets":1}'
	modifier_string = "robotic"
	is_robotic = TRUE
	body_flags = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS | BODY_FLAG_NO_PAIN | BODY_FLAG_NO_EAT
	material = /decl/material/solid/metal/steel
	eye_flash_mod = 1
	eye_darksight_range = 2
	associated_gender = null
	emote_sounds = list(
		"whistle" = list('sound/voice/emotes/longwhistle_robot.ogg'),
		"qwhistle" = list('sound/voice/emotes/shortwhistle_robot.ogg'),
		"swhistle" = list('sound/voice/emotes/summon_whistle_robot.ogg'),
		"wwhistle" = list('sound/voice/emotes/wolfwhistle_robot.ogg')
	)
	broadcast_emote_sounds = list(
		"swhistle" = list('sound/voice/emotes/summon_whistle_robot.ogg')
	)
	override_emote_sounds = list(
		"cough" = list(
			'sound/voice/emotes/machine_cougha.ogg',
			'sound/voice/emotes/machine_coughb.ogg'
		),
		"sneeze" = list(
			'sound/voice/emotes/machine_sneeze.ogg'
		)
	)
	bodyfall_sounds = list(
		'sound/foley/metal1.ogg'
	)
	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain_interface,
		BP_EYES  = /obj/item/organ/internal/eyes,
		BP_CELL  = /obj/item/organ/internal/cell
	)
	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3
	heat_level_1 = SYNTH_HEAT_LEVEL_1
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3
	cold_discomfort_strings = null
	heat_discomfort_level = 373.15
	heat_discomfort_strings = list(
		"You are dangerously close to overheating!"
	)
	/// Determines which bodyparts can use this limb.
	var/list/applies_to_part
	/// Prosthetics of this type are not available in chargen unless the map has the required tech level.
	var/required_map_tech = MAP_TECH_LEVEL_SPACE

/decl/bodytype/prosthetic/get_user_species_for_validation()
	if(bodytype_category)
		for(var/species_name in get_all_species())
			var/decl/species/species = get_species_by_key(species_name)
			for(var/decl/bodytype/bodytype_data in species.available_bodytypes)
				if(bodytype_data.bodytype_category == bodytype_category)
					return species
	return ..()

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
