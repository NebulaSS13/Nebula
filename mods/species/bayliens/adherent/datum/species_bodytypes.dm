/decl/bodytype/crystalline/adherent
	name = "turquoise"
	desc = "A gleaming crystalline mass."
	bodytype_category =         BODYTYPE_ADHERENT
	icon_template =             'mods/species/bayliens/adherent/icons/template.dmi'
	icon_base =                 'mods/species/bayliens/adherent/icons/body_turquoise.dmi'
	damage_overlays =           'mods/species/bayliens/adherent/icons/damage_overlay.dmi'
	blood_overlays =            'mods/species/bayliens/adherent/icons/blood_overlays.dmi'
	antaghud_offset_y =         14
	movement_slowdown =         -1
	appearance_flags =          HAS_EYE_COLOR
	body_flags =                BODY_FLAG_CRYSTAL_REFORM | BODY_FLAG_NO_DNA | BODY_FLAG_NO_PAIN | BODY_FLAG_NO_EAT | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	base_eye_color =            COLOR_LIME
	modifier_string =           "crystalline"
	is_robotic =                FALSE
	mob_size =                  MOB_SIZE_LARGE
	arterial_bleed_multiplier = 0
	age_descriptor = /datum/appearance_descriptor/age/adherent
	apply_encased =             list(
		BP_CHEST = "ceramic hull",
		BP_GROIN = "ceramic hull",
		BP_HEAD  = "ceramic hull"
	)
	vital_organs = list(
		BP_BRAIN,
		BP_CELL
	)
	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/crystal),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/crystal),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/crystal),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/crystal),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/crystal),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/crystal),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/crystal),
		BP_L_LEG =  list("path" = /obj/item/organ/external/tendril),
		BP_R_LEG =  list("path" = /obj/item/organ/external/tendril/two),
		BP_L_FOOT = list("path" = /obj/item/organ/external/tendril/three),
		BP_R_FOOT = list("path" = /obj/item/organ/external/tendril/four)
	)
	has_organ = list(
		BP_BRAIN =        /obj/item/organ/internal/brain/adherent,
		BP_EYES =         /obj/item/organ/internal/eyes/adherent,
		BP_JETS =         /obj/item/organ/internal/powered/jets,
		BP_FLOAT =        /obj/item/organ/internal/powered/float,
		BP_CELL =         /obj/item/organ/internal/cell/adherent,
		BP_COOLING_FINS = /obj/item/organ/internal/powered/cooling_fins
		)
	eye_contaminant_guard = TRUE
	eye_innate_flash_protection = FLASH_PROTECTION_MAJOR
	eye_icon = 'mods/species/bayliens/adherent/icons/eyes.dmi'
	uid = "bodytype_crystalline_adherent_turquoise"

/decl/bodytype/crystalline/adherent/Initialize()
	equip_adjust = list(
		"[BP_L_HAND]" = list(
			"[NORTH]" = list(0, 14),
			"[EAST]"  = list(0, 14),
			"[SOUTH]" = list(0, 14),
			"[WEST]"  = list(0, 14)
		),

		"[BP_R_HAND]" = list(
			"[NORTH]" = list(0, 14),
			"[EAST]"  = list(0, 14),
			"[SOUTH]" = list(0, 14),
			"[WEST]"  = list(0, 14)
		),

		"[slot_back_str]" = list(
			"[NORTH]" = list(0, 14),
			"[EAST]"  = list(0, 14),
			"[SOUTH]" = list(0, 14),
			"[WEST]"  = list(0, 14)
		),

		"[slot_belt_str]" = list(
			"[NORTH]" = list(0, 14),
			"[EAST]"  = list(0, 14),
			"[SOUTH]" = list(0, 14),
			"[WEST]"  = list(0, 14)
		),

		"[slot_head_str]" =   list(
			"[NORTH]" = list( 0, 14),
			"[EAST]"  = list( 3, 14),
			"[SOUTH]" = list( 0, 14),
			"[WEST]"  = list(-3, 14)
		),

		"[slot_l_ear_str]" =  list(
			"[NORTH]" = list(0, 14),
			"[EAST]"  = list(0, 14),
			"[SOUTH]" = list(0, 14),
			"[WEST]"  = list(0,  14)
		),

		"[slot_r_ear_str]" =  list(
			"[NORTH]" = list(0, 14),
			"[EAST]"  = list(0, 14),
			"[SOUTH]" = list(0, 14),
			"[WEST]"  = list(0,  14)
		)
	)
	. = ..()

/decl/bodytype/crystalline/adherent/apply_bodytype_organ_modifications(obj/item/organ/org)
	. = ..()
	BP_SET_PROSTHETIC(org)

/decl/bodytype/crystalline/adherent/emerald
	name = "emerald"
	icon_base = 'mods/species/bayliens/adherent/icons/body_emerald.dmi'
	uid = "bodytype_crystalline_adherent_emerald"

/decl/bodytype/crystalline/adherent/amethyst
	name = "amethyst"
	icon_base = 'mods/species/bayliens/adherent/icons/body_amethyst.dmi'
	uid = "bodytype_crystalline_adherent_amethyst"

/decl/bodytype/crystalline/adherent/sapphire
	name = "sapphire"
	icon_base = 'mods/species/bayliens/adherent/icons/body_sapphire.dmi'
	uid = "bodytype_crystalline_adherent_sapphire"

/decl/bodytype/crystalline/adherent/ruby
	name = "ruby"
	icon_base = 'mods/species/bayliens/adherent/icons/body_ruby.dmi'
	uid = "bodytype_crystalline_adherent_ruby"

/decl/bodytype/crystalline/adherent/topaz
	name = "topaz"
	icon_base = 'mods/species/bayliens/adherent/icons/body_topaz.dmi'
	uid = "bodytype_crystalline_adherent_topaz"

/decl/bodytype/crystalline/adherent/quartz
	name = "quartz"
	icon_base = 'mods/species/bayliens/adherent/icons/body_quartz.dmi'
	uid = "bodytype_crystalline_adherent_quartz"

/decl/bodytype/crystalline/adherent/jet
	name = "jet"
	icon_base = 'mods/species/bayliens/adherent/icons/body_jet.dmi'
	uid = "bodytype_crystalline_adherent_jet"
