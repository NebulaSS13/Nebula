/*
 * Locator
 */
/obj/item/locator
	name = "locator"
	desc = "Used to track those with locator implants."
	icon = 'icons/obj/items/device/locator.dmi'
	icon_state = ICON_STATE_WORLD
	var/temp = null
	var/frequency = 1451
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 20
	origin_tech = @'{"magnets":1}'
	material = /decl/material/solid/metal/aluminium

/obj/item/locator/attack_self(mob/user)
	user.set_machine(src)
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = {"
<B>Persistent Signal Locator</B><HR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

<A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"}
	show_browser(user, dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/locator/OnTopic(mob/user, href_list, datum/topic_state/state)
	var/turf/current_location = get_turf(user) //What turf is the user on?
	if(!current_location || isAdminLevel(current_location.z)) //If turf was not found or they're on an admin Z-level
		to_chat(user, "\The [src] is malfunctioning.")
		return
	if(!CanPhysicallyInteract(user))
		return
	user.set_machine(src)
	if (href_list["refresh"])
		src.temp = "<B>Persistent Signal Locator</B><HR>"
		var/turf/source_turf = get_turf(src)
		if (!source_turf)
			src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
			return TOPIC_REFRESH
		src.temp += "<B>Located Beacons:</B><BR>"
		for(var/obj/item/radio/beacon/radio in global.radio_beacons)
			if(!radio.functioning)
				continue
			if (radio.frequency != frequency)
				continue
			var/turf/radio_turf = get_turf(radio)
			if (radio_turf.z != source_turf.z || !radio_turf)
				continue
			var/distance
			switch(get_dist(radio_turf, source_turf))
				if(0 to 5)
					distance = "very strong"
				if(6 to 10)
					distance = "strong"
				if(11 to 20)
					distance = "weak"
				else
					continue
			if(distance)
				src.temp += "[radio.code]-[dir2text(get_dir(source_turf, radio_turf))]-[distance]<BR>"

		src.temp += "<B>Extraneous Signals:</B><BR>"
		for (var/obj/item/implant/tracking/implant in global.tracking_implants)
			if (!implant.implanted || !(istype(implant.loc,/obj/item/organ/external) || ismob(implant.loc)))
				continue
			var/mob/victim = implant.loc
			// Don't show dead people that have been dead for a while
			if (victim.stat == DEAD && world.time > victim.timeofdeath + 10 MINUTES)
				continue
			var/turf/implant_turf = get_turf(implant)
			if (implant_turf?.z != source_turf.z)
				continue
			var/distance
			switch(get_dist(implant_turf, source_turf))
				if(0 to 5)
					distance = "very strong"
				if(6 to 10)
					distance = "strong"
				if(11 to 20)
					distance = "weak"
			if(distance)
				src.temp += "[implant.id]-[dir2text(get_dir(source_turf, implant_turf))]-[distance]<BR>"

		src.temp += "<B>You are at \[[source_turf.x],[source_turf.y],[source_turf.z]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
	else if (href_list["freq"])
		src.frequency += text2num(href_list["freq"])
		src.frequency = sanitize_frequency(src.frequency)
	else if (href_list["temp"])
		src.temp = null
	return TOPIC_REFRESH
