
#define FIREDOOR_MAX_PRESSURE_DIFF 25 // kPa
#define FIREDOOR_MAX_TEMP 50 // °C
#define FIREDOOR_MIN_TEMP 0

// Bitflags
#define FIREDOOR_ALERT_HOT      1
#define FIREDOOR_ALERT_COLD     2
// Not used #define FIREDOOR_ALERT_LOWPRESS 4

/obj/machinery/door/firedoor
	name = "emergency shutter"
	desc = "Emergency airtight shutters, capable of sealing off breached areas."
	icon = 'icons/obj/doors/hazard/door.dmi'
	var/panel_file = 'icons/obj/doors/hazard/panel.dmi'
	var/welded_file = 'icons/obj/doors/hazard/welded.dmi'
	icon_state = "open"
	icon_state_open = "open"
	icon_state_closed = "closed"
	begins_closed = FALSE
	initial_access = list(list(access_atmospherics, access_engine_equip))
	autoset_access = FALSE
	opacity = FALSE
	density = FALSE
	layer = BELOW_DOOR_LAYER
	open_layer = BELOW_DOOR_LAYER
	closed_layer = ABOVE_WINDOW_LAYER
	movable_flags = MOVABLE_FLAG_Z_INTERACT
	pry_mod = 0.75
	atom_flags = ATOM_FLAG_ADJACENT_EXCEPTION

	//These are frequenly used with windows, so make sure zones can pass.
	//Generally if a firedoor is at a place where there should be a zone boundery then there will be a regular door underneath it.
	block_air_zones = 0

	var/blocked = 0
	var/lockdown = 0 // When the door has detected a problem, it locks.
	var/pdiff_alert = 0
	var/pdiff = 0
	var/nextstate = null
	var/list/areas_added
	var/list/users_to_open = new
	var/next_process_time = 0

	var/sound_open = 'sound/machines/airlock_ext_open.ogg'
	var/sound_close = 'sound/machines/airlock_ext_close.ogg'

	power_channel = ENVIRON
	idle_power_usage = 5

	frame_type = /obj/structure/firedoor_assembly
	base_type = /obj/machinery/door/firedoor

	var/list/tile_info[4]
	var/list/dir_alerts[4] // 4 dirs, bitflags

	turf_hand_priority = 2 //Lower priority than normal doors to prevent interference

	// MUST be in same order as FIREDOOR_ALERT_*
	var/list/ALERT_STATES=list(
		"hot",
		"cold"
	)
	var/allow_multiple_instances_on_same_tile = FALSE

/obj/machinery/door/firedoor/get_blend_objects()
	var/static/list/blend_objects = list(
		/obj/machinery/door/firedoor,
		/obj/structure/wall_frame,
		/turf/unsimulated/wall,
		/obj/structure/window
	) // Objects which to blend with
	return blend_objects

/obj/machinery/door/firedoor/autoset
	autoset_access = TRUE	//subtype just to make mapping away sites with custom access usage
	req_access = list()

/obj/machinery/door/firedoor/Initialize()
	. = ..()
	for(var/obj/machinery/door/firedoor/F in loc)
		if(F != src && !F.allow_multiple_instances_on_same_tile)
			return INITIALIZE_HINT_QDEL

	update_area_registrations()

/obj/machinery/door/firedoor/Destroy()
	for(var/area/A in areas_added)
		unregister_area(A)
	. = ..()

/obj/machinery/door/firedoor/proc/register_area(area/A)
	if(A && !(A in areas_added))
		LAZYADD(A.all_doors, src)
		LAZYADD(areas_added, A)

/obj/machinery/door/firedoor/proc/unregister_area(area/A)
	LAZYREMOVE(A.all_doors, src)
	LAZYREMOVE(areas_added, A)

/obj/machinery/door/firedoor/proc/update_area_registrations()
	var/list/new_areas = list()
	var/area/A = get_area(src)
	if(A)
		new_areas += A
		for(var/direction in global.cardinal)
			A = get_area(get_step(src,direction))
			if(A)
				new_areas |= A
	for(var/area in areas_added)
		if(!(area in new_areas))
			unregister_area(area)
	for(var/area in (new_areas - areas_added))
		register_area(area)

