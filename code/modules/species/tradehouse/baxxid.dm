/datum/species/baxxid
	name = SPECIES_BAXXID
	name_plural = SPECIES_BAXXID
	icobase =         'icons/mob/human_races/species/baxxid/body.dmi'
	deform =          'icons/mob/human_races/species/baxxid/body.dmi'
	preview_icon =    'icons/mob/human_races/species/baxxid/preview.dmi'
	icon_template =   'icons/mob/human_races/species/baxxid/template.dmi'
	manual_dexterity = DEXTERITY_KEYBOARDS
	mob_size = MOB_LARGE

	unarmed_attacks = list(
		/datum/unarmed_attack/claws/strong/baxxid,
		/datum/unarmed_attack/bite/strong
	)

	hud_type = /datum/hud_data/baxxid
	limb_blend = ICON_MULTIPLY
	species_flags = SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NO_SLIP
	spawn_flags = SPECIES_CAN_JOIN
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

/datum/language/baxxid
/datum/species/baxxid/handle_autohiss(message, datum/language/lang, mode)
	. = message
	if(!istype(lang, /datum/language/baxxid))
		var/hnnn = "H"
		for(var/i = 1 to rand(3,5))
			hnnn += "n"
		var/first_char = copytext(message, 1, 1)
		if(first_char != lowertext(first_char))
			hnnn = uppertext(capitalize(hnnn))
		. = "[hnnn][uppertext(.)]"

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

