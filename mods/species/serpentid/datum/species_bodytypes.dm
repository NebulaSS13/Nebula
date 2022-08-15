/decl/bodytype/serpentid
	name =              "grey"
	icon_template =     'icons/mob/human_races/species/template_tall.dmi'
	icon_base =         'mods/species/serpentid/icons/body_grey.dmi'
	blood_overlays =    'mods/species/serpentid/icons/blood_overlays.dmi'
	limb_blend =        ICON_MULTIPLY
	bodytype_category = BODYTYPE_SNAKE
	antaghud_offset_y = 8
	bodytype_flag =     BODY_FLAG_SNAKE
	breathing_organ = BP_TRACH
	has_organs = list(
		BP_BRAIN =             /obj/item/organ/internal/brain/insectoid/serpentid,
		BP_EYES =              /obj/item/organ/internal/eyes/insectoid/serpentid,
		BP_TRACH =             /obj/item/organ/internal/lungs/insectoid/serpentid,
		BP_HEART =             /obj/item/organ/internal/heart/open,
		BP_LIVER =             /obj/item/organ/internal/liver/insectoid/serpentid,
		BP_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		BP_SYSTEM_CONTROLLER = /obj/item/organ/internal/controller
	)
	body_appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_SKIN_TONE_NORMAL
	has_limbs = list(
		BP_CHEST =        list("path" = /obj/item/organ/external/chest/insectoid/serpentid),
		BP_GROIN =        list("path" = /obj/item/organ/external/groin/insectoid/serpentid),
		BP_HEAD =         list("path" = /obj/item/organ/external/head/insectoid/serpentid),
		BP_L_ARM =        list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND =       list("path" = /obj/item/organ/external/hand/insectoid),
		BP_L_HAND_UPPER = list("path" = /obj/item/organ/external/hand/insectoid/upper),
		BP_R_ARM =        list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND =       list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_HAND_UPPER = list("path" = /obj/item/organ/external/hand/right/insectoid/upper),
		BP_R_LEG =        list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =        list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT =       list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT =       list("path" = /obj/item/organ/external/foot/right/insectoid)
		)

	limb_mapping = list(
		BP_L_HAND = list(BP_L_HAND, BP_L_HAND_UPPER),
		BP_R_HAND = list(BP_R_HAND, BP_R_HAND_UPPER)
	)
	mob_size = MOB_SIZE_LARGE

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