/obj/machinery/door/firedoor/get_material()
	RETURN_TYPE(/decl/material)
	return GET_DECL(/decl/material/solid/metal/steel)

/obj/machinery/door/firedoor/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 1 || !density)
		return

	if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
		. += SPAN_DANGER("WARNING: Current pressure differential is [pdiff]kPa! Opening door may result in injury!")

	. += "<b>Sensor readings:</b>"
	for(var/index = 1; index <= tile_info.len; index++)
		var/list/direction_strings = list("&nbsp;&nbsp;")
		switch(index)
			if(1)
				direction_strings += "NORTH: "
			if(2)
				direction_strings += "SOUTH: "
			if(3)
				direction_strings += "EAST: "
			if(4)
				direction_strings += "WEST: "
		if(tile_info[index] == null)
			direction_strings += "<span class='warning'>DATA UNAVAILABLE</span>"
			. += JOINTEXT(direction_strings)
			continue
		var/celsius = convert_k2c(tile_info[index][1])
		var/pressure = tile_info[index][2]
		direction_strings += "<span class='[(dir_alerts[index] & (FIREDOOR_ALERT_HOT|FIREDOOR_ALERT_COLD)) ? "warning" : "color:blue"]'>"
		direction_strings += "[celsius]&deg;C</span> "
		direction_strings += "<span style='color:blue'>"
		direction_strings += "[pressure]kPa</span></li>"
		. += JOINTEXT(direction_strings)
	if(islist(users_to_open) && users_to_open.len)
		var/users_to_open_string = users_to_open[1]
		if(users_to_open.len >= 2)
			for(var/i = 2 to users_to_open.len)
				users_to_open_string += ", [users_to_open[i]]"
		. += "These people have opened \the [src] during an alert: [users_to_open_string]."

/obj/machinery/door/firedoor/Bumped(atom/AM)
	if(panel_open || operating)
		return
	if(!density)
		return ..()
	return 0

/obj/machinery/door/firedoor/physical_attack_hand(mob/user)
	if(operating)
		return FALSE//Already doing something.

	. = TRUE
	if(blocked)
		to_chat(user, "<span class='warning'>\The [src] is welded solid!</span>")
		return

	var/alarmed = lockdown
	for(var/area/A in areas_added)		//Checks if there are fire alarms in any areas associated with that firedoor
		if(A.fire || A.air_doors_activated)
			alarmed = 1

	var/answer = alert(user, "Would you like to [density ? "open" : "close"] this [src.name]?[ alarmed && density ? "\nNote that by doing so, you acknowledge any damages from opening this\n[src.name] as being your own fault, and you will be held accountable under the law." : ""]",\
	"\The [src]", "Yes, [density ? "open" : "close"]", "No")
	if(answer == "No")
		return
	if(user.incapacitated() || (get_dist(src, user) > 1  && !issilicon(user)))
		to_chat(user, "Sorry, you must remain able bodied and close to \the [src] in order to use it.")
		return
	if(density && (stat & (BROKEN|NOPOWER))) //can still close without power
		to_chat(user, "\The [src] is not functioning, you'll have to force it open manually.")
		return

	if(alarmed && density && lockdown && !allowed(user))
		to_chat(user, "<span class='warning'>Access denied. Please wait for authorities to arrive, or for the alert to clear.</span>")
		return
	else
		user.visible_message("<span class='notice'>\The [src] [density ? "open" : "close"]s for \the [user].</span>",\
		"\The [src] [density ? "open" : "close"]s.",\
		"You hear a beep, and a door opening.")

	var/needs_to_close = 0
	if(density)
		if(alarmed)
			// Accountability!
			users_to_open |= user.name
			needs_to_close = !issilicon(user)
		spawn()
			open()
	else
		spawn()
			close()

	if(needs_to_close)
		spawn(50)
			alarmed = 0
			for(var/area/A in areas_added)		//Just in case a fire alarm is turned off while the firedoor is going through an autoclose cycle
				if(A.fire || A.air_doors_activated)
					alarmed = 1
			if(alarmed)
				nextstate = FIREDOOR_CLOSED
				close()

