/obj/screen/intent/diona_nymph
	icon_state = "intent_harm"
	screen_loc = DIONA_SCREEN_LOC_INTENT

/obj/screen/intent/diona_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"

/datum/hud/diona_nymph
	var/obj/screen/diona_held/held

/datum/hud/diona_nymph/get_ui_style()
	return 'mods/mobs/dionaea/icons/ui.dmi'

/datum/hud/diona_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/diona_nymph/get_ui_alpha()
	return 255

/datum/hud/diona_nymph/FinalizeInstantiation()

	var/ui_style = get_ui_style()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	action_intent = new /obj/screen/intent/diona_nymph()
	action_intent.icon =  ui_style
	action_intent.color = ui_color
	action_intent.alpha = ui_alpha
	adding += action_intent

	mymob.healths = new /obj/screen()
	mymob.healths.icon =  ui_style
	mymob.healths.color = ui_color
	mymob.healths.alpha = ui_alpha
	mymob.healths.icon_state = "health0"
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = DIONA_SCREEN_LOC_HEALTH
	adding += mymob.healths

	..()