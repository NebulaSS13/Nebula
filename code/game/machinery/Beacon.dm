/obj/machinery/tracking_beacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "tracking beacon"
	desc = "A device that uses zero-point energy to create a permanent tracking beacon."
	level = 1		// underfloor
	anchored = 1
	idle_power_usage = 0
	var/obj/item/radio/beacon/beacon

/obj/machinery/tracking_beacon/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	beacon = new /obj/item/radio/beacon(T)
	beacon.invisibility = INVISIBILITY_MAXIMUM

	hide(!T.is_plating())

/obj/machinery/tracking_beacon/Destroy()
	QDEL_NULL(beacon)
	. = ..()

	// update the invisibility and icon
/obj/machinery/tracking_beacon/hide(var/intact)
	set_invisibility(intact ? 101 : 0)
	update_icon()

	// update the icon_state
/obj/machinery/tracking_beacon/on_update_icon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"

	else
		icon_state = "[state]"

/obj/machinery/tracking_beacon/Process()
	if(!beacon)
		beacon = new /obj/item/radio/beacon(get_turf(src))
		beacon.set_invisibility(INVISIBILITY_MAXIMUM)
	if(beacon)
		if(beacon.loc != loc)
			beacon.forceMove(loc)

	update_icon()