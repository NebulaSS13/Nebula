/decl/bodytype/mantid
	name =              "alate"
	bodytype_category = BODYTYPE_MANTID_SMALL
	icon_base =         'mods/species/ascent/icons/species/body/alate/body.dmi'
	blood_overlays =    'mods/species/ascent/icons/species/body/alate/blood_overlays.dmi'
	associated_gender = MALE
	bodytype_flag =     BODY_FLAG_ALATE
	body_appearance_flags = 0

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/insectoid),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/mantid),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_M_HAND = list("path" = /obj/item/organ/external/hand/insectoid/midlimb),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid)
	)

	has_organs = list(
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
	pain_emotes_with_pain_level = list(
			list(/decl/emote/visible/ascent_shine, /decl/emote/visible/ascent_dazzle) = 80,
			list(/decl/emote/visible/ascent_glimmer, /decl/emote/visible/ascent_pulse) = 50,
			list(/decl/emote/visible/ascent_flicker, /decl/emote/visible/ascent_glint) = 20,
		)

/decl/bodytype/mantid/gyne
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
	override_limb_types = list(
		BP_HEAD = /obj/item/organ/external/head/insectoid/mantid,
		BP_GROIN = /obj/item/organ/external/groin/insectoid/mantid/gyne,
	)
	override_organ_types = list(
		BP_EGG = /obj/item/organ/internal/egg_sac/insectoid,
	)
	body_appearance_flags = 0
	pain_emotes_with_pain_level = list(
			list(/decl/emote/visible/ascent_shine, /decl/emote/visible/ascent_dazzle) = 80,
			list(/decl/emote/visible/ascent_glimmer, /decl/emote/visible/ascent_pulse) = 50,
			list(/decl/emote/visible/ascent_flicker, /decl/emote/visible/ascent_glint) = 20,
		)

/decl/bodytype/mantid/gyne/Initialize()
	equip_adjust = list(
		BP_L_HAND = list(
			"[NORTH]" = list("x" = -4, "y" = 12),
			"[EAST]" = list("x" =  -4, "y" = 12),
			"[SOUTH]" = list("x" = -4, "y" = 12),
			"[WEST]" = list("x" =  -4, "y" = 12)
		)
	)
	. = ..()

