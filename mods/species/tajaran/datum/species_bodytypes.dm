/decl/bodytype/feline
	name =                 "humanoid"
	bodytype_category =    BODYTYPE_FELINE
	limb_blend =           ICON_MULTIPLY
	icon_base =            'mods/species/tajaran/icons/body.dmi'
	icon_deformed =        'mods/species/tajaran/icons/deformed_body.dmi'
	bandages_icon =        'icons/mob/bandage.dmi'
	lip_icon =             'mods/species/tajaran/icons/lips.dmi'
	health_hud_intensity = 1.75
	bodytype_flag =        BODY_FLAG_FELINE

/decl/bodytype/feline/Initialize()
	equip_adjust = list(
		BP_L_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		BP_R_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_wear_id_str =    list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_gloves_str =     list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_wear_suit_str =  list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_w_uniform_str =  list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_back_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_belt_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_underpants_str = list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2)),
		slot_undershirt_str = list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = 0, "y" = -2))
	)
	. = ..()

/obj/item/organ/external/tail/cat
	tail_animation = 'mods/species/tajaran/icons/tail.dmi'
	tail = "tajtail"
	tail_blend = ICON_MULTIPLY
