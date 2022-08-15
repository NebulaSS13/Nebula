/decl/bodytype/adherent
	name = "turquoise"
	bodytype_category = BODYTYPE_ADHERENT
	icon_template =     'mods/species/bayliens/adherent/icons/template.dmi'
	icon_base =         'mods/species/bayliens/adherent/icons/body_turquoise.dmi'
	damage_overlays =   'mods/species/bayliens/adherent/icons/damage_overlay.dmi'
	blood_overlays =    'mods/species/bayliens/adherent/icons/blood_overlays.dmi'
	antaghud_offset_y = 14
	mob_size =                MOB_SIZE_LARGE

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

	has_organs = list(
		BP_BRAIN =        /obj/item/organ/internal/brain/adherent,
		BP_EYES =         /obj/item/organ/internal/eyes/adherent,
		BP_JETS =         /obj/item/organ/internal/powered/jets,
		BP_FLOAT =        /obj/item/organ/internal/powered/float,
		BP_CELL =         /obj/item/organ/internal/cell/adherent,
		BP_COOLING_FINS = /obj/item/organ/internal/powered/cooling_fins
	)

/decl/bodytype/adherent/Initialize()
	equip_adjust = list(
		"[BP_L_HAND]" = list(
			"[NORTH]" = list("x" = 0, "y" = 14),
			"[EAST]"  = list("x" = 0, "y" = 14),
			"[SOUTH]" = list("x" = 0, "y" = 14),
			"[WEST]"  = list("x" = 0, "y" = 14)
		),

		"[BP_R_HAND]" = list(
			"[NORTH]" = list("x" = 0, "y" = 14),
			"[EAST]"  = list("x" = 0, "y" = 14),
			"[SOUTH]" = list("x" = 0, "y" = 14),
			"[WEST]"  = list("x" = 0, "y" = 14)
		),

		"[slot_back_str]" = list(
			"[NORTH]" = list("x" = 0, "y" = 14),
			"[EAST]"  = list("x" = 0, "y" = 14),
			"[SOUTH]" = list("x" = 0, "y" = 14),
			"[WEST]"  = list("x" = 0, "y" = 14)
		),

		"[slot_belt_str]" = list(
			"[NORTH]" = list("x" = 0, "y" = 14),
			"[EAST]"  = list("x" = 0, "y" = 14),
			"[SOUTH]" = list("x" = 0, "y" = 14),
			"[WEST]"  = list("x" = 0, "y" = 14)
		),

		"[slot_head_str]" =   list(
			"[NORTH]" = list("x" = 0, "y" = 14),
			"[EAST]"  = list("x" = 3, "y" = 14),
			"[SOUTH]" = list("x" = 0, "y" = 14),
			"[WEST]"  = list("x" = -3, "y" = 14)
		),

		"[slot_l_ear_str]" =  list(
			"[NORTH]" = list("x" = 0, "y" = 14),
			"[EAST]"  = list("x" = 0, "y" = 14),
			"[SOUTH]" = list("x" = 0, "y" = 14),
			"[WEST]"  = list("x" = 0,  "y" = 14)
		),

		"[slot_r_ear_str]" =  list(
			"[NORTH]" = list("x" = 0, "y" = 14),
			"[EAST]"  = list("x" = 0, "y" = 14),
			"[SOUTH]" = list("x" = 0, "y" = 14),
			"[WEST]"  = list("x" = 0,  "y" = 14)
		)
	)
	. = ..()

/decl/bodytype/adherent/emerald
	name = "emerald"
	icon_base = 'mods/species/bayliens/adherent/icons/body_emerald.dmi'

/decl/bodytype/adherent/amethyst
	name = "amethyst"
	icon_base = 'mods/species/bayliens/adherent/icons/body_amethyst.dmi'

/decl/bodytype/adherent/sapphire
	name = "sapphire"
	icon_base = 'mods/species/bayliens/adherent/icons/body_sapphire.dmi'

/decl/bodytype/adherent/ruby
	name = "ruby"
	icon_base = 'mods/species/bayliens/adherent/icons/body_ruby.dmi'

/decl/bodytype/adherent/topaz
	name = "topaz"
	icon_base = 'mods/species/bayliens/adherent/icons/body_topaz.dmi'

/decl/bodytype/adherent/quartz
	name = "quartz"
	icon_base = 'mods/species/bayliens/adherent/icons/body_quartz.dmi'

/decl/bodytype/adherent/jet
	name = "jet"
	icon_base = 'mods/species/bayliens/adherent/icons/body_jet.dmi'
