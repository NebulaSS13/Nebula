//////////////////////////////
// POWER MACHINERY BASE CLASS
// This subtype is for machinery which needs to be directly referenced by its parent powernet during powernet processing.
// This subtype does not encompass all power generating machinery, or machinery that needs to draw from a powernet in general.
//////////////////////////////

/////////////////////////////
// Definitions
/////////////////////////////

/obj/machinery/power
	name = null
	icon = 'icons/obj/power.dmi'
	anchored = TRUE
	var/datum/powernet/powernet = null
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/power/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/power/Destroy()
	disconnect_from_network()
	. = ..()

///////////////////////////////
// General procedures
//////////////////////////////


/obj/machinery/power/powered()
	if(use_power)
		return ..()
	return 1 //doesn't require an external power source

// common helper procs for all power machines
/obj/machinery/power/drain_power(var/drain_check, var/surge, var/amount = 0)
	if(drain_check)
		return 1

	if(powernet && powernet.avail)
		powernet.trigger_warning()
		return powernet.draw_power(amount)

/obj/machinery/power/proc/draw_power(var/amount)
	if(powernet)
		return powernet.draw_power(amount)
	return 0

/obj/machinery/power/proc/surplus()
	if(powernet)
		return powernet.avail-powernet.load
	else
		return 0
/obj/machinery/power/proc/add_avail(var/amount)
	if(powernet)
		powernet.newavail += amount
		return 1
	return 0

/obj/machinery/power/proc/avail()
	if(powernet)
		return powernet.avail
	else
		return 0

// connect the machine to a powernet if a node cable is present on the turf
/obj/machinery/power/proc/connect_to_network()
	var/datum/powernet/P = get_powernet()
	if(P)
		P.add_machine(src)
		return TRUE

// remove and disconnect the machine from its current powernet
/obj/machinery/power/proc/disconnect_from_network()
	if(!powernet)
		return
	powernet.remove_machine(src)
	return TRUE

// attach a wire to a power machine - leads from the turf you are standing on
//almost never called, overwritten by all power machines but terminal and generator
/obj/machinery/power/attackby(obj/item/W, mob/user)
	if((. = ..()))
		return
	if(IS_COIL(W))
		var/obj/item/stack/cable_coil/coil = W
		var/turf/T = user.loc
		if(!istype(T) || T.density || T.cannot_build_cable())
			return
		if(get_dist(src, user) > 1)
			return
		coil.turf_place(T, user)
		return TRUE

///////////////////////////////////////////
// GLOBAL PROCS for powernets handling
//////////////////////////////////////////


// returns a list of all power-related objects (nodes, cable, junctions) in turf,
// excluding source, that match the direction d
// if unmarked==1, only return those with no powernet
/proc/power_list(var/turf/T, var/source, var/d, var/unmarked=0, var/cable_only = 0)
	. = list()

	var/reverse = d ? global.reverse_dir[d] : 0
	for(var/AM in T)
		if(AM == source)	continue			//we don't want to return source

		if(!cable_only && istype(AM,/obj/machinery/power))
			var/obj/machinery/power/P = AM
			if(P.powernet == 0)	continue		// exclude APCs which have powernet=0

			if(!unmarked || !P.powernet)		//if unmarked=1 we only return things with no powernet
				if(d == 0)
					. += P

		else if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM

			if(!unmarked || !C.powernet)
				if(C.d1 == d || C.d2 == d || C.d1 == reverse || C.d2 == reverse )
					. += C
	return .

//remove the old powernet and replace it with a new one throughout the network.
/proc/propagate_network(var/obj/structure/cable/cable, var/datum/powernet/PN)
	//to_world_log("propagating new network")
	var/list/cables = list()
	var/list/found_machines = list()
	var/index = 1
	var/obj/structure/cable/working_cable = null

	// add the first cable to the list
	cables[cable] = TRUE // associative list for speedy deduplication
	while(index <= length(cables)) //until we've exhausted all power objects
		working_cable = cables[index] //get the next power object found
		index++

		for(var/new_cable in working_cable.get_cable_connections()) //get adjacent cables, with or without a powernet
			cables[new_cable] = TRUE

	for(var/obj/structure/cable/cable_entry in cables)
		PN.add_cable(cable_entry)
		found_machines += cable_entry.get_machine_connections()
	//now that the powernet is set, connect found machines to it
	for(var/obj/machinery/power/PM in found_machines)
		if(!PM.connect_to_network()) //couldn't find a node on its turf...
			PM.disconnect_from_network() //... so disconnect if already on a powernet


