/obj/item/clothing/sensor/buddytag
	name = "buddy tag"
	desc = "A tiny device, paired up with a counterpart set to same code. When devices are taken apart too far, they start beeping."
	icon = 'icons/clothing/accessories/buddytag.dmi'
	accessory_visibility = ACCESSORY_VISIBILITY_ATTACHMENT
	accessory_slot = ACCESSORY_SLOT_DECOR
	var/next_search = 0
	var/on = 0
	var/id = 1
	var/distance = 10
	var/search_interval = 30 SECONDS

/obj/item/clothing/sensor/buddytag/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(on && check_state_in_icon("[icon_state]-on", icon))
		icon_state = "[icon_state]-on"

/obj/item/clothing/sensor/buddytag/attack_self(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	var/list/dat = "<A href='byond://?src=\ref[src];toggle=1;'>[on ? "Disable" : "Enable"]</a>"
	dat += "<br>ID: <A href='byond://?src=\ref[src];setcode=1;'>[id]</a>"
	dat += "<br>Search Interval: <A href='byond://?src=\ref[src];set_interval=1;'>[search_interval/10] seconds</a>"
	dat += "<br>Search Distance: <A href='byond://?src=\ref[src];set_distance=1;'>[distance]</a>"
	var/datum/browser/popup = new(user, "buddytag", "Buddy Tag", 290, 200)
	popup.set_content(JOINTEXT(dat))
	popup.open()

/obj/item/clothing/sensor/buddytag/DefaultTopicState()
	return global.physical_topic_state

/obj/item/clothing/sensor/buddytag/OnTopic(var/user, var/list/href_list, var/state)
	if(href_list["toggle"])
		on = !on
		if(on)
			next_search = world.time
			START_PROCESSING(SSobj, src)
		update_icon()
		return TOPIC_REFRESH
	if(href_list["setcode"])
		var/newcode = input("Set new buddy ID number." , "Buddy Tag ID" , id) as num|null
		if(newcode == null || !CanInteract(user, state))
			return
		id = newcode
		return TOPIC_REFRESH
	if(href_list["set_distance"])
		var/newdist = input("Set new maximum range." , "Buddy Tag Range" , distance) as num|null
		if(newdist == null || !CanInteract(user, state))
			return
		distance = newdist
		return TOPIC_REFRESH
	if(href_list["set_interval"])
		var/newtime = input("Set new search interval in seconds (minimum 30s)." , "Buddy Tag Time Interval" , search_interval/10) as num|null
		if(newtime == null || !CanInteract(user, state))
			return
		newtime = max(30, newtime)
		search_interval = newtime SECONDS
		return TOPIC_REFRESH

/obj/item/clothing/sensor/buddytag/Process()
	if(!on)
		return PROCESS_KILL
	if(world.time < next_search)
		return
	next_search = world.time + search_interval
	var/has_friend
	for(var/obj/item/clothing/sensor/buddytag/buddy in SSobj.processing)
		if(buddy == src)
			continue
		if(!buddy.on)
			continue
		if(buddy.id != id)
			continue
		if(get_z(buddy) != get_z(src))
			continue
		if(get_dist(get_turf(src), get_turf(buddy)) <= distance)
			has_friend = TRUE
			break
	if(!has_friend)
		playsound(src, 'sound/machines/chime.ogg', 10)
		var/turf/T = get_turf(src)
		if(T)
			T.visible_message(SPAN_WARNING("[src] beeps anxiously."), range = 3)
