/decl/hud_element/action_intent/ascent_nymph
	screen_object_type = /obj/screen/intent/ascent_nymph

/obj/screen/intent/ascent_nymph
	icon_state = "intent_harm"
	screen_loc = ANYMPH_SCREEN_LOC_INTENT

/obj/screen/intent/ascent_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"

/obj/screen/ascent_nymph_held
	name = "held item"
	screen_loc =  ANYMPH_SCREEN_LOC_HELD
	icon_state = "held"

/obj/screen/ascent_nymph_held/Click()
	var/mob/living/carbon/alien/ascent_nymph/nymph = usr
	if(istype(nymph) && nymph.holding_item) nymph.try_unequip(nymph.holding_item)

/obj/screen/ascent_nymph_molt
	name = "molt"
	icon = 'icons/obj/action_buttons/organs.dmi'
	screen_loc =  ANYMPH_SCREEN_LOC_MOLT
	icon_state = "molt-on"

/obj/screen/ascent_nymph_molt/Click()
	var/mob/living/carbon/alien/ascent_nymph/nymph = usr
	if(istype(nymph)) nymph.molt()

/datum/hud/ascent_nymph
	health_hud_type = /decl/hud_element/health/ascent_nymph
	hud_elements = list(
		/decl/hud_element/health/ascent_nymph
	)
	var/obj/screen/ascent_nymph_held/held
	var/obj/screen/ascent_nymph_molt/molt

/decl/hud_element/health/ascent_nymph
	screen_loc = ui_alien_health

/datum/hud/ascent_nymph/get_ui_style()
	return 'mods/species/ascent/icons/ui.dmi'

/datum/hud/ascent_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/ascent_nymph/get_ui_alpha()
	return 255

/datum/hud/ascent_nymph/FinalizeInstantiation()
	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()
	held = new
	held.icon =  ui_style
	held.color = ui_color
	held.alpha = ui_alpha
	misc_hud_elements += held
	molt = new
	molt.icon =  ui_style
	molt.color = ui_color
	molt.alpha = ui_alpha
	misc_hud_elements += molt
	return ..()
