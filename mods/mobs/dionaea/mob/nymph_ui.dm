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

/decl/ui_style/diona
	name = "Diona"
	restricted = TRUE
	uid  = "ui_style_diona"
	override_icons = list(
		UI_ICON_HEALTH      = 'mods/mobs/dionaea/icons/ui_health.dmi',
		UI_ICON_HANDS       = 'mods/mobs/dionaea/icons/ui_hands.dmi',
		UI_ICON_INTENT      = 'mods/mobs/dionaea/icons/ui_intents.dmi',
		UI_ICON_INTERACTION = 'mods/mobs/dionaea/icons/ui_interactions.dmi',
		UI_ICON_INVENTORY   = 'mods/mobs/dionaea/icons/ui_inventory.dmi'
	)

/datum/hud/diona_nymph/get_ui_style_data()
	return GET_DECL(/decl/ui_style/diona)

/datum/hud/diona_nymph/get_ui_color()
	return COLOR_WHITE

/datum/hud/diona_nymph/get_ui_alpha()
	return 255

/datum/hud/diona_nymph/FinalizeInstantiation()
	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()

	action_intent = new /obj/screen/intent/diona_nymph(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_INTENT)
	mymob.healths = new /obj/screen/diona_health(      null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HEALTH)
	src.other = list()
	src.adding = list(mymob.healths, action_intent)
	..()

/obj/screen/diona_health
	icon_state = "health0"
	name = "health"
	screen_loc = DIONA_SCREEN_LOC_HEALTH
