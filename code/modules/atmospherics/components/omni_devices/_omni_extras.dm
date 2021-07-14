//--------------------------------------------
// Omni device port types
//--------------------------------------------
#define ATM_NONE	0
#define ATM_INPUT	1
#define ATM_OUTPUT	2

#define ATM_O2		3
#define ATM_N2		4
#define ATM_CO2		5
#define ATM_N2O		6
#define ATM_H2		7

//--------------------------------------------
// Omni port datum
//
// Used by omni devices to manage connections
//  to other atmospheric objects.
//--------------------------------------------
/datum/omni_port
	var/obj/machinery/atmospherics/omni/master
	var/direction
	var/update = 1
	var/mode = 0
	var/concentration = 0
	var/con_lock = 0
	var/transfer_moles = 0
	var/datum/gas_mixture/air
	var/list/nodes // lazy list of nodes
	var/datum/pipe_network/network

/datum/omni_port/New(var/obj/machinery/atmospherics/omni/M, var/direction = NORTH)
	..()
	src.direction = direction
	if(istype(M))
		master = M
	air = new
	air.volume = 200

/datum/omni_port/Destroy()
	QDEL_NULL(network)
	QDEL_NULL(air)
	master = null
	nodes = null
	. = ..()

/datum/omni_port/proc/connect()
	if(LAZYLEN(nodes))
		return
	master.atmos_init()
	for(var/obj/machinery/atmospherics/node as anything in nodes)
		node.atmos_init()
	master.build_network()
	for(var/obj/machinery/atmospherics/node as anything in nodes)
		node.build_network()

/datum/omni_port/proc/disconnect()
	for(var/obj/machinery/atmospherics/node as anything in nodes)
		node.disconnect(master)
		master.disconnect(node)


//--------------------------------------------
// Need to find somewhere else for these
//--------------------------------------------

//returns a text string based on the direction flag input
// if capitalize is true, it will return the string capitalized
// otherwise it will return the direction string in lower case
/proc/dir_name(var/dir, var/capitalize = 0)
	var/string = null
	switch(dir)
		if(NORTH)
			string = "North"
		if(SOUTH)
			string = "South"
		if(EAST)
			string = "East"
		if(WEST)
			string = "West"

	if(!capitalize && string)
		string = lowertext(string)

	return string

//returns a direction flag based on the string passed to it
// case insensitive
/proc/dir_flag(var/direction)
	direction = lowertext(direction)
	switch(direction)
		if("north")
			return NORTH
		if("south")
			return SOUTH
		if("east")
			return EAST
		if("west")
			return WEST
		else
			return 0

/proc/mode_to_gasid(var/mode)
	switch(mode)
		if(ATM_O2)
			return /decl/material/gas/oxygen
		if(ATM_N2)
			return /decl/material/gas/nitrogen
		if(ATM_CO2)
			return /decl/material/gas/carbon_dioxide
		if(ATM_N2O)
			return /decl/material/gas/nitrous_oxide
		if(ATM_H2)
			return /decl/material/gas/hydrogen
		else
			return null
