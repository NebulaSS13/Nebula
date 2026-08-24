///////////////////////////////
//CABLE STRUCTURE
///////////////////////////////


////////////////////////////////
// Definitions
////////////////////////////////

/* Cable directions (d1 and d2)


>  9   1   5
>    \ | /
>  8 - 0 - 4
>    / | \
>  10  2   6

If d1 = 0 and d2 = 0, there's no cable
If d1 = 0 and d2 = dir, it's a O-X cable, getting from the center of the tile to dir (knot cable)
If d1 = dir1 and d2 = dir2, it's a full X-X cable, getting from dir1 to dir2
By design, d1 is the smallest direction and d2 is the highest
*/

/// Tracks all cable instances, so that powernets don't have to look through the entire world all the time
var/global/list/obj/structure/cable/all_cables = list()
/obj/structure/cable
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer."
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state =  "0-1"
	layer =       EXPOSED_WIRE_LAYER
	color =       COLOR_MAROON
	paint_color = COLOR_MAROON
	anchored = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	level = LEVEL_BELOW_PLATING

	/// The base cable stack that should be produced, not including color.
	/// cable_type::stack_merge_type should equal cable_type, ideally
	var/cable_type = /obj/item/stack/cable_coil
	/// Whether this cable type can be (re)colored.
	var/can_have_color = TRUE
	var/d1
	var/d2
	var/datum/powernet/powernet
	var/obj/machinery/breakerbox/breaker_box

/obj/structure/cable/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	var/datum/powernet/PN = get_powernet()
	if(!PN) return 0

	return PN.draw_power(amount)

/obj/structure/cable/yellow
	color = COLOR_AMBER
	paint_color = COLOR_AMBER

/obj/structure/cable/green
	color = COLOR_GREEN
	paint_color = COLOR_GREEN

/obj/structure/cable/blue
	color = COLOR_CYAN_BLUE
	paint_color = COLOR_CYAN_BLUE

/obj/structure/cable/pink
	color = COLOR_PURPLE
	paint_color = COLOR_PURPLE

/obj/structure/cable/orange
	color = COLOR_ORANGE
	paint_color = COLOR_ORANGE

/obj/structure/cable/cyan
	color = COLOR_SKY_BLUE
	paint_color = COLOR_SKY_BLUE

/obj/structure/cable/white
	color = COLOR_SILVER
	paint_color = COLOR_SILVER

/obj/structure/cable/proc/canonize_cable_dirs()
	// ensure d1 & d2 reflect the icon_state for entering and exiting cable
	var/dir_components = splittext(icon_state, "-")
	if(length(dir_components) < 2)
		CRASH("Cable segment updating dirs with invalid icon_state: [d1], [d2]")
	d1 = text2num(dir_components[1])
	d2 = text2num(dir_components[2])
	if(!(d1 in global.cabledirs) || !(d2 in global.cabledirs))
		CRASH("Cable segment updating dirs with invalid values: [d1], [d2]")

/obj/structure/cable/Initialize(var/ml)
	// ensure d1 & d2 reflect the icon_state for entering and exiting cable
	if(isnull(d1) || isnull(d2))
		canonize_cable_dirs()
	. = ..(ml)
	var/turf/T = src.loc			// hide if turf is not intact
	if(level == LEVEL_BELOW_PLATING && T)
		hide(!T.is_plating())
	global.all_cables += src //add it to the global cable list

/obj/structure/cable/Destroy()     // called when a cable is deleted
	if(powernet)
		cut_cable_from_powernet()  // update the powernets
	global.all_cables -= src              // remove it from global cable list
	. = ..()                       // then go ahead and delete the cable

// Ghost examining the cable -> tells him the power
/obj/structure/cable/attack_ghost(mob/user)
	if(user.client && user.client.inquisitive_ghost)
		user.examine_verb(src)
		// following code taken from attackby (multitool)
		if(powernet && (powernet.avail > 0))
			to_chat(user, SPAN_WARNING("[get_wattage()] in power network."))
		else
			to_chat(user, SPAN_WARNING("\The [src] is not powered."))
	return

