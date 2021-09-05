/decl/bodytype/resomi
	name = "resomi body"
	bodytype_category = BODYTYPE_RESOMI

	limb_blend        = ICON_MULTIPLY
	tail_blend        = ICON_MULTIPLY

	icon_base         = 'mods/species/resomi/icons/body.dmi'
	icon_deformed     = 'mods/species/resomi/icons/body.dmi'
	damage_overlays   = 'mods/species/resomi/icons/damage_overlay.dmi'
	damage_mask       = 'mods/species/resomi/icons/damage_mask.dmi'
	blood_mask        = 'mods/species/resomi/icons/blood_mask.dmi'

	husk_icon         = 'mods/species/resomi/icons/husk.dmi'
	tail_icon         = 'mods/species/resomi/icons/tail.dmi'
	tail              = "tail"
	tail_hair         = "feathers_s"

/decl/bodytype/resomi/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list("x" = 0, "y" = -6),
			"[EAST]" =  list("x" = 0, "y" = -6),
			"[WEST]" =  list("x" = 0, "y" = -6),
			"[SOUTH]" = list("x" = 0, "y" = -6)
		),
		slot_back_str = list(
			"[NORTH]" = list("x" = 0, "y" = -5),
			"[EAST]" =  list("x" = 3, "y" = -5),
			"[WEST]" =  list("x" = -3,"y" = -5),
			"[SOUTH]" = list("x" = 0, "y" = -5)
		),
		slot_belt_str = list(
			"[NORTH]" = list("x" = 0, "y" = -3),
			"[EAST]" =  list("x" = 2, "y" = -3),
			"[WEST]" =  list("x" = -2,"y" = -3),
			"[SOUTH]" = list("x" = 0, "y" = -3)
		),
		slot_l_hand_str = list(
			"[NORTH]" = list("x" = 0, "y" = -3),
			"[EAST]" =  list("x" = 0, "y" = -3),
			"[WEST]" =  list("x" = 0, "y" = -3),
			"[SOUTH]" = list("x" = 0, "y" = -3)
		),
		slot_r_hand_str = list(
			"[NORTH]" = list("x" = 0, "y" = -3),
			"[EAST]" =  list("x" = 0, "y" = -3),
			"[WEST]" =  list("x" = 0, "y" = -3),
			"[SOUTH]" = list("x" = 0, "y" = -3)
		),
		slot_wear_mask_str = list(
			"[NORTH]" = list("x" = 0, "y" = -4),
			"[EAST]" =  list("x" = 2, "y" = -4),
			"[WEST]" =  list("x" = -2,"y" = -4),
			"[SOUTH]" = list("x" = 0, "y" = -4)
		),
		slot_glasses_str = list(
			"[NORTH]" = list("x" = 0, "y" = -6),
			"[EAST]" =  list("x" = 0, "y" = -6),
			"[WEST]" =  list("x" = 0, "y" = -6),
			"[SOUTH]" = list("x" = 0, "y" = -6)
		),
		slot_l_ear_str = list(
			"[NORTH]" = list("x" = 1, "y" = -4),
			"[EAST]" =  list("x" = 0, "y" = -4),
			"[WEST]" =  list("x" = 0, "y" = -4),
			"[SOUTH]" = list("x" = -1,"y" = -4)
		),
		slot_r_ear_str = list(
			"[NORTH]" = list("x" = -1,"y" = -4),
			"[EAST]" =  list("x" = 0, "y" = -4),
			"[WEST]" =  list("x" = 0, "y" = -4),
			"[SOUTH]" = list("x" = 1, "y" = -4)
		)
	)
	. = ..()
