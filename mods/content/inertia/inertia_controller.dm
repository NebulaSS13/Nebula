/// A list of all inertial dampers in existence. This is only used for assigning them to ships at roundstart.
var/global/list/ship_inertial_dampers = list()

/datum/ship_inertial_damper
	var/name = "ship inertial damper"
	var/obj/machinery/inertial_damper/holder

/datum/ship_inertial_damper/proc/get_damping_strength(var/reliable)
	return holder.get_damping_strength(reliable)

/datum/ship_inertial_damper/New(var/obj/machinery/inertial_damper/_holder)
	..()
	holder = _holder
	global.ship_inertial_dampers += src

/datum/ship_inertial_damper/Destroy()
	global.ship_inertial_dampers -= src
	// This may need some future optimization for servers with lots of ships.
	// Just track what ship we're assigned to somehow, and then use that here.
	// You'd also have to register it to clear that ref if/when the ship object is destroyed.
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.ships)
		S.inertial_dampers -= src
	holder = null
	. = ..()