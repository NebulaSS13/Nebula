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
	preview_icon =          'mods/species/utility_frames/icons/preview.dmi'
	cyborg_noun = null

	available_bodytypes = list(/decl/bodytype/utility_frame)
	age_descriptor =        /datum/appearance_descriptor/age/utility_frame
	hidden_from_codex =     FALSE
	species_flags =         SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_POISON
	spawn_flags =           SPECIES_CAN_JOIN
	appearance_flags =      HAS_SKIN_COLOR | HAS_EYE_COLOR
	strength =              STR_HIGH
	warning_low_pressure =  50
	hazard_low_pressure =  -1
	blood_color =           COLOR_GRAY15
	flesh_color =           COLOR_GUNMETAL
	base_color =            COLOR_GUNMETAL
	cold_level_1 =          SYNTH_COLD_LEVEL_1
	cold_level_2 =          SYNTH_COLD_LEVEL_2
	cold_level_3 =          SYNTH_COLD_LEVEL_3
	heat_level_1 =          SYNTH_HEAT_LEVEL_1
	heat_level_2 =          SYNTH_HEAT_LEVEL_2
	heat_level_3 =          SYNTH_HEAT_LEVEL_3
	body_temperature =      null
	passive_temp_gain =     5  // stabilize at ~80 C in a 20 C environment.
	heat_discomfort_level = 373.15

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
	has_organ = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
		BP_EYES = /obj/item/organ/internal/eyes/robot
	)

	exertion_effect_chance = 10
	exertion_charge_scale = 1
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)

/decl/species/utility_frame/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)
	var/obj/item/organ/external/E = org
	if(istype(E) && !BP_IS_PROSTHETIC(E))
		E.robotize(/decl/prosthetics_manufacturer/utility_frame)
	var/obj/item/organ/external/head/head = org
	if(istype(head))
		head.glowing_eyes = TRUE
	var/obj/item/organ/internal/eyes/eyes = org
	if(istype(eyes))
		eyes.eye_icon = 'mods/species/utility_frames/icons/eyes.dmi'
	H.refresh_visible_overlays()

/decl/species/utility_frame/handle_post_species_pref_set(var/datum/preferences/pref)
	if(pref)
		LAZYINITLIST(pref.body_markings)
		for(var/marking in list("Frame Body Plating", "Frame Leg Plating", "Frame Head Plating"))
			if(!pref.body_markings[marking])
				pref.body_markings[marking] = "#8888cc"
		pref.skin_colour = "#333355"
		pref.eye_colour = "#00ccff"

/decl/species/utility_frame/get_blood_name()
	. = "coolant"

/decl/species/utility_frame/disfigure_msg(var/mob/living/carbon/human/H)
	. = SPAN_DANGER("The faceplate is dented and cracked!\n")
