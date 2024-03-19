/decl/bodytype/kobaloi
	name                 = "kobaloi"
	bodytype_category    = BODYTYPE_KOBALOI
	limb_blend           = ICON_MULTIPLY
	bandages_icon        = 'icons/mob/bandage.dmi'
	icon_base            = 'mods/species/fantasy/icons/kobaloi/body.dmi'
	icon_deformed        = 'mods/species/fantasy/icons/kobaloi/body.dmi'
	eye_icon             = 'mods/species/fantasy/icons/kobaloi/eyes.dmi'
	base_color           = "#8f974a"
	base_eye_color       = "#d95763"
	bodytype_flag        = BODY_FLAG_KOBALOI
	appearance_flags     = HAS_SKIN_COLOR | HAS_EYE_COLOR
	health_hud_intensity = 1.75
	movement_slowdown    = -0.5
	eye_blend            = ICON_MULTIPLY
	eye_darksight_range  = 7
	eye_flash_mod        = 2
	override_limb_types  = list(
		BP_HEAD = /obj/item/organ/external/head/kobaloi,
		BP_TAIL = /obj/item/organ/external/tail/kobaloi
	)
	default_sprite_accessories = list(
		SAC_MARKINGS = list(
			/decl/sprite_accessory/marking/kobaloi/left_ear = "#8f974a",
			/decl/sprite_accessory/marking/kobaloi/right_ear = "#8f974a"
		)
	)
	eye_low_light_vision_effectiveness    = 0.15
	eye_low_light_vision_adjustment_speed = 0.3
