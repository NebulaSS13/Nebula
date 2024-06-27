/obj/machinery/tracking_beacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "tracking beacon"
	desc = "A device that uses zero-point energy to create a permanent tracking beacon."
	level = LEVEL_BELOW_PLATING
	anchored = TRUE
	idle_power_usage = 0
	var/obj/item/radio/beacon/beacon

/obj/machinery/tracking_beacon/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		beacon = new /obj/item/radio/beacon(T)
		beacon.set_invisibility(INVISIBILITY_MAXIMUM)
	hide(!T?.is_plating())

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
	var/turf/my_turf = get_turf(src)
	if(!beacon && my_turf)
		beacon = new /obj/item/radio/beacon(my_turf)
		beacon.set_invisibility(INVISIBILITY_MAXIMUM)
	if(beacon && beacon.loc != my_turf)
		beacon.forceMove(my_turf)
	update_icon()