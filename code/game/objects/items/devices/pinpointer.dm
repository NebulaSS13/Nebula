/obj/item/pinpointer
	name = "pinpointer"
	icon = 'icons/obj/items/device/pinpointer.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel
	var/weakref/target
	var/active = 0
	var/beeping = 2

/obj/item/pinpointer/Destroy()
	STOP_PROCESSING(SSobj,src)
	target = null
	. = ..()

/obj/item/pinpointer/attack_self(mob/user)
	toggle(user)

/obj/item/pinpointer/proc/toggle(mob/user)
	active = !active
	to_chat(user, "You [active ? "" : "de"]activate [src].")
	if(!active)
		STOP_PROCESSING(SSobj,src)
	else
		if(!target)
			target = acquire_target()
		START_PROCESSING(SSobj,src)
	update_icon()

/obj/item/pinpointer/advpinpointer/verb/toggle_sound()
	set category = "Object"
	set name = "Toggle Pinpointer Beeping"
	set src in view(1)

	if(beeping >= 0)
		beeping = -1
		to_chat(usr, "You mute [src].")
	else
		beeping = 0
		to_chat(usr, "You enable the sound indication on [src].")

/obj/item/pinpointer/proc/acquire_target()
	var/obj/item/disk/nuclear/the_disk = locate()
	return weakref(the_disk)

/obj/item/pinpointer/Process()
	update_icon()
	if(!target)
		return
	if(!target.resolve())
		target = null
		return

	if(beeping < 0)
		return
	if(beeping == 0)
		var/turf/here = get_turf(src)
		var/turf/there = get_turf(target.resolve())
		if(!istype(there))
			return
		var/distance = max(1,get_dist(here, there))
		var/freq_mod = 1
		if(distance < world.view)
			freq_mod = min(world.view/distance, 2)
		else if (distance > 3*world.view)
			freq_mod = max(3*world.view/distance, 0.6)
		playsound(loc, 'sound/machines/buttonbeep.ogg', 1, frequency = freq_mod)
		if(distance > world.view || here.z != there.z)
			beeping = initial(beeping)
	else
		beeping--

/obj/item/pinpointer/on_update_icon()
	cut_overlays()
	if(!active)
		return
	if(!target || !target.resolve())
		add_overlay("[icon_state]-invalid")
		return

	var/turf/here = get_turf(src)
	var/turf/there = get_turf(target.resolve())
	if(!istype(there))
		add_overlay("[icon_state]-invalid")
		return

	if(here == there)
		add_overlay("[icon_state]-here")
		return

	if(!(there.z in GetConnectedZlevels(here.z)))
		add_overlay("[icon_state]-invalid")
		return
	if(here.z > there.z)
		add_overlay("[icon_state]-down")
		return
	if(here.z < there.z)
		add_overlay("[icon_state]-up")
		return

	set_dir(get_dir(here, there))
	var/image/pointer = image(icon,"[icon_state]-point")
	var/distance = get_dist(here,there)
	if(distance < world.view)
		pointer.color = COLOR_LIME
	else if(distance > 4*world.view)
		pointer.color = COLOR_RED
	else
		pointer.color = COLOR_YELLOW
	add_overlay(pointer)

//Radio beacon locator
/obj/item/pinpointer/radio
	name = "locator device"
	desc = "Used to scan and locate signals on a particular frequency."
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	var/tracking_freq = PUB_FREQ

/obj/item/pinpointer/radio/acquire_target()
	var/turf/T = get_turf(src)
	var/zlevels = GetConnectedZlevels(T.z)
	var/cur_dist = world.maxx+world.maxy
	for(var/obj/item/radio/beacon/R in world)
		if(!R.functioning)
			continue
		if((R.z in zlevels) && R.frequency == tracking_freq)
			var/check_dist = get_dist(src,R)
			if(check_dist < cur_dist)
				cur_dist = check_dist
				. = weakref(R)

/obj/item/pinpointer/radio/attack_self(var/mob/user)
	interact(user)

/obj/item/pinpointer/radio/interact(var/mob/user)
	var/dat = "<b>Radio frequency tracker</b><br>"
	dat += {"
				Tracking: <A href='byond://?src=\ref[src];toggle=1'>[active ? "Enabled" : "Disabled"]</A><BR>
				<A href='byond://?src=\ref[src];reset_tracking=1'>Reset tracker</A><BR>
				Frequency:
				<A href='byond://?src=\ref[src];freq=-10'>-</A>
				<A href='byond://?src=\ref[src];freq=-2'>-</A>
				[format_frequency(tracking_freq)]
				<A href='byond://?src=\ref[src];freq=2'>+</A>
				<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
				"}
	show_browser(user, dat, "window=locater;size=300x150")
	onclose(user, "locater")

/obj/item/pinpointer/radio/OnTopic(user, href_list)
	if(href_list["toggle"])
		toggle(user)
		. = TOPIC_REFRESH

	if(href_list["reset_tracking"])
		target = acquire_target()
		. = TOPIC_REFRESH

	else if(href_list["freq"])
		var/new_frequency = (tracking_freq + text2num(href_list["freq"]))
		if (new_frequency < 1200 || new_frequency > 1600)
			new_frequency = sanitize_frequency(new_frequency, 1499)
		tracking_freq = new_frequency
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

//Deathsquad locator

/obj/item/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	var/selection = input(usr, "Please select the type of target to locate.", "Mode" , "") as null|anything in list("Location", "Disk Recovery", "DNA", "Other Signature")
	switch(selection)
		if("Disk Recovery")
			var/obj/item/disk/nuclear/the_disk = locate()
			target = weakref(the_disk)

		if("Location")
			var/locationx = input(usr, "Please input the x coordinate to search for.", "Location?" , "") as num
			if(!locationx || !(usr in view(1,src)))
				return
			var/locationy = input(usr, "Please input the y coordinate to search for.", "Location?" , "") as num
			if(!locationy || !(usr in view(1,src)))
				return

			var/turf/Z = get_turf(src)
			var/turf/location = locate(locationx,locationy,Z.z)

			to_chat(usr, "You set the pinpointer to locate [locationx],[locationy]")

			target = weakref(location)

		if("Other Signature")

			var/itemlist = GLOB.using_map.get_theft_targets() | GLOB.using_map.get_special_theft_targets()
			var/targetitem = input("Select item to search for.", "Item Mode Select","") as null|anything in itemlist
			if(!targetitem)
				return
			var/obj/item = locate(itemlist[targetitem])
			if(!item)
				to_chat(usr, "Failed to locate [targetitem]!")
				return
			to_chat(usr, "You set the pinpointer to locate [targetitem]")
			target = weakref(item)

		if("DNA")
			var/DNAstring = input("Input DNA string to search for." , "Please Enter String." , "")
			if(!DNAstring)
				return
			for(var/mob/living/carbon/M in SSmobs.mob_list)
				if(!M.dna)
					continue
				if(M.dna.unique_enzymes == DNAstring)
					target = weakref(M)
					break