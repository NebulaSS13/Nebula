/decl/bodytype/hnoll
	name                 = "humanoid"
	bodytype_category    = BODYTYPE_HNOLL
	limb_blend           = ICON_MULTIPLY
	icon_template        = 'mods/content/fantasy/icons/hnoll/template.dmi'
	icon_base            = 'mods/content/fantasy/icons/hnoll/body.dmi'
	icon_deformed        = 'mods/content/fantasy/icons/hnoll/deformed_body.dmi'
	bandages_icon        = 'icons/mob/bandage.dmi'
	eye_icon             = 'mods/content/fantasy/icons/hnoll/eyes.dmi'
	cosmetics_icon       = 'mods/content/fantasy/icons/hnoll/cosmetics.dmi'
	skeletal_icon        = 'mods/content/fantasy/icons/hnoll/skeleton.dmi'
	health_hud_intensity = 1.75
	bodytype_flag        = BODY_FLAG_HNOLL
	appearance_flags     = HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	age_descriptor       = /datum/appearance_descriptor/age/hnoll
	base_color           = "#ae7d32"
	base_eye_color       = "#00aa00"

	default_sprite_accessories = list(
		SAC_HAIR     = list(
			/decl/sprite_accessory/hair/hnoll/mohawk        = list(SAM_COLOR = "#46321c")
		),
		SAC_MARKINGS = list(
			/decl/sprite_accessory/marking/hnoll/belly      = list(SAM_COLOR = "#b6b0a8"),
			/decl/sprite_accessory/marking/hnoll/spots/body = list(SAM_COLOR = "#46331d"),
			/decl/sprite_accessory/marking/hnoll/ears       = list(SAM_COLOR = "#46331d")
		)
	)

	eye_darksight_range                   = 7
	eye_flash_mod                         = 2
	eye_blend                             = ICON_MULTIPLY
	eye_low_light_vision_effectiveness    = 0.15
	eye_low_light_vision_adjustment_speed = 0.3

	override_limb_types = list(
		BP_TAIL = /obj/item/organ/external/tail/hnoll
	)

	cold_level_1 = 200
	cold_level_2 = 140
	cold_level_3 = 80

	heat_level_1 = 330
	heat_level_2 = 380
	heat_level_3 = 800

	heat_discomfort_level = 294
	cold_discomfort_level = 230
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)

/decl/bodytype/hnoll/Initialize()
	if(!equip_adjust)
		equip_adjust = list(
			slot_glasses_str = list(
				"[NORTH]" = list( 0, 2),
				"[EAST]"  = list( 0, 2),
				"[SOUTH]" = list( 0, 2),
				"[WEST]"  = list( 0, 2)
			),
			slot_wear_mask_str = list(
				"[NORTH]" = list( 0, 2),
				"[EAST]"  = list( 2, 2),
				"[SOUTH]" = list( 0, 2),
				"[WEST]"  = list(-2, 2)
			),
			slot_head_str = list(
				"[NORTH]" = list( 0, 2),
				"[EAST]"  = list( 0, 2),
				"[SOUTH]" = list( 0, 2),
				"[WEST]"  = list( 0, 2)
			)
		)
	. = ..()
