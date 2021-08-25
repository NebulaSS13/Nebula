var/global/const/NETWORK_COMMAND = "Command"
var/global/const/NETWORK_ENGINE  = "Engine"
var/global/const/NETWORK_ENGINEERING_OUTPOST = "Engineering Outpost"

/datum/map/proc/get_shared_network_access(var/network)
	switch(network)
		if(NETWORK_COMMAND)
			return access_heads
		if(NETWORK_ENGINE, NETWORK_ENGINEERING_OUTPOST)
			return access_engine

//
// Cameras
//

// Networks
/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/crescent
	network = list(NETWORK_CRESCENT)

/obj/machinery/camera/network/engine
	network = list(NETWORK_ENGINE)

/obj/machinery/camera/network/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

// Motion
/obj/machinery/camera/motion/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

// All Upgrades
/obj/machinery/camera/all/command
	network = list(NETWORK_COMMAND)

// Compile stubs.
/obj/machinery/camera/motion/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/maintenance
	network = list(NETWORK_ENGINEERING)

/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/network/exodus
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/network/civilian_east
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/network/civilian_west
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/network/prison
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/xray/medbay
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/xray/research
	network = list(NETWORK_SECURITY)
