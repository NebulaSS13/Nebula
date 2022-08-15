/decl/bodytype/prosthetic/utility_frame
	name =              "humanoid"
	icon_base =         'mods/species/utility_frames/icons/body.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	limb_blend =        ICON_MULTIPLY
	override_limb_types = list(BP_HEAD = /obj/item/organ/external/head/utility_frame)
	body_flags = BODY_FLAG_NO_PAIN
	unavailable_at_chargen = TRUE
	has_organs = list(
		BP_POSIBRAIN = /obj/item/organ/internal/posibrain,
		BP_EYES      = /obj/item/organ/internal/eyes/robot/utility_frame,
		BP_CELL = /obj/item/organ/internal/cell
	)

/decl/bodytype/prosthetic/utility_frame/Initialize()
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
