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
	var/hat = usr.get_equipped_item(slot_head_str)
	if(hat)
		usr.drop_from_inventory(hat)

/datum/hud/diona_nymph
	var/obj/screen/diona_hat/hat

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
