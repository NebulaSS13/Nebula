/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation hub and station."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	var/obj/machinery/teleport/station/station = null
	var/obj/machinery/teleport/hub/hub = null
	var/obj/item/locked = null
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set src.locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.

/obj/machinery/computer/teleporter/Initialize()
	. = ..()

	id = "[random_id(/obj/machinery/computer/teleporter, 1000, 9999)]"

	for (var/dir in global.cardinal)
		var/obj/machinery/teleport/station/found_station = locate() in get_step(src, dir)
		if(found_station)
			station = found_station
			break
	if(station)
		for (var/dir in global.cardinal)
			var/obj/machinery/teleport/hub/found_hub = locate() in get_step(station, dir)
			if(found_hub)
				hub = found_hub
				break

	if(istype(station))
		station.hub = hub
		station.com = src
		station.set_dir(dir)

	if(istype(hub))
		hub.com = src
		hub.set_dir(dir)

/obj/machinery/computer/teleporter/power_change()
	. = ..()
	if (stat & NOPOWER)
		// Lose memory
		locked = null

/obj/machinery/computer/teleporter/examine(mob/user)
	. = ..()
	if(locked)
		var/turf/T = get_turf(locked)
		to_chat(user, SPAN_NOTICE("The console is locked on to \[[T.loc.name]\]."))


/obj/machinery/computer/teleporter/attackby(var/obj/I, var/mob/user)

	var/obj/item/card/data/C = I
	if(!istype(C) || (stat & (NOPOWER|BROKEN)) || C.function != "teleporter")
		return ..()

	var/obj/L = null
	for(var/obj/abstract/landmark/sloc in global.landmarks_list)
		if(sloc.name != C.data || (locate(/mob/living) in sloc.loc))
			continue
		L = sloc
		break

	if(!L)
		L = locate("landmark*[C.data]") // use old stype

	if(istype(L, /obj/abstract/landmark) && isturf(L.loc) && user.try_unequip(I))
		to_chat(usr, "You insert the coordinates into the machine.")
		to_chat(usr, "A message flashes across the screen reminding the traveller that the nuclear authentication disk is to remain on the [station_name()] at all times.")
		qdel(I)
		audible_message(SPAN_NOTICE("Locked in."))
		src.locked = L
		one_time_use = 1
		add_fingerprint(usr)
	return TRUE

/obj/machinery/computer/teleporter/interface_interact(var/mob/user)
	/* Run full check because it's a direct selection */
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE

	var/list/L = list()
	var/list/areaindex = list()

	. = TRUE
	for(var/obj/item/radio/beacon/R in global.radio_beacons)
		if(!R.functioning)
			continue
		var/turf/T = get_turf(R)
		if (!T)
			continue
		if(!isPlayerLevel(T.z))
			continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	for (var/obj/item/implant/tracking/I in global.tracking_implants)
		if (!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if (M.stat == 2)
				if (M.timeofdeath + 6000 < world.time)
					continue
			var/turf/T = get_turf(M)
			if(!T)
				continue
			if(!isPlayerLevel(T.z))
				continue
			var/tmpname = M.real_name
			if(areaindex[tmpname])
				tmpname = "[tmpname] ([++areaindex[tmpname]])"
			else
				areaindex[tmpname] = 1
			L[tmpname] = I

	var/desc = input("Please select a location to lock in.", "Locking Computer") in L|null
	if(!desc)
		return
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	set_target(L[desc])
	audible_message(SPAN_NOTICE("Locked in."))
	return

/obj/machinery/computer/teleporter/verb/set_id(t as text)
	set category = "Object"
	set name = "Set teleporter ID"
	set src in oview(1)
	set desc = "ID Tag:"

	if(stat & (NOPOWER|BROKEN) || !istype(usr,/mob/living))
		return
	if (t)
		src.id = t
	return

/obj/machinery/computer/teleporter/proc/target_lost()
	audible_message(SPAN_WARNING("Connection with locked in coordinates has been lost."))
	clear_target()

/obj/machinery/computer/teleporter/proc/clear_target()
	if(src.locked)
		events_repository.unregister(/decl/observ/destroyed, locked, src, .proc/target_lost)
	src.locked = null
	if(station && station.engaged)
		station.disengage()

/obj/machinery/computer/teleporter/proc/set_target(var/obj/O)
	src.locked = O
	events_repository.register(/decl/observ/destroyed, locked, src, .proc/target_lost)

/obj/machinery/computer/teleporter/Destroy()
	clear_target()
	station = null
	hub = null
	return ..()

/proc/find_loc(obj/R)
	if (!R)	return null
	var/turf/T = R.loc
	while(!isturf(T))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T

/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/machines/teleporter.dmi'
	density = TRUE
	anchored = TRUE

/obj/machinery/teleport/hub
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon_state = "pad"
	idle_power_usage = 10
	active_power_usage = 2000
	light_color = "#02d1c7"
	var/obj/machinery/computer/teleporter/com

/obj/machinery/teleport/hub/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD // Hub sometimes initializes before stations and computers which mucks with icon update

/obj/machinery/teleport/hub/LateInitialize()
	. = ..()
	queue_icon_update()

/obj/machinery/teleport/hub/on_update_icon()
	z_flags &= ~ZMM_MANGLE_PLANES
	cut_overlays()
	if (com?.station?.engaged)
		add_overlay(emissive_overlay(icon, "[initial(icon_state)]_active_overlay"))
		z_flags |= ZMM_MANGLE_PLANES
		set_light(4, 0.4)
	else
		set_light(0)
		if(operable())
			add_overlay(emissive_overlay(icon, "[initial(icon_state)]_idle_overlay"))
			z_flags |= ZMM_MANGLE_PLANES

/obj/machinery/teleport/hub/Bumped(var/atom/movable/M)
	if (com?.station?.engaged)
		teleport(M)
		use_power_oneoff(5000)

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M)
	if (!com)
		return
	do_teleport(M, com.locked)
	if(com.one_time_use) //Make one-time-use cards only usable one time!
		com.one_time_use = FALSE
		com.locked = null
		if (com.station)
			com.station.engaged = FALSE
		queue_icon_update()
	return

