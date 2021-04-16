/decl/bodytype/adherent
	name = "turquoise"
	bodytype_category = BODYTYPE_ADHERENT
	icon_template =     'mods/species/adherent/icons/template.dmi'
	icon_base =         'mods/species/adherent/icons/body_turquoise.dmi'
	damage_overlays =   'mods/species/adherent/icons/damage_overlay.dmi'
	damage_mask =       'mods/species/adherent/icons/damage_mask.dmi'
	blood_mask =        'mods/species/adherent/icons/blood_mask.dmi'
	antaghud_offset_y = 14

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
	icon_base = 'mods/species/adherent/icons/body_emerald.dmi'

/decl/bodytype/adherent/amethyst
	name = "amethyst"
	icon_base = 'mods/species/adherent/icons/body_amethyst.dmi'

/decl/bodytype/adherent/sapphire
	name = "sapphire"
	icon_base = 'mods/species/adherent/icons/body_sapphire.dmi'

/decl/bodytype/adherent/ruby
	name = "ruby"
	icon_base = 'mods/species/adherent/icons/body_ruby.dmi'

/decl/bodytype/adherent/topaz
	name = "topaz"
	icon_base = 'mods/species/adherent/icons/body_topaz.dmi'

/decl/bodytype/adherent/quartz
	name = "quartz"
	icon_base = 'mods/species/adherent/icons/body_quartz.dmi'

/decl/bodytype/adherent/jet
	name = "jet"
	icon_base = 'mods/species/adherent/icons/body_jet.dmi'