///////////////////////////////////
// General procedures
///////////////////////////////////

/obj/structure/cable/proc/get_wattage()
	if(powernet.avail >=  1 GIGAWATTS)
		return "[round(powernet.avail/(1 MEGAWATTS), 0.01)] MW"
	if(powernet.avail >= 1 MEGAWATTS)
		return "[round(powernet.avail/(1 KILOWATTS), 0.01)] kW"
	return "[round(powernet.avail)] W"

//If underfloor, hide the cable
/obj/structure/cable/hide(var/i)
	if(isturf(loc))
		set_invisibility(i ? 101 : 0)
	update_icon()

/obj/structure/cable/hides_under_flooring()
	return 1

/obj/structure/cable/on_update_icon()
	..()
	// this should be less necessary now but it might still be just in case a subtype calls update_icon() in Initialize prior to its parent call
	// which... don't do that, but better safe than sorry.
	if(isnull(d1) || isnull(d2))
		canonize_cable_dirs()
	icon_state = "[d1]-[d2]"
	alpha = invisibility ? 127 : 255

/obj/structure/cable/shuttle_rotate(angle)
	// DON'T CALL PARENT, we never change our actual dir
	if(d1 == 0)
		d2 = turn(d2, angle)
	else
		var/nd1 = min(turn(d1, angle), turn(d2, angle))
		var/nd2 = max(turn(d1, angle), turn(d2, angle))
		d1 = nd1
		d2 = nd2
	update_icon()

// returns the powernet this cable belongs to
/obj/structure/cable/proc/get_powernet()			//TODO: remove this as it is obsolete
	return powernet

// Items usable on a cable :
//   - Wirecutters : cut it duh !
//   - Cable coil : merge cables
//   - Multitool : get the power currently passing through the cable
//

// TODO: take a closer look at cable attackby, make it call parent?
/obj/structure/cable/attackby(obj/item/used_item, mob/user)

	if(IS_WIRECUTTER(used_item))
		cut_wire(used_item, user)
		return TRUE

	if(IS_COIL(used_item))
		var/obj/item/stack/cable_coil/coil = used_item
		if (coil.get_amount() < 1)
			to_chat(user, "You don't have enough cable to lay down.")
			return TRUE
		coil.cable_join(src, user)
		return TRUE

	if(IS_MULTITOOL(used_item))
		if(powernet && (powernet.avail > 0))		// is it powered?
			to_chat(user, SPAN_WARNING("[get_wattage()] in power network."))
			shock(user, 5, 0.2)
		else
			to_chat(user, SPAN_WARNING("\The [src] is not powered."))
		return TRUE

	else if(used_item.has_edge())

		var/delay_holder
		if(used_item.expend_attack_force(user) < 5)
			visible_message(SPAN_WARNING("[user] starts sawing away roughly at \the [src] with \the [used_item]."))
			delay_holder = 8 SECONDS
		else
			visible_message(SPAN_WARNING("[user] begins to cut through \the [src] with \the [used_item]."))
			delay_holder = 3 SECONDS
		if(user.do_skilled(delay_holder, SKILL_ELECTRICAL, src))
			cut_wire(used_item, user)
			if(used_item.obj_flags & OBJ_FLAG_CONDUCTIBLE)
				shock(user, 66, 0.7)
		else
			visible_message(SPAN_WARNING("[user] stops cutting before any damage is done."))
		return TRUE

	return ..()

/obj/structure/cable/proc/cut_wire(obj/item/used_item, mob/user)
	var/turf/T = get_turf(src)
	if(!T || !T.is_plating())
		return

	if(d1 == UP || d2 == UP)
		to_chat(user, SPAN_WARNING("You must cut this [name] from above."))
		return

	if(breaker_box)
		to_chat(user, SPAN_WARNING("This [name] is connected to a nearby breaker box. Use the breaker box to interact with it."))
		return

	if (shock(user, 50))
		return

	new cable_type(T, (src.d1 ? 2 : 1), color)

	visible_message(SPAN_WARNING("[user] cuts \the [src]."))

	if(HasBelow(z))
		for(var/turf/turf in GetBelow(src))
			for(var/obj/structure/cable/c in turf)
				if(c.d1 == UP || c.d2 == UP)
					qdel(c)

	investigate_log("was cut by [key_name(user, user.client)] in [get_area_name(user)]","wires")

	qdel(src)

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
	if(!prob(prb) || powernet?.avail <= 0)
		return FALSE
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		spark_at(src, amount=5, cardinal_only = TRUE)
		if(HAS_STATUS(user, STAT_STUN))
			return TRUE
	return FALSE

