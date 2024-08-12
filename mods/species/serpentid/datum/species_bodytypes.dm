/decl/bodytype/serpentid
	name =              "grey"
	icon_template =     'icons/mob/human_races/species/template_tall.dmi'
	icon_base =         'mods/species/serpentid/icons/body_grey.dmi'
	blood_overlays =    'mods/species/serpentid/icons/blood_overlays.dmi'
	limb_blend =        ICON_MULTIPLY
	bodytype_category = BODYTYPE_SNAKE
	antaghud_offset_y = 8
	bodytype_flag =     BODY_FLAG_SNAKE
	movement_slowdown = -0.5
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_SKIN_TONE_NORMAL
	base_color =      "#336600"
	base_eye_color =  "#3f0505"
	mob_size = MOB_SIZE_LARGE
	has_organ = list(
		BP_BRAIN           = /obj/item/organ/internal/brain/insectoid/serpentid,
		BP_EYES            = /obj/item/organ/internal/eyes/insectoid/serpentid,
		BP_TRACH           = /obj/item/organ/internal/lungs/insectoid/serpentid,
		BP_HEART           = /obj/item/organ/internal/heart/open,
		BP_LIVER           = /obj/item/organ/internal/liver/insectoid/serpentid,
		BP_STOMACH         = /obj/item/organ/internal/stomach/insectoid,
		BP_PHEROMONE_GLAND = /obj/item/organ/internal/pheromone_gland
	)
	age_descriptor = /datum/appearance_descriptor/age/serpentid
	eye_darksight_range = 8
	eye_innate_flash_protection = FLASH_PROTECTION_VULNERABLE
	eye_contaminant_guard = 1
	eye_icon = 'mods/species/serpentid/icons/eyes.dmi'
	uid = "bodytype_serpentid"

	has_limbs = list(
		BP_CHEST        = list("path" = /obj/item/organ/external/chest/insectoid/serpentid),
		BP_GROIN        = list("path" = /obj/item/organ/external/groin/insectoid/serpentid),
		BP_HEAD         = list("path" = /obj/item/organ/external/head/insectoid/serpentid),
		BP_L_ARM        = list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND       = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_L_HAND_UPPER = list("path" = /obj/item/organ/external/hand/insectoid/upper),
		BP_R_ARM        = list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND       = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_HAND_UPPER = list("path" = /obj/item/organ/external/hand/right/insectoid/upper),
		BP_R_LEG        = list("path" = /obj/item/organ/external/leg/right/insectoid/serpentid),
		BP_L_LEG        = list("path" = /obj/item/organ/external/leg/insectoid/serpentid),
		BP_L_FOOT       = list("path" = /obj/item/organ/external/foot/insectoid/serpentid),
		BP_R_FOOT       = list("path" = /obj/item/organ/external/foot/right/insectoid/serpentid)
	)
	appearance_descriptors = list(
		/datum/appearance_descriptor/height =      1.75,
		/datum/appearance_descriptor/body_length = 1
	)
	limb_mapping = list(
		BP_L_HAND = list(BP_L_HAND, BP_L_HAND_UPPER),
		BP_R_HAND = list(BP_R_HAND, BP_R_HAND_UPPER)
	)
	breathing_organ =  BP_TRACH
	heat_level_1 = 410 //Default 360 - Higher is better
	heat_level_2 = 440 //Default 400
	heat_level_3 = 800 //Default 1000

/decl/bodytype/serpentid/Initialize()
	equip_adjust = list(
		BP_L_HAND_UPPER =  list("[NORTH]" = list( 0, 8),  "[EAST]" = list(0, 8),  "[SOUTH]" = list(-0, 8),  "[WEST]" = list( 0, 8)),
		BP_R_HAND_UPPER =  list("[NORTH]" = list( 0, 8),  "[EAST]" = list(0, 8),  "[SOUTH]" = list( 0, 8),  "[WEST]" = list( 0, 8)),
		BP_L_HAND =        list("[NORTH]" = list( 4, 0),  "[EAST]" = list(0, 0),  "[SOUTH]" = list(-4, 0),  "[WEST]" = list( 0, 0)),
		BP_R_HAND =        list("[NORTH]" = list(-4, 0),  "[EAST]" = list(0, 0),  "[SOUTH]" = list( 4, 0),  "[WEST]" = list( 0, 0)),
		slot_head_str =    list("[NORTH]" = list( 0, 7),  "[EAST]" = list(0, 8),  "[SOUTH]" = list( 0, 8),  "[WEST]" = list( 0, 8)),
		slot_back_str =    list("[NORTH]" = list( 0, 7),  "[EAST]" = list(0, 8),  "[SOUTH]" = list( 0, 8),  "[WEST]" = list( 0, 8)),
		slot_belt_str =    list("[NORTH]" = list( 0, 0),  "[EAST]" = list(8, 0),  "[SOUTH]" = list( 0, 0),  "[WEST]" = list(-8, 0)),
		slot_glasses_str = list("[NORTH]" = list( 0, 10), "[EAST]" = list(0, 11), "[SOUTH]" = list( 0, 11), "[WEST]" = list( 0, 11))
	)
	. = ..()

/decl/bodytype/serpentid/green
	name = "green"
	icon_base = 'mods/species/serpentid/icons/body_green.dmi'
	uid = "bodytype_serpentid_green"
