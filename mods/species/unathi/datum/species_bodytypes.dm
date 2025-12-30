/decl/bodytype/unathi
	name                    = "feminine"
	bodytype_category       = BODYTYPE_HUMANOID
	husk_icon               = 'mods/species/unathi/icons/husk.dmi'
	icon_base               = 'mods/species/unathi/icons/body_female.dmi'
	icon_deformed           = 'mods/species/unathi/icons/deformed_body_female.dmi'
	cosmetics_icon          = 'mods/species/unathi/icons/cosmetics.dmi'
	blood_overlays          = 'icons/mob/human_races/species/human/blood_overlays.dmi'
	bandages_icon           = 'icons/mob/bandage.dmi'
	health_hud_intensity    = 2
	associated_gender       = FEMALE
	onmob_state_modifiers   = list((slot_w_uniform_str) = "f")
	movement_slowdown       = 0.5
	base_color              = "#066000"
	appearance_flags        = HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	eye_darksight_range     = 3
	eye_flash_mod           = 1.2
	nail_noun               = "claws"
	uid                     = "bodytype_unathi_fem"
	footprints_icon         = 'mods/species/unathi/icons/footprints.dmi'

	age_descriptor = /datum/appearance_descriptor/age/unathi

	default_sprite_accessories = list(
		SAC_FRILLS = list(
			/decl/sprite_accessory/frills/unathi/frills_long = list(SAM_COLOR = "#192e19")
		)
	)

	appearance_descriptors = list(
		/datum/appearance_descriptor/height = 1.25,
		/datum/appearance_descriptor/build =  1.25
	)

	override_organ_types = list(
		BP_EYES   = /obj/item/organ/internal/eyes/unathi,
		BP_BRAIN  = /obj/item/organ/internal/brain/unathi
	)

	override_limb_types = list(
		BP_TAIL   = /obj/item/organ/external/tail/unathi,
		BP_HEAD   = /obj/item/organ/external/head/strong_bite,
		BP_L_HAND = /obj/item/organ/external/hand/clawed,
		BP_R_HAND = /obj/item/organ/external/hand/right/clawed
	)

	cold_level_1  = 280 //Default 260 - Lower is better
	cold_level_2  = 220 //Default 200
	cold_level_3  = 130 //Default 120

	heat_level_1  = 420 //Default 360 - Higher is better
	heat_level_2  = 480 //Default 400
	heat_level_3  = 1100 //Default 1000

	heat_discomfort_level = 320
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
	)

	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
	)

/decl/bodytype/unathi/get_default_grooming_results(obj/item/organ/external/limb, obj/item/grooming/tool)
	if(tool?.grooming_flags & GROOMABLE_FILE)
		return list(
			"success"    = GROOMING_RESULT_SUCCESS,
			"descriptor" = "[limb.name] scales"
		)
	return ..()

/decl/bodytype/unathi/masculine
	name                  = "masculine"
	icon_base             = 'mods/species/unathi/icons/body_male.dmi'
	icon_deformed         = 'mods/species/unathi/icons/deformed_body_male.dmi'
	associated_gender     = MALE
	onmob_state_modifiers = null
	uid                   = "bodytype_unathi_masc"

/obj/item/organ/external/tail/unathi
	tail_icon             = 'mods/species/unathi/icons/tail.dmi'
	tail_animation_states = 9

/obj/item/organ/external/tail/unathi/get_natural_attacks()
	var/static/unarmed_attack = GET_DECL(/decl/natural_attack/tail)
	return unarmed_attack
