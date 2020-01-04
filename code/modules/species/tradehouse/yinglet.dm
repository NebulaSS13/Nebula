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
