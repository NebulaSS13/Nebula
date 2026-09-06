/decl/ui_style/diona
	name = "Diona"
	restricted = TRUE
	uid  = "ui_style_diona"
	override_icons = list(
		(HUD_HEALTH)    = 'mods/mobs/dionaea/icons/ui_health.dmi',
		(HUD_HANDS)     = 'mods/mobs/dionaea/icons/ui_hands.dmi',
		(HUD_RESIST)    = 'mods/mobs/dionaea/icons/ui_interactions_resist.dmi',
		(HUD_THROW)     = 'mods/mobs/dionaea/icons/ui_interactions_throw.dmi',
		(HUD_DROP)      = 'mods/mobs/dionaea/icons/ui_interactions_drop.dmi',
		(HUD_MANEUVER)  = 'mods/mobs/dionaea/icons/ui_interactions_maneuver.dmi',
		(HUD_INVENTORY) = 'mods/mobs/dionaea/icons/ui_inventory.dmi'
	)

/decl/hud_element/health/diona
	elem_type = /obj/screen/health/diona
	elem_reference_type = /decl/hud_element/health

/datum/hud/diona_nymph
	omit_hud_elements = list(/decl/hud_element/health)
	additional_hud_elements = list(/decl/hud_element/health/diona)

/datum/hud/diona_nymph/get_ui_style_data()
	return GET_DECL(/decl/ui_style/diona)

/datum/hud/diona_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/diona_nymph/get_ui_alpha()
	return 255

/obj/screen/health/diona
	icon_state = "health0"
	name = "health"
	screen_loc = DIONA_SCREEN_LOC_HEALTH