// TODO: generalize to matter list and parts_type.
/obj/structure/cable/create_dismantled_products(turf/T)
	SHOULD_CALL_PARENT(FALSE)
	new /obj/item/stack/cable_coil(loc, (d1 ? 2 : 1), color)

//explosion handling
/obj/structure/cable/explosion_act(severity)
	. = ..()
	if(. && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(25))))
		physically_destroyed()

/obj/structure/cable/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/turf/T = get_turf(src)
	if(!T || !T.is_plating())
		return
	. = ..()

/obj/structure/cable/proc/cableColor(var/colorC)
	if(!can_have_color)
		return
	var/color_n = "#dd0000"
	if(colorC)
		color_n = colorC
	set_color(color_n)

/////////////////////////////////////////////////
// Cable laying helpers
////////////////////////////////////////////////

//handles merging diagonally matching cables
//for info : direction^3 is flipping horizontally, direction^12 is flipping vertically
/obj/structure/cable/proc/mergeDiagonalsNetworks(var/direction)

	//search for and merge diagonally matching cables from the first direction component (north/south)
	var/turf/T  = get_step_resolving_mimic(src, direction & (NORTH|SOUTH))

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == (direction ^ (NORTH|SOUTH)) || C.d2 == (direction ^ (NORTH|SOUTH))) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

	//the same from the second direction component (east/west)
	T  = get_step_resolving_mimic(src, direction & (EAST|WEST))

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue
		if(C.d1 == (direction ^ (EAST|WEST)) || C.d2 == (direction ^ (EAST|WEST))) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the given direction
/obj/structure/cable/proc/mergeConnectedNetworks(var/direction)

	var/fdir = direction ? global.reverse_dir[direction] : 0 //flip the direction, to match with the source position on its turf

	if(!(d1 == direction || d2 == direction)) //if the cable is not pointed in this direction, do nothing
		return

	var/turf/TB  = get_zstep_resolving_mimic(src, direction)

	for(var/obj/structure/cable/C in TB)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == fdir || C.d2 == fdir) //we've got a matching cable in the neighbor turf
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the source turf
/obj/structure/cable/proc/mergeConnectedNetworksOnTurf()
	var/list/to_connect = list()

	if(!powernet) //if we somehow have no powernet, make one (should not happen for cables)
		var/datum/powernet/newPN = new()
		newPN.add_cable(src)

	//first let's add turf cables to our powernet
	//then we'll connect machines on turf with a node cable is present
	for(var/AM in loc)
		if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM
			if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) //only connected if they have a common direction
				if(C.powernet == powernet)	continue
				if(C.powernet)
					merge_powernets(powernet, C.powernet)
				else
					powernet.add_cable(C) //the cable was powernetless, let's just add it to our powernet

		else if(istype(AM,/obj/machinery/apc))
			var/obj/machinery/apc/N = AM
			var/obj/machinery/power/terminal/terminal = N.terminal()
			if(!terminal)	continue // APC are connected through their terminal

			if(terminal.powernet == powernet)
				continue

			to_connect += terminal //we'll connect the machines after all cables are merged

		else if(istype(AM,/obj/machinery/power)) //other power machines
			var/obj/machinery/power/M = AM

			if(M.powernet == powernet)
				continue

			to_connect += M //we'll connect the machines after all cables are merged

	//now that cables are done, let's connect found machines
	for(var/obj/machinery/power/PM in to_connect)
		if(!PM.connect_to_network())
			PM.disconnect_from_network() //if we somehow can't connect the machine to the new powernet, remove it from the old nonetheless

