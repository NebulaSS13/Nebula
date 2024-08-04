/decl/bodytype/kobaloi
	name                 = "kobaloi"
	bodytype_category    = BODYTYPE_KOBALOI
	limb_blend           = ICON_MULTIPLY
	bandages_icon        = 'icons/mob/bandage.dmi'
	icon_base            = 'mods/content/fantasy/icons/kobaloi/body.dmi'
	icon_deformed        = 'mods/content/fantasy/icons/kobaloi/body.dmi'
	eye_icon             = 'mods/content/fantasy/icons/kobaloi/eyes.dmi'
	skeletal_icon        = 'mods/content/fantasy/icons/kobaloi/skeleton.dmi'
	base_color           = "#8f974a"
	base_eye_color       = "#d95763"
	bodytype_flag        = BODY_FLAG_KOBALOI
	appearance_flags     = HAS_SKIN_COLOR | HAS_EYE_COLOR
	health_hud_intensity = 1.75
	movement_slowdown    = -0.5
	eye_blend            = ICON_MULTIPLY
	eye_darksight_range  = 7
	eye_flash_mod        = 2
	age_descriptor       = /datum/appearance_descriptor/age
	override_limb_types  = list(
		BP_HEAD = /obj/item/organ/external/head/kobaloi,
		BP_TAIL = /obj/item/organ/external/tail/kobaloi
	)
	default_sprite_accessories = list(
		SAC_MARKINGS = list(
			/decl/sprite_accessory/marking/kobaloi/left_ear  = list(SAM_COLOR = "#8f974a"),
			/decl/sprite_accessory/marking/kobaloi/right_ear = list(SAM_COLOR = "#8f974a")
		)
	)
	eye_low_light_vision_effectiveness    = 0.15
	eye_low_light_vision_adjustment_speed = 0.3

/decl/bodytype/kobaloi/Initialize()
	if(!equip_adjust)
		equip_adjust = list(
			BP_R_HAND = list(
				"[NORTH]" = list( 1, -4),
				"[EAST]"  = list( 0, -4),
				"[SOUTH]" = list(-1, -4),
				"[WEST]"  = list(-1, -4)
			),
			BP_L_HAND = list(
				"[NORTH]" = list(-1, -4),
				"[EAST]"  = list( 1, -4),
				"[SOUTH]" = list( 1, -4),
				"[WEST]"  = list( 0, -4)
			),
			slot_w_uniform_str = list(
				"[NORTH]" = list( 0, -6),
				"[EAST]"  = list( 1, -6),
				"[SOUTH]" = list( 0, -6),
				"[WEST]"  = list(-1, -6)
			),
			slot_belt_str = list(
				"[NORTH]" = list( 0, -6),
				"[EAST]"  = list( 1, -6),
				"[SOUTH]" = list( 0, -6),
				"[WEST]"  = list(-1, -6)
			),
			slot_handcuffed_str = list(
				"[NORTH]" = list(-1, -4),
				"[EAST]"  = list( 1, -4),
				"[SOUTH]" = list( 1, -4),
				"[WEST]"  = list( 0, -4)
			),
			slot_wear_id_str = list(
				"[NORTH]" = list( 0, -6),
				"[EAST]"  = list( 1, -6),
				"[SOUTH]" = list( 0, -6),
				"[WEST]"  = list(-1, -6)
			),
			slot_gloves_str = list(
				"[NORTH]" = list(-1, -4),
				"[EAST]"  = list( 1, -4),
				"[SOUTH]" = list( 1, -4),
				"[WEST]"  = list( 0, -4)
			),
			slot_wear_suit_str = list(
				"[NORTH]" = list( 0, -6),
				"[EAST]"  = list( 1, -6),
				"[SOUTH]" = list( 0, -6),
				"[WEST]"  = list(-1, -6)
			),
			slot_back_str = list(
				"[NORTH]" = list( 0, -5),
				"[EAST]"  = list( 1, -5),
				"[SOUTH]" = list( 0, -5),
				"[WEST]"  = list(-1, -5)
			),
			slot_glasses_str = list(
				"[NORTH]" = list( 0, -6),
				"[EAST]"  = list( 3, -6),
				"[SOUTH]" = list( 0, -6),
				"[WEST]"  = list(-3, -6)
			),
			slot_wear_mask_str = list(
				"[NORTH]" = list( 0, -7),
				"[EAST]"  = list( 5, -7),
				"[SOUTH]" = list( 0, -7),
				"[WEST]"  = list(-5, -7)
			),
			slot_head_str = list(
				"[NORTH]" = list( 0, -5),
				"[EAST]"  = list( 3, -5),
				"[SOUTH]" = list( 0, -5),
				"[WEST]"  = list(-3, -5)
			),
			slot_l_ear_str = list(
				"[NORTH]" = list( 0, -5),
				"[EAST]"  = list( 3, -5),
				"[SOUTH]" = list( 0, -5),
				"[WEST]"  = list(-3, -5)
			),
			slot_r_ear_str = list(
				"[NORTH]" = list( 0, -5),
				"[EAST]"  = list( 3, -5),
				"[SOUTH]" = list( 0, -5),
				"[WEST]"  = list(-3, -5)
			)
		)
	. = ..()
