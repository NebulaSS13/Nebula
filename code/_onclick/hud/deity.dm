/mob/living/deity
	hud_type = /datum/hud/deity

/datum/hud/deity/FinalizeInstantiation()
	var/obj/screen/intent/deity/D = new()
	adding += D
	action_intent = D
	..()
	D.sync_to_mob(mymob)

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

/obj/screen/intent/deity/handle_click(mob/user, params)
	..()
	update_text()
