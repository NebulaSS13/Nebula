/datum/species/utility_frame
	name =                  SPECIES_FRAME
	name_plural =           "Utility Frames"
	description =           "Simple AI-driven robots are used for many menial or repetitive tasks in human space."
	icobase =               'icons/mob/human_races/cyberlimbs/utility/body.dmi'
	deform =                'icons/mob/human_races/cyberlimbs/utility/body.dmi'
	limb_blend =            ICON_MULTIPLY
	cyborg_noun = null

	min_age =               1
	max_age =               20
	hidden_from_codex =     FALSE
	bodytype =              BODYTYPE_HUMANOID
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
	genders = list(
		NEUTER, 
		PLURAL
	)
	available_cultural_info = list(
		TAG_CULTURE = list(CULTURE_SYNTHETIC)
	)
	has_organ = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
		BP_EYES = /obj/item/organ/internal/eyes/robot
	)

/datum/species/utility_frame/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)
	var/obj/item/organ/external/E = org
	if(istype(E) && !BP_IS_PROSTHETIC(E))
		E.robotize("Utility Frame")
	var/obj/item/organ/external/head/head = H.organs_by_name[BP_HEAD]
	if(istype(head))
		head.glowing_eyes = TRUE
	var/obj/item/organ/internal/eyes/eyes = H.internal_organs_by_name[vision_organ || BP_EYES]
	if(istype(eyes))
		eyes.eye_icon = 'icons/mob/human_races/cyberlimbs/utility/eyes.dmi'
	H.regenerate_icons()

/datum/species/utility_frame/handle_post_species_pref_set(var/datum/preferences/pref)
	if(pref)
		LAZYINITLIST(pref.body_markings)
		for(var/marking in list("Frame Body Plating", "Frame Leg Plating", "Frame Head Plating"))
			if(!pref.body_markings[marking])
				pref.body_markings[marking] = "#8888cc"
		pref.skin_colour = "#333355"
		pref.eye_colour = "#00ccff"

/datum/species/utility_frame/get_blood_name()
	. = "coolant"

/datum/species/utility_frame/disfigure_msg(var/mob/living/carbon/human/H)
	. = SPAN_DANGER("The faceplate is dented and cracked!\n")

/datum/sprite_accessory/marking/frame
	name = "Frame Department Stripe"
	icon_state = "single_stripe"
	body_parts = list(BP_CHEST)
	species_allowed = list(SPECIES_FRAME)
	icon = 'icons/mob/human_races/cyberlimbs/utility/markings.dmi'
	blend = ICON_MULTIPLY

/datum/sprite_accessory/marking/frame/head_stripe
	name = "Frame Head Stripe"
	icon_state = "head_stripe"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/frame/double_stripe
	name = "Frame Department Stripes"
	icon_state = "double_stripe"

/datum/sprite_accessory/marking/frame/shoulder_stripe
	name = "Frame Shoulder Markings"
	icon_state = "shoulder_stripe"

/datum/sprite_accessory/marking/frame/plating
	name = "Frame Body Plating"
	icon_state = "plating"
	body_parts = list(BP_GROIN, BP_CHEST)

/datum/sprite_accessory/marking/frame/barcode
	name = "Frame Matrix Barcode"
	icon_state = "barcode"
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/frame/plating/legs
	name = "Frame Leg Plating"
	body_parts = list(BP_L_LEG, BP_R_LEG)

/datum/sprite_accessory/marking/frame/plating/head
	name = "Frame Head Plating"
	body_parts = list(BP_HEAD)

#undef SPECIES_FRAME