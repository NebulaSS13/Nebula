/obj/screen/intent/diona_nymph
	icon_state = "intent_help"
	screen_loc = "RIGHT-1:5,BOTTOM:5"

/obj/screen/intent/diona_nymph/Initialize()
	. = ..()
	update_icon()

/obj/screen/intent/diona_nymph/on_update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		intent = I_GRAB
		icon_state = "intent_harm"
	else
		intent = I_DISARM
		icon_state = "intent_help"



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

	adding = list()
	hotkeybuttons = list()

	action_intent = new /obj/screen/intent/diona_nymph()
	action_intent.icon =  ui_style
	action_intent.color = ui_color
	action_intent.alpha = ui_alpha
	adding += action_intent

	mymob.healths = new /obj/screen()
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.SetName("health")
	mymob.healths.screen_loc = "RIGHT-1:5,CENTER-1:13"
	adding += mymob.healths

	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.SetName("throw")
	mymob.throw_icon.screen_loc = "RIGHT-1:5,BOTTOM+1:5"
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.color = ui_color
	mymob.throw_icon.alpha = ui_alpha

	hotkeybuttons += mymob.throw_icon
	adding += mymob.throw_icon

	var/obj/screen/drop = new()
	drop.SetName("drop")
	drop.icon_state = "act_drop"
	drop.screen_loc = "RIGHT-1:5,BOTTOM+1:5"
	drop.icon = ui_style
	drop.color = ui_color
	drop.alpha = ui_alpha
	hotkeybuttons += drop
	adding += drop

	BuildInventoryUI()
	BuildHandsUI()

	mymob.client.screen = adding | hotkeybuttons | hand_hud_objects | swaphand_hud_objects
