/decl/bodytype/lizard
	name                    = "feminine"
	bodytype_category       = BODYTYPE_HUMANOID
	husk_icon               = 'mods/species/bayliens/unathi/icons/husk.dmi'
	icon_base               = 'mods/species/bayliens/unathi/icons/body_female.dmi'
	icon_deformed           = 'mods/species/bayliens/unathi/icons/deformed_body_female.dmi'
	cosmetics_icon          = 'mods/species/bayliens/unathi/icons/cosmetics.dmi'
	blood_overlays          = 'icons/mob/human_races/species/human/blood_overlays.dmi'
	bandages_icon           = 'icons/mob/bandage.dmi'
	limb_icon_intensity     = 0.7
	health_hud_intensity    = 2
	associated_gender       = FEMALE
	onmob_state_modifiers   = list(slot_w_uniform_str = "f")
	movement_slowdown       = 0.5
	base_color              = "#066000"
	appearance_flags        = HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	eye_darksight_range     = 3
	eye_flash_mod           = 1.2
	nail_noun               = "claws"

	age_descriptor = /datum/appearance_descriptor/age/lizard

	default_sprite_accessories = list(
		SAC_FRILLS = list(
			/decl/sprite_accessory/frills/lizard/frills_long = "#192e19"
		)
	)

	appearance_descriptors = list(
		/datum/appearance_descriptor/height = 1.25,
		/datum/appearance_descriptor/build =  1.25
	)

	override_organ_types = list(
		BP_EYES = /obj/item/organ/internal/eyes/lizard,
		BP_BRAIN = /obj/item/organ/internal/brain/lizard
	)

	override_limb_types = list(BP_TAIL = /obj/item/organ/external/tail/lizard)

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

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

/decl/bodytype/lizard/get_default_grooming_results(obj/item/organ/external/limb, obj/item/grooming/tool)
	if(tool?.grooming_flags & GROOMABLE_FILE)
		return list(
			"success"    = GROOMING_RESULT_SUCCESS,
			"descriptor" = "[limb.name] scales"
		)
	return ..()

/decl/bodytype/lizard/masculine
	name                  = "masculine"
	icon_base             = 'mods/species/bayliens/unathi/icons/body_male.dmi'
	icon_deformed         = 'mods/species/bayliens/unathi/icons/deformed_body_male.dmi'
	associated_gender     = MALE
	onmob_state_modifiers = null

/obj/item/organ/external/tail/lizard
	tail_icon             = 'mods/species/bayliens/unathi/icons/tail.dmi'
	tail_animation_states = 9