//Merge two powernets, the bigger (in cable length term) absorbing the other
/proc/merge_powernets(var/datum/powernet/net1, var/datum/powernet/net2)
	if(!net1 || !net2) //if one of the powernet doesn't exist, return
		return

	if(net1 == net2) //don't merge same powernets
		return

	//We assume net1 is larger. If net2 is in fact larger we are just going to make them switch places to reduce on code.
	if(net1.cables.len < net2.cables.len)	//net2 is larger than net1. Let's switch them around
		var/temp = net1
		net1 = net2
		net2 = temp

	//merge net2 into net1
	for(var/obj/structure/cable/Cable in net2.cables) //merge cables
		net1.add_cable(Cable)

	if(!net2) return net1

	for(var/obj/machinery/power/Node in net2.nodes) //merge power machines
		if(!Node.connect_to_network())
			Node.disconnect_from_network() //if somehow we can't connect the machine to the new powernet, disconnect it from the old nonetheless

	return net1

//Determines how strong could be shock, deals damage to mob, uses power.
//M is a mob who touched wire/whatever
//power_source is a source of electricity, can be powercell, area, apc, cable, powernet or null
//source is an object caused electrocuting (airlock, grille, etc)
//No animations will be performed by this proc.
/proc/electrocute_mob(mob/living/M, var/power_source, var/obj/source, var/siemens_coeff = 1.0)
	var/area/source_area
	if(istype(power_source,/area))
		source_area = power_source
		power_source = source_area.get_apc()
	if(istype(power_source,/obj/structure/cable))
		var/obj/structure/cable/Cable = power_source
		power_source = Cable.powernet

	var/datum/powernet/PN
	var/obj/item/cell/cell

	if(istype(power_source,/datum/powernet))
		PN = power_source
	else if(istype(power_source,/obj/item/cell))
		cell = power_source
	else if(istype(power_source,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/apc = power_source
		cell = apc.get_cell()
		var/obj/machinery/power/terminal/term = apc.terminal()
		if (term)
			PN = term.powernet
	else if (!power_source)
		return 0
	else
		log_admin("ERROR: /proc/electrocute_mob([M], [power_source], [source]): wrong power_source")
		return 0
	//Triggers powernet warning, but only for 5 ticks (if applicable)
	//If following checks determine user is protected we won't alarm for long.
	if(PN)
		PN.trigger_warning(5)
	if(ishuman(M))
		var/mob/living/human/H = M
		if(H.species.get_shock_vulnerability(H) <= 0)
			return
		var/obj/item/clothing/gloves/G = H.get_equipped_item(slot_gloves_str)
		if(istype(G) && G.siemens_coefficient == 0)
			return 0 //to avoid spamming with insulated glvoes on

	//Checks again. If we are still here subject will be shocked, trigger standard 20 tick warning
	//Since this one is longer it will override the original one.
	if(PN)
		PN.trigger_warning()

	if (!cell && !PN)
		return 0
	var/PN_damage = 0
	var/cell_damage = 0
	if (PN)
		PN_damage = PN.get_electrocute_damage()
	if (cell)
		cell_damage = cell.get_electrocute_damage()
	var/shock_damage = 0
	if (PN_damage>=cell_damage)
		power_source = PN
		shock_damage = PN_damage
	else
		power_source = cell
		shock_damage = cell_damage
	var/drained_hp = M.electrocute_act(shock_damage, source, siemens_coeff) //zzzzzzap!
	var/drained_energy = drained_hp*20

	if (source_area)
		source_area.use_power_oneoff(drained_energy/CELLRATE)
	else if (istype(power_source,/datum/powernet))
		var/drained_power = drained_energy/CELLRATE
		drained_power = PN.draw_power(drained_power)
	else if (istype(power_source, /obj/item/cell))
		cell.use(drained_energy)
	return drained_energy
