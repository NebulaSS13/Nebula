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

/obj/screen/ascent_nymph_molt
	name = "molt"
	icon = 'icons/obj/action_buttons/organs.dmi'
	screen_loc =  ANYMPH_SCREEN_LOC_MOLT
	icon_state = "molt-on"

/obj/screen/ascent_nymph_molt/handle_click(mob/user, params)
	var/mob/living/carbon/alien/ascent_nymph/nymph = user
	if(istype(nymph)) nymph.molt()

/datum/hud/ascent_nymph
	has_intent_selector = /obj/screen/intent/ascent_nymph
	var/obj/screen/ascent_nymph_molt/molt

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
	mymob.nutrition_icon = new(null, mymob)
	mymob.hydration_icon = new(null, mymob)
	mymob.healths = new /obj/screen/ascent_nymph_health(null, mymob, ui_style, ui_color, ui_alpha)
	molt          = new(null, mymob, ui_style, ui_color, ui_alpha)
	adding += list(mymob.healths, molt, mymob.nutrition_icon, mymob.hydration_icon)
	..()

/obj/screen/ascent_nymph_health
	name = "health"
	screen_loc = ANYMPH_SCREEN_LOC_HEALTH
