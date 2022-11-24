/datum/appearance_descriptor/age/utility_frame
	chargen_min_index = 1
	chargen_max_index = 4
	standalone_value_descriptors = list(
		"brand new" =            1,
		"worn" =                 5,
		"an older model" =      12,
		"nearing end-of-life" = 16,
		"entirely obsolete" =   20
	)

/decl/species/utility_frame
	name =                  SPECIES_FRAME
	name_plural =           "Utility Frames"
	description =           "Simple AI-driven robots are used for many menial or repetitive tasks in human space."
	cyborg_noun = null
	base_prosthetics_model = null

	blood_types = list(/decl/blood_type/coolant)
	vital_organs = list(
		BP_POSIBRAIN,
		BP_CELL
	)

	available_bodytypes = list(/decl/bodytype/utility_frame)
	age_descriptor =        /datum/appearance_descriptor/age/utility_frame
	hidden_from_codex =     FALSE
	species_flags =         SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_SYNTHETIC
	spawn_flags =           SPECIES_CAN_JOIN
	appearance_flags =      HAS_SKIN_COLOR | HAS_EYE_COLOR
	strength =              STR_HIGH
	warning_low_pressure =  50
	hazard_low_pressure =  -1
	flesh_color =           COLOR_GUNMETAL
	cold_level_1 =          SYNTH_COLD_LEVEL_1
	cold_level_2 =          SYNTH_COLD_LEVEL_2
	cold_level_3 =          SYNTH_COLD_LEVEL_3
	heat_level_1 =          SYNTH_HEAT_LEVEL_1
	heat_level_2 =          SYNTH_HEAT_LEVEL_2
	heat_level_3 =          SYNTH_HEAT_LEVEL_3
	body_temperature =      null
	passive_temp_gain =     5  // stabilize at ~80 C in a 20 C environment.
	heat_discomfort_level = 373.15
	blood_volume = 0

	preview_outfit = null

	base_color = "#333355"
	base_eye_color = "#00ccff"
	base_markings = list(
		/decl/sprite_accessory/marking/frame/plating = "#8888cc",
		/decl/sprite_accessory/marking/frame/plating/legs = "#8888cc",
		/decl/sprite_accessory/marking/frame/plating/head = "#8888cc"
	)

	heat_discomfort_strings = list(
		"You are dangerously close to overheating!"
	)
	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/kick,
		/decl/natural_attack/punch
	)
	available_pronouns = list(
		/decl/pronouns,
		/decl/pronouns/neuter
	)
	available_cultural_info = list(
		TAG_CULTURE = list(/decl/cultural_info/culture/synthetic)
	)
	override_limb_types = list(BP_HEAD = /obj/item/organ/external/head/utility_frame)
	has_organ = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
		BP_EYES      = /obj/item/organ/internal/eyes/robot/utility_frame,
		BP_CELL = /obj/item/organ/internal/cell
	)

	exertion_effect_chance = 10
	exertion_charge_scale = 1
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)

/obj/item/organ/internal/eyes/robot/utility_frame
	eye_icon = 'mods/species/utility_frames/icons/eyes.dmi'

/obj/item/organ/external/head/utility_frame
	glowing_eyes = TRUE

/decl/species/utility_frame/apply_species_organ_modifications(obj/item/organ/org)
	..()
	if(istype(org, /obj/item/organ/external))
		var/obj/item/organ/external/E = org
		E.robotize(/decl/prosthetics_manufacturer/utility_frame, FALSE, TRUE, /decl/material/solid/metal/steel, BODYTYPE_HUMANOID, SPECIES_FRAME)

/decl/species/utility_frame/disfigure_msg(var/mob/living/carbon/human/H)
	. = SPAN_DANGER("The faceplate is dented and cracked!\n")
