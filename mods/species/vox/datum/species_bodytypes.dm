/decl/bodytype/vox
	name =              "voxform"
	bodytype_category = BODYTYPE_VOX
	icon_base =         'mods/species/vox/icons/body/body.dmi'
	icon_deformed =     'mods/species/vox/icons/body/deformed_body.dmi'
	husk_icon =         'mods/species/vox/icons/body/husk.dmi'
	damage_mask =       'mods/species/vox/icons/body/damage_mask.dmi'
	blood_mask =        'mods/species/vox/icons/body/blood_mask.dmi'
	tail =              "voxtail"
	tail_icon =         'mods/species/vox/icons/body/tail.dmi'
	tail_blend =        ICON_OVERLAY
	bodytype_flag =     BODY_FLAG_VOX

/decl/bodytype/vox/Initialize()
	equip_adjust = list(
		BP_L_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" =  0, "y" = -2)),
		BP_R_HAND =           list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" =  0, "y" = -2)),
		slot_head_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 3, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" = -3, "y" = -2)),
		slot_wear_mask_str =  list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 4, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -4, "y" =  0)),
		slot_wear_suit_str =  list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
		slot_w_uniform_str =  list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
		slot_underpants_str = list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
		slot_undershirt_str = list("[NORTH]" = list("x" =  0, "y" = -1), "[EAST]" = list("x" = 0, "y" = -1), "[SOUTH]" = list("x" =  0, "y" = -1),  "[WEST]" = list("x" =  0, "y" = -1)),
		slot_back_str =       list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 3, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -3, "y" =  0))
	)
	. = ..()
