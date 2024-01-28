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
	var/obj/screen/ascent_nymph_molt/molt
	var/obj/screen/food/food
	var/obj/screen/drink/drink

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
	molt          = new(                                null, mymob, ui_style, ui_color, ui_alpha)
	food          = new /obj/screen/food(               null, mymob, ui_style, ui_color, ui_alpha)
	drink         = new /obj/screen/drink(              null, mymob, ui_style, ui_color, ui_alpha)
	action_intent = new /obj/screen/intent/ascent_nymph(null, mymob, ui_style, ui_color, ui_alpha)
	mymob.healths = new /obj/screen/ascent_nymph_health(null, mymob, ui_style, ui_color, ui_alpha)
	src.other = list()
	src.adding = list(mymob.healths, molt, food, drink, action_intent)
	..()

/obj/screen/ascent_nymph_health
	name = "health"
	screen_loc = ANYMPH_SCREEN_LOC_HEALTH
