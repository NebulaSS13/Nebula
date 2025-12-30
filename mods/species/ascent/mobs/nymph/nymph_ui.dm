
/decl/ui_style/ascent
	name = "Ascent"
	restricted = TRUE
	uid  = "ui_style_ascent"
	override_icons = list(
		(HUD_HEALTH)    = 'mods/species/ascent/icons/ui_health.dmi',
		(HUD_HANDS)     = 'mods/species/ascent/icons/ui_hands.dmi',
		(HUD_RESIST)    = 'mods/species/ascent/icons/ui_interactions_resist.dmi',
		(HUD_THROW)     = 'mods/species/ascent/icons/ui_interactions_throw.dmi',
		(HUD_DROP)      = 'mods/species/ascent/icons/ui_interactions_drop.dmi',
		(HUD_MANEUVER)  = 'mods/species/ascent/icons/ui_interactions_maneuver.dmi',
		(HUD_INVENTORY) = 'mods/species/ascent/icons/ui_inventory.dmi'
	)

/decl/hud_element/health/ascent_nymph
	elem_reference_type = /decl/hud_element/health
	elem_type = /obj/screen/health/ascent_nymph

/decl/hud_element/molt
	elem_type = /obj/screen/ascent_nymph_molt

/datum/hud/ascent_nymph
	omit_hud_elements = list(/decl/hud_element/health)
	additional_hud_elements = list(
		/decl/hud_element/health/ascent_nymph,
		/decl/hud_element/molt
	)

/datum/hud/ascent_nymph/get_ui_style_data()
	return GET_DECL(/decl/ui_style/ascent)

/datum/hud/ascent_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/ascent_nymph/get_ui_alpha()
	return 255

/obj/screen/health/ascent_nymph
	name = "health"
	screen_loc = ANYMPH_SCREEN_LOC_HEALTH

/obj/screen/ascent_nymph_molt
	name = "molt"
	icon = 'mods/species/ascent/icons/ui_molt.dmi'
	screen_loc =  ANYMPH_SCREEN_LOC_MOLT
	icon_state = "molt-on"
	requires_ui_style = FALSE

/obj/screen/ascent_nymph_molt/handle_click(mob/user, params)
	var/mob/living/simple_animal/alien/kharmaan/nymph = user
	if(istype(nymph))
		nymph.molt()
