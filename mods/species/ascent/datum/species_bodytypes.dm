/decl/bodytype/alate
	name =              "alate"
	bodytype_category = BODYTYPE_MANTID_SMALL
	icon_base =         'mods/species/ascent/icons/species/body/alate/body.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/alate/blood_overlays.dmi'
	associated_gender = MALE
	bodytype_flag =     BODY_FLAG_ALATE

/decl/bodytype/gyne
	name =              "gyne"
	bodytype_category = BODYTYPE_MANTID_LARGE
	icon_base =         'mods/species/ascent/icons/species/body/gyne/body.dmi'
	icon_template =     'mods/species/ascent/icons/species/body/gyne/template.dmi'
	damage_overlays =   'mods/species/ascent/icons/species/body/gyne/damage_overlays.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/gyne/blood_overlays.dmi'
	pixel_offset_x =    -4
	antaghud_offset_y = 18
	antaghud_offset_x = 4
	associated_gender = FEMALE
	bodytype_flag =     BODY_FLAG_GYNE

/decl/bodytype/gyne/Initialize()
	equip_adjust = list(
		BP_L_HAND = list(
			"[NORTH]" = list("x" = -4, "y" = 12),
			"[EAST]" = list("x" =  -4, "y" = 12),
			"[SOUTH]" = list("x" = -4, "y" = 12),
			"[WEST]" = list("x" =  -4, "y" = 12)
		)
	)
	. = ..()

/decl/bodytype/serpentid
	name =              "grey"
	icon_template =     'icons/mob/human_races/species/template_tall.dmi'
	icon_base =         'mods/species/ascent/icons/species/body/serpentid/body_grey.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/serpentid/blood_overlays.dmi'
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
	icon_base =     'mods/species/ascent/icons/species/body/serpentid/body_green.dmi'
