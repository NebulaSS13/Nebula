/decl/bodytype/tajaran
	name                 = "feminine"
	bodytype_category    = BODYTYPE_TAJARAN
	limb_blend           = ICON_MULTIPLY
	icon_template        = 'mods/species/tajaran/icons/template.dmi'
	icon_base            = 'mods/species/tajaran/icons/body.dmi'
	icon_deformed        = 'mods/species/tajaran/icons/deformed_body.dmi'
	bandages_icon        = 'icons/mob/bandage.dmi'
	skeletal_icon        = 'mods/species/tajaran/icons/skeleton.dmi'
	cosmetics_icon       = 'mods/species/tajaran/icons/cosmetics.dmi'
	health_hud_intensity = 1.75
	bodytype_flag        = BODY_EQUIP_FLAG_HUMANOID
	movement_slowdown    = -0.5
	appearance_flags     = HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	base_color           = "#ae7d32"
	base_eye_color       = "#00aa00"
	nail_noun            = "claws"
	uid                  = "bodytype_tajaran"
	footprints_icon      = 'icons/mob/footprints/footprints_paw.dmi'

	age_descriptor = /datum/appearance_descriptor/age/tajaran

	eye_darksight_range  = 7
	eye_flash_mod        = 2
	eye_blend            = ICON_MULTIPLY
	eye_icon             = 'mods/species/tajaran/icons/eyes.dmi'
	eye_low_light_vision_effectiveness    = 0.15
	eye_low_light_vision_adjustment_speed = 0.3

	override_limb_types = list(
		BP_TAIL   = /obj/item/organ/external/tail/cat,
		BP_HEAD   = /obj/item/organ/external/head/sharp_bite,
		BP_L_HAND = /obj/item/organ/external/hand/clawed,
		BP_R_HAND = /obj/item/organ/external/hand/right/clawed
	)

	default_sprite_accessories = list(
		SAC_HAIR = list(/decl/sprite_accessory/hair/taj/lynx = list(SAM_COLOR = "#46321c")),
		SAC_EARS = list(/decl/sprite_accessory/ears/tajaran  = list(SAM_COLOR = "#ae7d32"))
	)

	cold_level_1 = 200
	cold_level_2 = 140
	cold_level_3 = 80

	heat_level_1 = 330
	heat_level_2 = 380
	heat_level_3 = 800

	heat_discomfort_level   = 294
	cold_discomfort_level   = 230
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)

/decl/bodytype/tajaran/masculine
	name                  = "masculine"
	icon_base             = 'mods/species/tajaran/icons/body_male.dmi'
	icon_deformed         = 'mods/species/tajaran/icons/deformed_body_male.dmi'
	associated_gender     = MALE
	onmob_state_modifiers = null
	uid                   = "bodytype_tajaran_masc"

/decl/bodytype/tajaran/get_default_grooming_results(obj/item/organ/external/limb, obj/item/grooming/tool)
	if(tool?.grooming_flags & GROOMABLE_BRUSH)
		return list(
			"success"    = GROOMING_RESULT_SUCCESS,
			"descriptor" = "[limb.name] fur"
		)
	return ..()

/obj/item/organ/external/tail/cat
	tail_icon  = 'mods/species/tajaran/icons/tail.dmi'
	tail_blend = ICON_MULTIPLY
	tail_animation_states = 1
