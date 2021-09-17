/decl/bodytype/avian
	name =              "avian"
	bodytype_category = BODYTYPE_AVIAN
	icon_base =         'mods/species/neoavians/icons/body.dmi'
	blood_mask =        'mods/species/neoavians/icons/blood_avian.dmi'
	tail_icon =         'mods/species/neoavians/icons/tail.dmi'
	limb_blend =        ICON_MULTIPLY
	tail_blend =        ICON_MULTIPLY
	tail =              "tail_avian"
	bodytype_flag =     BODY_FLAG_AVIAN

/decl/bodytype/avian/raptor
	name =              "raptor"
	icon_base =         'mods/species/neoavians/icons/body_raptor.dmi'
	tail =              "tail_raptor"
	tail_hair =         "over"
	tail_hair_blend =   ICON_MULTIPLY

/decl/bodytype/avian/additive
	name =              "avian, additive"
	icon_base =         'mods/species/neoavians/icons/body_add.dmi'
	health_hud_intensity = 3
	limb_blend =        ICON_ADD
	tail_blend =        ICON_ADD
	tail =              "tail_avian_add"

/decl/bodytype/avian/additive/raptor
	name =              "raptor, additive"
	icon_base =         'mods/species/neoavians/icons/body_raptor_add.dmi'
	tail =              "tail_raptor_add"
	tail_hair =         "over"
	tail_hair_blend =   ICON_ADD

/decl/bodytype/avian/Initialize()
	equip_adjust = list(
		BP_L_HAND =          list("[NORTH]" = list("x" =  3, "y" = -3), "[EAST]" = list("x" =  1, "y" = -3), "[SOUTH]" = list("x" = -3, "y" = -3),  "[WEST]" = list("x" = -5, "y" = -3)),
		BP_R_HAND =          list("[NORTH]" = list("x" = -3, "y" = -3), "[EAST]" = list("x" =  5, "y" = -3), "[SOUTH]" = list("x" =  3, "y" = -3),  "[WEST]" = list("x" = -1, "y" = -3)),
		slot_head_str =      list("[NORTH]" = list("x" =  0, "y" = -5), "[EAST]" = list("x" =  1, "y" = -5), "[SOUTH]" = list("x" =  0, "y" = -5),  "[WEST]" = list("x" = -1, "y" = -5)),
		slot_wear_mask_str = list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" =  2, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" = -2, "y" = -6)),
		slot_glasses_str =   list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" =  1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" = -1, "y" = -6)),
		slot_back_str =      list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" =  3, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" = -3, "y" = -6)),
		slot_w_uniform_str = list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6)),
		slot_tie_str       = list("[NORTH]" = list("x" =  0, "y" = -5), "[EAST]" = list("x" =  0, "y" = -5), "[SOUTH]" = list("x" =  0, "y" = -5),  "[WEST]" = list("x" =  0, "y" = -5)),
		slot_wear_id_str =   list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6)),
		slot_wear_suit_str = list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6)),
		slot_belt_str =      list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6))
	)
	. = ..()
