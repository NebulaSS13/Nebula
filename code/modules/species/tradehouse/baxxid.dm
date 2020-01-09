/datum/species/baxxid
	name = SPECIES_BAXXID
	name_plural = SPECIES_BAXXID
	icobase =         'icons/mob/human_races/species/baxxid/body.dmi'
	deform =          'icons/mob/human_races/species/baxxid/body.dmi'
	preview_icon =    'icons/mob/human_races/species/baxxid/preview.dmi'
	icon_template =   'icons/mob/human_races/species/baxxid/template.dmi'

	limb_blend = ICON_MULTIPLY
	spawn_flags = SPECIES_IS_RESTRICTED
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/baxxid
		)

/obj/item/organ/internal/eyes/baxxid
	eye_icon = 'icons/mob/human_races/species/baxxid/eyes.dmi'

/datum/sprite_accessory/marking/baxxid
	name = "Crest"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_BAXXID)
	icon = 'icons/mob/human_races/species/baxxid/markings.dmi'
	icon_state = "crest"
	blend = ICON_MULTIPLY

/datum/sprite_accessory/marking/baxxid/plates
	name = "Armour Plates"
	body_parts = list(BP_CHEST, BP_GROIN)
	icon_state = "plates"

/datum/sprite_accessory/marking/baxxid/bones
	name = "Bony Segments"
	body_parts = list(BP_CHEST, BP_GROIN, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_R_FOOT, BP_L_FOOT)
	icon_state = "bones"

