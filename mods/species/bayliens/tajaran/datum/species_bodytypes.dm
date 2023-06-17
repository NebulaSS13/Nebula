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
