/datum/species/yinglet
	name = SPECIES_YINGLET
	name_plural = "Yinglets"
	description = "Clams?"
	autohiss_basic_map = list("th" = list("z"))
	icobase =  'icons/mob/human_races/species/yinglet/body.dmi'
	deform =  'icons/mob/human_races/species/yinglet/body.dmi'
	limb_blend = ICON_MULTIPLY
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/yinglet
		)
	descriptors = list(
		/datum/mob_descriptor/height = -3,
		/datum/mob_descriptor/build =  -3
	)

/datum/species/yinglet/New()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -3),  
			"[EAST]" =  list("x" = 3,  "y" = -3),  
			"[WEST]" =  list("x" = -3, "y" = -3),  
			"[SOUTH]" = list("x" = 0,  "y" = -3)
		),
		slot_back_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -5),  
			"[EAST]" =  list("x" = 3,  "y" = -5),  
			"[WEST]" =  list("x" = -3, "y" = -5),  
			"[SOUTH]" = list("x" = 0,  "y" = -5)
		),
		slot_belt_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -1),  
			"[EAST]" =  list("x" = 2,  "y" = -1),  
			"[WEST]" =  list("x" = -2, "y" = -1),  
			"[SOUTH]" = list("x" = 0,  "y" = -1)
		),
		slot_glasses_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -3),  
			"[EAST]" =  list("x" = 2,  "y" = -3),  
			"[WEST]" =  list("x" = -2, "y" = -3),  
			"[SOUTH]" = list("x" = 0,  "y" = -3)
		),
		slot_l_hand_str = list(
			"[NORTH]" = list("x" = 2,  "y" = -3),  
			"[EAST]" =  list("x" = 2,  "y" = -3),  
			"[WEST]" =  list("x" = -2, "y" = -3),  
			"[SOUTH]" = list("x" = -2, "y" = -3)
		),
		slot_r_hand_str = list(
			"[NORTH]" = list("x" = -2, "y" = -3),  
			"[EAST]" =  list("x" = 2,  "y" = -3),  
			"[WEST]" =  list("x" = -2, "y" = -3),  
			"[SOUTH]" = list("x" = 2,  "y" = -3)
		)
	)
	..()



