/decl/bodytype/vox
	name =              "voxform"
	bodytype_category = BODYTYPE_VOX
	icon_base =         'mods/species/vox/icons/body/body.dmi'
	icon_deformed =     'mods/species/vox/icons/body/deformed_body.dmi'
	husk_icon =         'mods/species/vox/icons/body/husk.dmi'
	blood_overlays =        'mods/species/vox/icons/body/blood_overlays.dmi'
	bodytype_flag =     BODY_FLAG_VOX
	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox
	)
	has_organs = list(
		BP_STOMACH =    /obj/item/organ/internal/stomach/vox,
		BP_HEART =      /obj/item/organ/internal/heart/vox,
		BP_LUNGS =      /obj/item/organ/internal/lungs/vox,
		BP_LIVER =      /obj/item/organ/internal/liver/vox,
		BP_KIDNEYS =    /obj/item/organ/internal/kidneys/vox,
		BP_BRAIN =      /obj/item/organ/internal/brain,
		BP_EYES =       /obj/item/organ/internal/eyes/vox,
		BP_STACK =      /obj/item/organ/internal/voxstack,
		BP_HINDTONGUE = /obj/item/organ/internal/hindtongue
		)
	override_limb_types = list(BP_TAIL = /obj/item/organ/external/tail/vox)

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

/obj/item/organ/external/tail/vox
	tail =              "voxtail"
	tail_icon =         'mods/species/vox/icons/body/tail.dmi'
	tail_blend =        ICON_OVERLAY