/obj/machinery/door/firedoor/attackby(obj/item/used_item, mob/user)
	add_fingerprint(user, 0, used_item)
	if(operating)
		return TRUE //Already doing something.
	if(IS_WELDER(used_item) && !repairing)
		var/obj/item/weldingtool/welder = used_item
		if(welder.weld(0, user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, 2 SECONDS, src))
				if(!welder.isOn()) return TRUE
				blocked = !blocked
				user.visible_message("<span class='danger'>\The [user] [blocked ? "welds" : "unwelds"] \the [src] with \a [welder].</span>",\
				"You [blocked ? "weld" : "unweld"] \the [src] with \the [welder].",\
				"You hear something being welded.")
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
				update_icon()
			else
				to_chat(user, SPAN_WARNING("You must remain still to complete this task."))
		return TRUE

	if(blocked && IS_CROWBAR(used_item))
		user.visible_message("<span class='danger'>\The [user] pries at \the [src] with \a [used_item], but \the [src] is welded in place!</span>",\
		"You try to pry \the [src] [density ? "open" : "closed"], but it is welded in place!",\
		"You hear someone struggle and metal straining.")
		return TRUE

	if(!blocked && (IS_CROWBAR(used_item) || istype(used_item,/obj/item/bladed/axe/fire)))
		if(operating)
			return ..()

		if(istype(used_item,/obj/item/bladed/axe/fire))
			var/obj/item/bladed/axe/fire/F = used_item
			if(!F.is_held_twohanded())
				return ..()

		user.visible_message("<span class='danger'>\The [user] starts to force \the [src] [density ? "open" : "closed"] with \a [used_item]!</span>",\
				"You start forcing \the [src] [density ? "open" : "closed"] with \the [used_item]!",\
				"You hear metal strain.")
		if(do_after(user, 3 SECONDS, src))
			if(IS_CROWBAR(used_item))
				if(stat & (BROKEN|NOPOWER) || !density)
					user.visible_message("<span class='danger'>\The [user] forces \the [src] [density ? "open" : "closed"] with \a [used_item]!</span>",\
					"You force \the [src] [density ? "open" : "closed"] with \the [used_item]!",\
					"You hear metal strain, and a door [density ? "open" : "close"].")
				else
					user.visible_message("<span class='danger'>\The [user] forces \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \a [used_item]!</span>",\
						"You force \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \the [used_item]!",\
						"You hear metal strain and groan, and a door [density ? "opening" : "closing"].")
			if(density)
				open(1)
			else
				close()
		else
			to_chat(user, "<span class='notice'>You must remain still to interact with \the [src].</span>")
		return TRUE

	return ..()

/obj/machinery/door/firedoor/dismantle(var/moved = FALSE)
	var/obj/structure/firedoor_assembly/FA = ..()
	. = FA
	FA.anchored = !moved
	FA.set_density(1)
	FA.wired = 1
	FA.update_icon()

// CHECK PRESSURE
/obj/machinery/door/firedoor/Process()
	if(density && next_process_time <= world.time)
		next_process_time = world.time + 100		// 10 second delays between process updates
		var/changed = 0
		lockdown=0
		// Pressure alerts
		pdiff = get_surrounding_pressure_differential(loc, src)
		if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
			lockdown = 1
			if(!pdiff_alert)
				pdiff_alert = 1
				changed = 1 // update_icon()
		else
			if(pdiff_alert)
				pdiff_alert = 0
				changed = 1 // update_icon()

		tile_info = getCardinalAirInfo(src.loc,list("temperature","pressure"))
		var/old_alerts = dir_alerts
		for(var/index = 1; index <= 4; index++)
			var/list/tileinfo=tile_info[index]
			if(tileinfo==null)
				continue // Bad data.
			var/celsius = convert_k2c(tileinfo[1])

			var/alerts=0

			// Temperatures
			if(celsius >= FIREDOOR_MAX_TEMP)
				alerts |= FIREDOOR_ALERT_HOT
				lockdown = 1
			else if(celsius <= FIREDOOR_MIN_TEMP)
				alerts |= FIREDOOR_ALERT_COLD
				lockdown = 1

			dir_alerts[index]=alerts

		if(dir_alerts != old_alerts)
			changed = 1
		if(changed)
			update_icon()

/obj/machinery/door/firedoor/proc/latetoggle()
	if(operating || !nextstate)
		return
	switch(nextstate)
		if(FIREDOOR_OPEN)
			nextstate = null

			open()
		if(FIREDOOR_CLOSED)
			nextstate = null
			close()
	return

