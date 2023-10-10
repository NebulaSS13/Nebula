/obj/screen/intent/diona_nymph
	icon_state = "intent_devour"
	screen_loc = DIONA_SCREEN_LOC_INTENT

/obj/screen/intent/diona_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"

/obj/screen/diona_hat
	name = "equipped hat"
	screen_loc = DIONA_SCREEN_LOC_HAT
	icon_state = "hat"

/obj/screen/diona_hat/Click()
	var/datum/extension/hattable/hattable = get_extension(usr, /datum/extension/hattable)
	hattable?.drop_hat(usr)

/obj/screen/diona_held
	name = "held item"
	screen_loc =  DIONA_SCREEN_LOC_HELD
	icon_state = "held"

/obj/screen/diona_held/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.holding_item) chirp.try_unequip(chirp.holding_item)

/datum/hud/diona_nymph
	var/obj/screen/diona_hat/hat
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

	src.adding = list()
	src.other = list()

	hat = new
	hat.icon =  ui_style
	hat.color = ui_color
	hat.alpha = ui_alpha
	adding += hat

	held = new
	held.icon =  ui_style
	held.color = ui_color
	held.alpha = ui_alpha
	adding += held

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

	mymob.client.screen = list(mymob.healths)
	mymob.client.screen += src.adding + src.other
