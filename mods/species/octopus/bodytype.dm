/datum/appearance_descriptor/age/octopus
	chargen_min_index = 3
	chargen_max_index = 5
	standalone_value_descriptors = list(
		"freshly hatched" =      1,
		"a larva" =              2,
		"a juvenile" =           5,
		"a young adult" =       10,
		"an adult" =            15,
		"approaching old age" = 30,
		"senescent" =           40
	)

/decl/bodytype/octopus
	name = "octopode"
	uid = "bodytype_octopus"
	eye_icon = 'mods/species/octopus/icons/eyes.dmi'
	age_descriptor = /datum/appearance_descriptor/age/octopus
	movement_slowdown = 2
	pixel_offset_x = -8

	bodytype_category = BODYTYPE_OCTOPODE
	icon_base =         'mods/species/octopus/icons/body.dmi'
	icon_deformed =     'mods/species/octopus/icons/body.dmi'
	icon_template =     'mods/species/octopus/icons/template.dmi'
	damage_overlays =   'mods/species/octopus/icons/dam_octopus.dmi'
	blood_overlays =    'mods/species/octopus/icons/blood_octopus.dmi'

	body_flags = BODY_FLAG_NO_DNA
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR
	has_organ = list(
		(BP_HEART)   = /obj/item/organ/internal/heart/octopus,
		(BP_LUNGS)   = /obj/item/organ/internal/lungs/gills/octopus,
		(BP_LIVER)   = /obj/item/organ/internal/liver,
		(BP_KIDNEYS) = /obj/item/organ/internal/kidneys,
		(BP_BRAIN)   = /obj/item/organ/internal/brain,
		(BP_EYES)    = /obj/item/organ/internal/eyes,
	)

	has_limbs = list(
		(BP_CHEST)      = list("path" = /obj/item/organ/external/chest/unbreakable/octopus),
		(BP_GROIN)      = list("path" = /obj/item/organ/external/groin/unbreakable/octopus),
		(BP_HEAD)       = list("path" = /obj/item/organ/external/head/unbreakable/octopus),
		(BP_TENTACLE_1) = list("path" = /obj/item/organ/external/octopus_limb/first),
		(BP_TENTACLE_2) = list("path" = /obj/item/organ/external/octopus_limb/second),
		(BP_TENTACLE_3) = list("path" = /obj/item/organ/external/octopus_limb/third),
		(BP_TENTACLE_4) = list("path" = /obj/item/organ/external/octopus_limb/fourth),
		(BP_TENTACLE_5) = list("path" = /obj/item/organ/external/octopus_limb/fifth),
		(BP_TENTACLE_6) = list("path" = /obj/item/organ/external/octopus_limb/sixth),
		(BP_TENTACLE_7) = list("path" = /obj/item/organ/external/octopus_limb/seventh),
		(BP_TENTACLE_8) = list("path" = /obj/item/organ/external/octopus_limb/eighth)
	)
	limb_mapping = list(
		(BP_L_LEG)  = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8)),
		(BP_R_LEG)  = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8)),
		(BP_L_FOOT) = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8)),
		(BP_R_FOOT) = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8)),
		(BP_L_ARM)  = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8)),
		(BP_R_ARM)  = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8)),
		(BP_L_HAND) = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8)),
		(BP_R_HAND) = list((BP_TENTACLE_1), (BP_TENTACLE_2), (BP_TENTACLE_3), (BP_TENTACLE_4), (BP_TENTACLE_5), (BP_TENTACLE_6), (BP_TENTACLE_7), (BP_TENTACLE_8))
	)

/decl/bodytype/octopus/get_movement_slowdown(var/mob/living/human/H)
	return H?.loc?.get_fluid_depth() >= FLUID_SHALLOW ? -1 : ..()

/decl/bodytype/octopus/Initialize()
	_equip_adjust = list(
		(slot_head_str) = list(
			"[NORTH]" = list( 8, -4),
			"[EAST]"  = list(-2, -4),
			"[SOUTH]" = list( 8, -4),
			"[WEST]"  = list(18, -4)
		),
		(slot_back_str) = list(
			"[NORTH]" = list( 8, -8),
			"[EAST]"  = list( 6, -8),
			"[SOUTH]" = list( 8, -8),
			"[WEST]"  = list(12, -8)
		),
		(BP_L_HAND) = list(
			"[NORTH]" = list( 8, -4),
			"[EAST]"  = list( 8, -4),
			"[SOUTH]" = list( 8, -4),
			"[WEST]"  = list( 8, -4)
		),
		(BP_R_HAND) = list(
			"[NORTH]" = list( 8, -4),
			"[EAST]"  = list( 8, -4),
			"[SOUTH]" = list( 8, -4),
			"[WEST]"  = list( 8, -4)
		)
	)
	. = ..()
