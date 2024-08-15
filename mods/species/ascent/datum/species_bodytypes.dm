/decl/bodytype/crystalline/mantid
	abstract_type = /decl/bodytype/crystalline/mantid
	eye_flash_mod =     2 // Highly photosensitive.
	age_descriptor = /datum/appearance_descriptor/age/kharmaani
	appearance_flags =  0
	is_brittle = FALSE
	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/insectoid),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/mantid),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_M_HAND = list("path" = /obj/item/organ/external/hand/insectoid/midlimb),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid/mantid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid/mantid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid/mantid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid/mantid)
	)

	has_organ = list(
		BP_HEART =             /obj/item/organ/internal/heart/insectoid,
		BP_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		BP_LUNGS =             /obj/item/organ/internal/lungs/insectoid,
		BP_LIVER =             /obj/item/organ/internal/liver/insectoid,
		BP_KIDNEYS =           /obj/item/organ/internal/kidneys/insectoid,
		BP_BRAIN =             /obj/item/organ/internal/brain/insectoid,
		BP_EYES =              /obj/item/organ/internal/eyes/insectoid,
		BP_SYSTEM_CONTROLLER = /obj/item/organ/internal/controller
	)
	limb_mapping = list(BP_CHEST = list(BP_CHEST, BP_M_HAND))

	heat_discomfort_strings = list(
		"You feel brittle and overheated.",
		"Your overheated carapace flexes uneasily.",
		"Overheated ichor trickles from your eyes."
	)
	cold_discomfort_strings = list(
		"Frost forms along your carapace.",
		"You hear a faint crackle of ice as you shift your freezing body.",
		"Your movements become sluggish under the weight of the chilly conditions."
	)
	appearance_descriptors = list(
		/datum/appearance_descriptor/height =      0.75,
		/datum/appearance_descriptor/body_length = 0.5
	)

/decl/bodytype/crystalline/mantid/alate
	name =              "alate"
	bodytype_category = BODYTYPE_MANTID_SMALL
	icon_base =         'mods/species/ascent/icons/species/body/alate/body.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/alate/blood_overlays.dmi'
	associated_gender = MALE
	bodytype_flag =     BODY_FLAG_ALATE
	movement_slowdown = -1
	uid = "bodytype_crystalline_alate"

/decl/bodytype/crystalline/mantid/gyne
	name =              "gyne"
	bodytype_category = BODYTYPE_MANTID_LARGE
	icon_base =         'mods/species/ascent/icons/species/body/gyne/body.dmi'
	icon_template =     'mods/species/ascent/icons/species/body/gyne/template.dmi'
	damage_overlays =   'mods/species/ascent/icons/species/body/gyne/damage_overlays.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/gyne/blood_overlays.dmi'
	pixel_offset_x =    -4
	antaghud_offset_y = 18
	antaghud_offset_x = 4
	associated_gender = FEMALE
	bodytype_flag =     BODY_FLAG_GYNE
	eye_flash_mod =     2 // Highly photosensitive.
	movement_slowdown = 2
	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/insectoid/mantid/gyne
	)
	override_organ_types = list(
		BP_EGG = /obj/item/organ/internal/egg_sac/insectoid,
	)
	age_descriptor = /datum/appearance_descriptor/age/kharmaani/gyne
	appearance_descriptors = list(
		/datum/appearance_descriptor/height =      2,
		/datum/appearance_descriptor/body_length = 1.25
	)
	z_flags = ZMM_WIDE_LOAD
	uid = "bodytype_crystalline_gyne"

/decl/bodytype/crystalline/mantid/gyne/Initialize()
	equip_adjust = list(
		BP_L_HAND = list(
			"[NORTH]" = list(-4, 12),
			"[EAST]"  = list(-4, 12),
			"[SOUTH]" = list(-4, 12),
			"[WEST]"  = list(-4, 12)
		)
	)
	. = ..()

