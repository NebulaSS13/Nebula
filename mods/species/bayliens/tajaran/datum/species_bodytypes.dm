/decl/bodytype/feline
	name =                 "humanoid"
	bodytype_category =    BODYTYPE_FELINE
	limb_blend =           ICON_MULTIPLY
	icon_template =        'mods/species/bayliens/tajaran/icons/template.dmi'
	icon_base =            'mods/species/bayliens/tajaran/icons/body.dmi'
	icon_deformed =        'mods/species/bayliens/tajaran/icons/deformed_body.dmi'
	bandages_icon =        'icons/mob/bandage.dmi'
	lip_icon =             'mods/species/bayliens/tajaran/icons/lips.dmi'
	health_hud_intensity = 1.75
	bodytype_flag =        BODY_FLAG_FELINE
	movement_slowdown =    -0.5
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	base_hair_color = "#46321c"
	base_color = "#ae7d32"
	base_eye_color = "#00aa00"
	default_h_style = /decl/sprite_accessory/hair/taj/lynx
	flesh_color = "#ae7d32"

	heat_discomfort_level = 294
	cold_discomfort_level = 230

	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)

	cold_level_1 = 200
	cold_level_2 = 140
	cold_level_3 = 80

	heat_level_1 = 330
	heat_level_2 = 380
	heat_level_3 = 800

	eye_darksight_range = 7
	eye_flash_mod = 2
	eye_blend = ICON_MULTIPLY
	eye_icon = 'mods/species/bayliens/tajaran/icons/eyes.dmi'
	eye_low_light_vision_effectiveness = 0.15
	eye_low_light_vision_adjustment_speed = 0.3

	override_limb_types = list(
		BP_EYES = /obj/item/organ/internal/eyes,
		BP_TAIL = /obj/item/organ/external/tail/cat
	)

	base_markings = list(/decl/sprite_accessory/marking/tajaran/ears = "#ae7d32")

/decl/bodytype/feline/Initialize()
	equip_adjust = list(
		slot_glasses_str =   list("[NORTH]" = list("x" =  0, "y" = 2), "[EAST]" = list("x" = 0, "y" = 2), "[SOUTH]" = list("x" =  0, "y" = 2),  "[WEST]" = list("x" = 0, "y" = 2)),
		slot_wear_mask_str = list("[NORTH]" = list("x" =  0, "y" = 2), "[EAST]" = list("x" = 0, "y" = 2), "[SOUTH]" = list("x" =  0, "y" = 2),  "[WEST]" = list("x" = 0, "y" = 2)),
		slot_head_str =      list("[NORTH]" = list("x" =  0, "y" = 2), "[EAST]" = list("x" = 0, "y" = 2), "[SOUTH]" = list("x" =  0, "y" = 2),  "[WEST]" = list("x" = 0, "y" = 2))
	)
	. = ..()

/obj/item/organ/external/tail/cat
	tail_animation = 'mods/species/bayliens/tajaran/icons/tail.dmi'
	tail = "tajtail"
	tail_blend = ICON_MULTIPLY
