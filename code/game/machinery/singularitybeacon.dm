var/global/list/singularity_beacons = list()

////////////////////////////////////////
//Singularity beacon
////////////////////////////////////////
/obj/machinery/singularity_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "beaconsynd"

	uncreated_component_parts = list(/obj/item/stock_parts/power/terminal)
	anchored = FALSE
	density = TRUE
	layer = BASE_ABOVE_OBJ_LAYER //so people can't hide it and it's REALLY OBVIOUS
	stat = 0
	use_power = POWER_USE_OFF

/obj/machinery/singularity_beacon/Initialize()
	. = ..()
	global.singularity_beacons += src

/obj/machinery/singularity_beacon/Destroy()
	if(use_power)
		Deactivate()
	global.singularity_beacons -= src
	return ..()

/obj/machinery/singularity_beacon/proc/Activate(mob/user = null)
	for(var/obj/effect/singularity/singulo in global.singularities)
		if(singulo.z == z)
			singulo.target = src
	icon_state = "[initial(icon_state)]1"
	update_use_power(POWER_USE_ACTIVE)
	if(user)
		to_chat(user, SPAN_NOTICE("You activate the beacon."))

/obj/machinery/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/obj/effect/singularity/singulo in global.singularities)
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[initial(icon_state)]0"
	update_use_power(POWER_USE_OFF)
	if(user)
		to_chat(user, SPAN_NOTICE("You deactivate the beacon."))

/obj/machinery/singularity_beacon/physical_attack_hand(var/mob/user)
	. = TRUE
	if(anchored)
		if(use_power)
			Deactivate(user)
		else
			Activate(user)
	else
		to_chat(user, SPAN_DANGER("You need to screw the beacon to the floor first!"))

/obj/machinery/singularity_beacon/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		if(use_power)
			to_chat(user, SPAN_DANGER("You need to deactivate the beacon first!"))
			return

		if(anchored)
			anchored = FALSE
			to_chat(user, SPAN_NOTICE("You unscrew the beacon from the floor."))
			return
		else
			anchored = TRUE
			to_chat(user, SPAN_NOTICE("You screw the beacon to the floor."))
			return
	..()
	return

// Ensure the terminal is always accessible to be plugged in.
/obj/machinery/singularity_beacon/components_are_accessible(var/path)
	if(ispath(path, /obj/item/stock_parts/power/terminal))
		return TRUE
	return ..()

/obj/machinery/singularity_beacon/power_change()
	. = ..()
	if(!. || !use_power)
		return
	if(stat & NOPOWER)
		Deactivate()
