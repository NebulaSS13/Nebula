/decl/bodytype/vox
	name =              "voxform"
	bodytype_category = BODYTYPE_VOX
	icon_base =         'mods/species/vox/icons/body/body.dmi'
	icon_deformed =     'mods/species/vox/icons/body/deformed_body.dmi'
	husk_icon =         'mods/species/vox/icons/body/husk.dmi'
	damage_overlays =   'mods/species/vox/icons/body/damage_overlay.dmi'
	damage_mask =       'mods/species/vox/icons/body/damage_mask.dmi'
	blood_mask =        'mods/species/vox/icons/body/blood_mask.dmi'

/decl/bodytype/vox/Initialize()
	equip_adjust = list(
		BP_L_HAND =           list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		BP_R_HAND =           list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_head_str =       list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 3, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -3, "y" =  0)),
		slot_wear_mask_str =  list("[NORTH]" = list("x" =  0, "y" =  0), "[EAST]" = list("x" = 4, "y" =  0), "[SOUTH]" = list("x" =  0, "y" =  0),  "[WEST]" = list("x" = -4, "y" =  0)),
		slot_back_str =       list("[NORTH]" = list("x" =  0, "y" = -2), "[EAST]" = list("x" = 0, "y" = -2), "[SOUTH]" = list("x" =  0, "y" = -2),  "[WEST]" = list("x" =  0, "y" = -2)),
		slot_wear_suit_str =  list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_w_uniform_str =  list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_underpants_str = list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3)),
		slot_undershirt_str = list("[NORTH]" = list("x" =  0, "y" = -3), "[EAST]" = list("x" = 0, "y" = -3), "[SOUTH]" = list("x" =  0, "y" = -3),  "[WEST]" = list("x" =  0, "y" = -3))
	)
	. = ..()
