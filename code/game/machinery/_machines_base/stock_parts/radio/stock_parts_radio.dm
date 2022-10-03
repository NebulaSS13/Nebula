/obj/item/stock_parts/radio
	part_flags = PART_FLAG_QDEL
	max_health = ITEM_HEALTH_NO_DAMAGE
	var/datum/radio_frequency/radio
	var/frequency
	var/id_tag
	var/filter
	var/encryption
	var/multitool_extension

/obj/item/stock_parts/radio/Initialize()
	if(frequency)
		set_frequency(frequency, filter)
	if(multitool_extension)
		set_extension(src, multitool_extension)
	. = ..()

/obj/item/stock_parts/radio/on_install(obj/machinery/machine)
	..()
	if(!id_tag)
		set_id_tag(machine.id_tag)

/obj/item/stock_parts/radio/proc/set_id_tag(new_tag)
	id_tag = new_tag
	set_frequency(frequency, filter)

/obj/item/stock_parts/radio/proc/get_receive_filter() // what filter should we register with to recieve updates on?
	return RADIO_NULL

/obj/item/stock_parts/radio/proc/set_frequency(new_frequency, new_filter)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	filter = new_filter
	radio = radio_controller.add_object(src, frequency, get_receive_filter())

/obj/item/stock_parts/radio/Destroy()
	radio_controller.remove_object(src, frequency)
	. = ..()

/obj/item/stock_parts/radio/proc/sanitize_events(obj/machinery/machine, list/events)
	for(var/thing in events)
		if(!is_valid_event(machine, events[thing]))
			LAZYREMOVE(events, thing)

/obj/item/stock_parts/radio/proc/is_valid_event(obj/machinery/machine, decl/public_access/variable)
	return istype(variable) && LAZYACCESS(machine.public_variables, variable.type)