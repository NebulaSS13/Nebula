/obj/screen/intent
	name       = "intent"
	icon       = 'icons/mob/screen/white.dmi'
	icon_state = "intent_help"
	screen_loc = ui_acti
	var/intent = I_HELP

/obj/screen/intent/handle_click(mob/user, params)
	var/list/P = params2list(params)
	var/icon_x = text2num(P["icon-x"])
	var/icon_y = text2num(P["icon-y"])
	intent = I_DISARM
	if(icon_x <= world.icon_size/2)
		if(icon_y <= world.icon_size/2)
			intent = I_HURT
		else
			intent = I_HELP
	else if(icon_y <= world.icon_size/2)
		intent = I_GRAB
	update_icon()
	user.a_intent = intent

/obj/screen/intent/on_update_icon()
	icon_state = "intent_[intent]"

/obj/screen/intent/deity
	var/list/desc_screens = list()
	screen_loc = "RIGHT-5:122,BOTTOM:8"

/obj/screen/intent/deity/on_update_icon()
	. = ..()
	cut_overlays()
	add_overlay(image('icons/mob/screen_phenomena.dmi', icon_state = "hud", pixel_x = -138, pixel_y = -1))
	compile_overlays()
