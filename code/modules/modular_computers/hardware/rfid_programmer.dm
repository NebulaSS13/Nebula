/obj/item/stock_parts/computer/rfid_programmer
	name = "RFID programmer"
	desc = "Special interface for programming integrated devices or editing access controls. Necessary for some programs to work properly."
	power_usage = 10 // Watts
	critical = 0
	icon_state = "netcard_basic"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 4)
	// usage_flags = PROGRAM_PDA & PROGRAM_TABLET

	var/weakref/linked_device			// What device we're editing the permissions for.

/obj/item/stock_parts/computer/rfid_programmer/proc/link_device(var/mob/usr, var/obj/target)
	linked_device = weakref(target)
	if(target)
		to_chat(usr, "\The [src] chirps in acknowledgement as it's linked to \a [target].")


/obj/item/stock_parts/computer/rfid_programmer/proc/get_device()
	if(!linked_device)
		return
	var/obj/result = linked_device.resolve()
	if(!result)
		return
	if(get_dist(get_turf(src), get_turf(result)) > 1)
		return
	return result