//////////////////////////////////////////////
// Powernets handling helpers
//////////////////////////////////////////////

/obj/structure/cable/proc/get_cable_connections(var/skip_assigned_powernets = FALSE)
	. = list()	// this will be a list of all connected power objects
	var/turf/T

	// Handle standard cables in adjacent turfs
	for(var/cable_dir in list(d1, d2))
		if(cable_dir == 0)
			continue
		var/reverse = global.reverse_dir[cable_dir]
		T = get_zstep_resolving_mimic(src, cable_dir)
		if(T)
			for(var/obj/structure/cable/C in T)
				if(C.d1 == reverse || C.d2 == reverse)
					. += C
		if(cable_dir & (cable_dir - 1)) // Diagonal, check for /\/\/\ style cables along cardinal directions
			for(var/pair in list(NORTH|SOUTH, EAST|WEST))
				T = get_step_resolving_mimic(src, cable_dir & pair) // move either vertically or horizontally
				if(T)
					var/req_dir = cable_dir ^ pair // flip along the direction we moved, so if we're NORTHEAST we want a cable to our east that's NORTHWEST
					for(var/obj/structure/cable/C in T)
						if(C.d1 == req_dir || C.d2 == req_dir)
							. += C

	// Handle cables on the same turf as us
	for(var/obj/structure/cable/C in loc)
		if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) // if either of C's d1 and d2 match either of ours
			. += C

	// if asked, skip any cables with powernts
	if(skip_assigned_powernets)
		for(var/obj/structure/cable/C in .)
			if(C.powernet)
				. -= C

/obj/structure/cable/proc/get_machine_connections(var/skip_assigned_powernets = FALSE)
	. = list()	// this will be a list of all connected power objects
	if(d1 == 0)
		for(var/obj/machinery/power/P in loc)
			if(!skip_assigned_powernets || !P.powernet)
				. += P

/obj/structure/cable/proc/get_connections(var/skip_assigned_powernets = FALSE)
	return get_cable_connections(skip_assigned_powernets) + get_machine_connections(skip_assigned_powernets)

//should be called after placing a cable which extends another cable, creating a "smooth" cable that no longer terminates in the centre of a turf.
//needed as this can, unlike other placements, disconnect cables
/obj/structure/cable/proc/denode()
	var/turf/T1 = loc
	if(!T1) return

	var/obj/structure/cable/other_cable = get_matching_cable(T1, src, 0) // find a cable to start a replacement network from, if it exists
	if(other_cable)
		var/datum/powernet/PN = new()
		propagate_network(other_cable,PN) //propagates the new powernet beginning at the source cable

		if(PN.is_empty()) //can happen with machines made nodeless when smoothing cables
			qdel(PN)

// cut the cable's powernet at this cable and updates the powergrid
/obj/structure/cable/proc/cut_cable_from_powernet()
	var/turf/T1 = loc
	var/obj/structure/cable/other_cable
	if(!T1)	return
	if(d1)
		T1 = get_zstep_resolving_mimic(T1, d1)
		other_cable = get_matching_cable(T1, src, d1) // check our adjacent turf for connecting cables first
	if(!other_cable)
		other_cable = get_matching_cable(loc, src, d1) // and fall back to our own turf if we don't find one


	if(!other_cable) // if we didn't find another cable, then the cable was a lone cable, just delete it and its powernet
		powernet.remove_cable(src)

		for(var/obj/machinery/power/P in T1)//check if it was powering a machine
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network (and delete powernet)
		return

	// remove the cut cable from its turf and powernet, so that it doesn't get count in propagate_network worklist
	forceMove(null)
	powernet.remove_cable(src) //remove the cut cable from its powernet

	var/datum/powernet/newPN = new()// creates a new powernet...
	propagate_network(other_cable, newPN)//... and propagates it to the other side of the cable

	// Disconnect machines connected to nodes
	if(d1 == 0) // if we cut a node (O-X) cable
		for(var/obj/machinery/power/P in T1)
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network

	powernet = null // And finally null the powernet var.
