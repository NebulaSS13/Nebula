/mob/living/deity
	hud_used = /datum/hud/deity

/datum/hud/deity
	hud_elements = list(
		/decl/hud_element/action_intent/deity
	)

/decl/hud_element/action_intent/deity
	screen_object_type = /obj/screen/intent/deity

/decl/hud_element/action_intent/deity/register_screen_object(obj/screen/elem, datum/hud/hud)
	var/obj/screen/intent/deity/deity_elem = elem
	if(istype(deity_elem))
		deity_elem.sync_to_mob(hud.mymob)
	return ..()

/obj/screen/intent/deity
	var/list/desc_screens = list()
	screen_loc = "RIGHT-5:122,BOTTOM:8"

/obj/screen/intent/deity/Initialize()
	. = ..()
	overlays += image('icons/mob/screen/phenomena.dmi', icon_state = "hud", pixel_x = -138, pixel_y = -1)

/obj/screen/intent/deity/proc/sync_to_mob(var/mob)
	var/mob/living/deity/D = mob
	for(var/i in 1 to D.control_types.len)
		var/obj/screen/S = new()
		S.SetName(null) //Don't want them to be able to actually right click it.
		S.mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
		S.icon_state = "blank"
		desc_screens[D.control_types[i]] = S
		S.maptext_width = 128
		S.screen_loc = screen_loc
		//This sets it up right. Trust me.
		S.maptext_y = 33/2*i - i*i/2 - 10
		D.client.screen += S
		S.maptext_x = -125

	update_text()

/obj/screen/intent/deity/proc/update_text()
	if(!isdeity(usr))
		return
	var/mob/living/deity/D = usr
	for(var/i in D.control_types)
		var/obj/screen/S = desc_screens[i]
		var/datum/phenomena/P = D.intent_phenomenas[intent][i]
		if(P)
			S.maptext = "<span style='font-size:7pt;font-family:Impact'><font color='#3C3612'>[P.name]</font></span>"
		else
			S.maptext = null

/obj/screen/intent/deity/Click(var/location, var/control, var/params)
	..()
	update_text()