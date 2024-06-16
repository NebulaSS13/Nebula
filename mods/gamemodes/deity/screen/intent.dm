/obj/screen/intent/deity
	var/list/desc_screens = list()
	screen_loc = "RIGHT-5:122,BOTTOM:8"

/obj/screen/intent/deity/on_update_icon()
	. = ..()
	cut_overlays()
	add_overlay(image('icons/mob/screen/phenomena.dmi', icon_state = "hud", pixel_x = -138, pixel_y = -1))
	compile_overlays()

/obj/screen/intent/deity/proc/sync_to_mob(var/mob)
	var/mob/living/deity/D = mob
	for(var/i in 1 to D.control_types.len)
		var/obj/screen/deity_marker/S = new(null, D)
		desc_screens[D.control_types[i]] = S
		S.screen_loc = screen_loc
		//This sets it up right. Trust me.
		S.maptext_y = 33/2*i - i*i/2 - 10
		D.client.screen += S

	update_text()

/obj/screen/intent/deity/proc/update_text()
	if(!isdeity(usr))
		return
	var/mob/living/deity/D = usr
	for(var/i in D.control_types)
		var/obj/screen/deity_marker/S = desc_screens[i]
		var/datum/phenomena/P = D.intent_phenomenas[intent][i]
		if(P)
			S.maptext = "<span style='font-size:7pt;font-family:Impact'><font color='#3C3612'>[P.name]</font></span>"
		else
			S.maptext = null

/obj/screen/intent/deity/handle_click(mob/user, params)
	..()
	update_text()

/obj/screen/deity_marker
	name = "" //Don't want them to be able to actually right click it.
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	icon_state = "blank"
	maptext_width = 128
	maptext_x = -125