/decl/bodytype/lizard
	name =                   "feminine"
	bodytype_category =      BODYTYPE_HUMANOID
	husk_icon =              'mods/species/bayliens/unathi/icons/husk.dmi'
	icon_base =              'mods/species/bayliens/unathi/icons/body_female.dmi'
	icon_deformed =          'mods/species/bayliens/unathi/icons/deformed_body_female.dmi'
	lip_icon =               'mods/species/bayliens/unathi/icons/lips.dmi'
	blood_overlays =         'icons/mob/human_races/species/human/blood_overlays.dmi'
	bandages_icon =          'icons/mob/bandage.dmi'
	limb_icon_intensity =    0.7
	health_hud_intensity =   2
	associated_gender =      FEMALE
	uniform_state_modifier = "_f"
	movement_slowdown =      0.5
	base_color = "#066000"
	base_hair_color = "#192e19"
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	eye_darksight_range = 3
	eye_flash_mod = 1.2

	override_organ_types = list(
		BP_EYES = /obj/item/organ/internal/eyes/lizard,
		BP_BRAIN = /obj/item/organ/internal/brain/lizard
	)

	override_limb_types = list(BP_TAIL = /obj/item/organ/external/tail/lizard)

	default_h_style = /decl/sprite_accessory/hair/lizard/frills_long

/decl/bodytype/lizard/masculine
	name =                   "masculine"
	icon_base =              'mods/species/bayliens/unathi/icons/body_male.dmi'
	icon_deformed =          'mods/species/bayliens/unathi/icons/deformed_body_male.dmi'
	associated_gender =      MALE
	uniform_state_modifier = null

/obj/item/organ/external/tail/lizard
	tail_animation =         'mods/species/bayliens/unathi/icons/tail.dmi'
	tail =                   "sogtail"