/obj/machinery/door/firedoor/close()
	latetoggle()
	return ..()

/obj/machinery/door/firedoor/open(var/forced = 0)
	if(panel_open)
		panel_open = FALSE
		if(istype(construct_state, /decl/machine_construction/default/panel_open))
			var/decl/machine_construction/default/panel_open/open = construct_state
			construct_state = GET_DECL(open.up_state)
			construct_state.validate_state(src)
		visible_message("The maintenance hatch of \the [src] closes.")
		update_icon()

	if(!forced)
		if(stat & (BROKEN|NOPOWER))
			return //needs power to open unless it was forced
		else
			use_power_oneoff(360)
	else
		log_and_message_admins("has forced open an emergency shutter.")
	latetoggle()
	return ..()

// Only opens when all areas connecting with our turf have an air alarm and are cleared
/obj/machinery/door/firedoor/proc/can_safely_open()
	var/turf/neighbour
	var/turf/myturf = loc
	if(!istype(myturf))
		return TRUE
	for(var/dir in global.cardinal)
		neighbour = get_step(myturf, dir)
		if(!neighbour)
			continue
		var/airblock // zeroed by ATMOS_CANPASS_TURF, declared early as microopt
		ATMOS_CANPASS_TURF(airblock, neighbour, myturf)
		if(airblock & AIR_BLOCKED)
			continue
		for(var/obj/thing in myturf)
			if(istype(thing, /obj/machinery/door))
				continue
			ATMOS_CANPASS_MOVABLE(airblock, thing, neighbour)
			. |= airblock
		if(. & AIR_BLOCKED)
			continue
		var/area/A = get_area(neighbour)
		if(A.atmosalm)
			return
		var/obj/machinery/alarm/alarm = locate() in A
		if(!alarm || (alarm.stat & (NOPOWER|BROKEN)))
			return
	return TRUE

/obj/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("opening", src)
			playsound(src, sound_open, 45, 1)
		if("closing")
			flick("closing", src)
			playsound(src, sound_close, 45, 1)
	return


/obj/machinery/door/firedoor/on_update_icon()
	cut_overlays()
	set_light(0)
	var/do_set_light = FALSE

	if(set_dir_on_update)
		if(connections & (NORTH|SOUTH))
			set_dir(EAST)
		else
			set_dir(SOUTH)

	if(density)
		icon_state = "closed"
		if(panel_open)
			add_overlay(panel_file)
		if(pdiff_alert)
			add_overlay("palert")
			do_set_light = TRUE
		if(dir_alerts)
			for(var/d=1;d<=4;d++)
				var/cdir = global.cardinal[d]
				for(var/i=1;i<=ALERT_STATES.len;i++)
					if(dir_alerts[d] & BITFLAG(i-1))
						add_overlay(new/icon(icon,"alert_[ALERT_STATES[i]]", dir=cdir))
						do_set_light = TRUE
	else
		icon_state = "open"

	if(blocked)
		add_overlay(welded_file)

	if(do_set_light)
		set_light(2, 0.25, COLOR_SUN)

//Single direction firedoors.
/obj/machinery/door/firedoor/border
	icon = 'icons/obj/doors/hazard/door_border.dmi'
	allow_multiple_instances_on_same_tile = TRUE
	set_dir_on_update = FALSE
	heat_proof = TRUE

	//There is a glass window so you can see through the door
	//This is needed due to BYOND limitations in controlling visibility
	glass = TRUE

/obj/machinery/door/firedoor/border/autoset
	autoset_access = TRUE
	req_access = list()

/obj/machinery/door/firedoor/border/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return TRUE
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group)
			return FALSE
		return !density
	else
		return TRUE

/obj/machinery/door/firedoor/border/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	else
		return TRUE

/obj/machinery/door/firedoor/border/update_nearby_tiles(need_rebuild)
	var/turf/source = get_turf(src)
	var/turf/destination = get_step(source,dir)

	update_heat_protection(loc)

	if(istype(source) && source.simulated)
		SSair.mark_for_update(source)
	if(istype(destination) && destination.simulated)
		SSair.mark_for_update(destination)
	return TRUE
