/decl/bodytype/utility_frame
	name =              "humanoid"
	icon_base =         'mods/species/utility_frames/icons/body.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	limb_blend =        ICON_MULTIPLY

/decl/bodytype/utility_frame/Initialize()
	equip_adjust = list(
		"[slot_l_ear_str]" =  list(
			"[NORTH]" = list("x" =  2, "y" = 0),
			"[EAST]"  = list("x" =  0, "y" = 0),
			"[SOUTH]" = list("x" = -2, "y" = 0),
			"[WEST]"  = list("x" =  0, "y" = 0)
		),
		"[slot_r_ear_str]" =  list(
			"[NORTH]" = list("x" = -2, "y" = 0),
			"[EAST]"  = list("x" =  0, "y" = 0),
			"[SOUTH]" = list("x" =  2, "y" = 0),
			"[WEST]"  = list("x" =  0, "y" = 0)
		)
	)
	. = ..()
