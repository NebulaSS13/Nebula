/decl/bodytype/serpentid
	name =              "grey"
	icon_template =     'icons/mob/human_races/species/template_tall.dmi'
	icon_base =         'mods/species/serpentid/icons/body_grey.dmi'
	blood_overlays =    'mods/species/serpentid/icons/blood_overlays.dmi'
	limb_blend =        ICON_MULTIPLY
	bodytype_category = BODYTYPE_SNAKE
	antaghud_offset_y = 8
	bodytype_flag =     BODY_FLAG_SNAKE

/decl/bodytype/serpentid/Initialize()
	equip_adjust = list(
		BP_L_HAND_UPPER =  list("[NORTH]" = list("x" =  0, "y" = 8),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" = -0, "y" = 8),  "[WEST]" = list("x" =  0, "y" = 8)),
		BP_R_HAND_UPPER =  list("[NORTH]" = list("x" =  0, "y" = 8),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" =  0, "y" = 8),  "[WEST]" = list("x" =  0, "y" = 8)),
		BP_L_HAND =        list("[NORTH]" = list("x" =  4, "y" = 0),  "[EAST]" = list("x" = 0, "y" = 0),  "[SOUTH]" = list("x" = -4, "y" = 0),  "[WEST]" = list("x" =  0, "y" = 0)),
		BP_R_HAND =        list("[NORTH]" = list("x" = -4, "y" = 0),  "[EAST]" = list("x" = 0, "y" = 0),  "[SOUTH]" = list("x" =  4, "y" = 0),  "[WEST]" = list("x" =  0, "y" = 0)),
		slot_head_str =    list("[NORTH]" = list("x" =  0, "y" = 7),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" =  0, "y" = 8),  "[WEST]" = list("x" =  0, "y" = 8)),
		slot_back_str =    list("[NORTH]" = list("x" =  0, "y" = 7),  "[EAST]" = list("x" = 0, "y" = 8),  "[SOUTH]" = list("x" =  0, "y" = 8),  "[WEST]" = list("x" =  0, "y" = 8)),
		slot_belt_str =    list("[NORTH]" = list("x" =  0, "y" = 0),  "[EAST]" = list("x" = 8, "y" = 0),  "[SOUTH]" = list("x" =  0, "y" = 0),  "[WEST]" = list("x" = -8, "y" = 0)),
		slot_glasses_str = list("[NORTH]" = list("x" =  0, "y" = 10), "[EAST]" = list("x" = 0, "y" = 11), "[SOUTH]" = list("x" =  0, "y" = 11), "[WEST]" = list("x" =  0, "y" = 11))
	)
	. = ..()

/decl/bodytype/serpentid/green
	name = "green"
	icon_base = 'mods/species/serpentid/icons/body_green.dmi'