/obj/machinery/teleport/hub/Destroy()
	com = null
	return ..()

/obj/machinery/teleport/station
	name = "projector"
	desc = "This machine is capable of projecting a miniature wormhole leading directly to its provided target."
	icon_state = "station"
	var/engaged = FALSE
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/machinery/computer/teleporter/com
	var/obj/machinery/teleport/hub/hub

/obj/machinery/teleport/station/Initialize()
	. = ..()
	for (var/target_dir in global.cardinal)
		var/obj/machinery/teleport/hub/found_pad = locate() in get_step(src, target_dir)
		if(found_pad)
			set_dir(get_dir(src, found_pad))
			break
	queue_icon_update()

/obj/machinery/teleport/station/on_update_icon()
	. = ..()
	cut_overlays()
	if (engaged)
		add_overlay(emissive_overlay(icon, "[initial(icon_state)]_active_overlay"))
		z_flags |= ZMM_MANGLE_PLANES
	else if (operable())
		add_overlay(emissive_overlay(icon, "[initial(icon_state)]_idle_overlay"))
		z_flags |= ZMM_MANGLE_PLANES
	else
		z_flags &= ~ZMM_MANGLE_PLANES

/obj/machinery/teleport/station/attackby(var/obj/item/W, var/mob/user)
	return attack_hand_with_interaction_checks(user) || ..()

/obj/machinery/teleport/station/interface_interact(var/mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(engaged)
		disengage()
	else
		engage()
	return TRUE

/obj/machinery/teleport/station/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	if (!(com && com.locked))
		audible_message("<span class='warning'>Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix.</span>")
		return

	if(istype(com.locked, /obj/item/radio/beacon))
		var/obj/item/radio/beacon/B = com.locked
		if(!B.functioning)
			audible_message("<span class='warning'>Failure: Unable to establish connection to provided coordinates. Please reinstate coordinate matrix.</span>")
			return

	engaged = TRUE
	queue_icon_update()
	if (hub)
		hub.queue_icon_update()
		use_power_oneoff(5000)
		update_use_power(POWER_USE_ACTIVE)
		hub.update_use_power(POWER_USE_ACTIVE)
		audible_message("<span class='notice'>Teleporter engaged!</span>")
	return

/obj/machinery/teleport/station/proc/disengage()
	if(stat & BROKEN)
		return

	engaged = FALSE
	queue_icon_update()
	if (hub)
		hub.queue_icon_update()
		hub.update_use_power(POWER_USE_IDLE)
		update_use_power(POWER_USE_IDLE)
		audible_message("<span class='notice'>Teleporter disengaged!</span>")
	return

/obj/machinery/teleport/station/Destroy()
	disengage()
	com = null
	hub = null
	return ..()

/obj/machinery/teleport/station/power_change()
	. = ..()
	if (engaged && (stat & NOPOWER))
		disengage()
