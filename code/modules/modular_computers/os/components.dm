/datum/extension/interactive/os/proc/get_component(var/part_type)
	return locate(part_type) in holder

/datum/extension/interactive/os/proc/get_all_components()
	. = list()
	for(var/obj/item/stock_parts/P in holder)
		. += P

/datum/extension/interactive/os/proc/find_hardware_by_name(var/partname)
	for(var/obj/item/stock_parts/P in holder)
		if(findtext(P.name, partname))
			return P

/datum/extension/interactive/os/proc/has_component(var/part_type)
	return !!get_component(part_type)

/datum/extension/interactive/os/proc/print_paper(content, title, paper_type, list/metadata)
	var/obj/item/stock_parts/computer/nano_printer/printer = get_component(PART_PRINTER)
	if(printer)
		return printer.print_text(content, title, paper_type, metadata)

/datum/extension/interactive/os/proc/get_network_tag()
	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		return network_card.get_network_tag()
	else
		return "N/A"

/datum/extension/interactive/os/proc/get_network_status(var/specific_action = 0)
	var/obj/item/stock_parts/computer/network_card/network_card = get_component(PART_NETWORK)
	if(network_card)
		var/signal_power_level = NETWORK_SPEED_BASE * network_card.get_signal(specific_action)
		if(signal_power_level > 0)
			signal_power_level = round(clamp(signal_power_level, 1, 3))
		return signal_power_level
	else
		return 0

/datum/extension/interactive/os/proc/get_inserted_id()
	var/obj/item/stock_parts/computer/card_slot/card_slot = get_component(PART_CARD)
	if(card_slot)
		return card_slot.stored_card

/datum/extension/interactive/os/proc/max_disk_capacity()
	var/obj/item/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		return hard_drive.max_capacity

/datum/extension/interactive/os/proc/used_disk_capacity()
	var/obj/item/stock_parts/computer/hard_drive/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		return hard_drive.used_capacity

/datum/extension/interactive/os/proc/get_hardware_flag()
	return PROGRAM_ALL

//Used to display in configurator program
/datum/extension/interactive/os/proc/get_power_usage()
	return 0

/datum/extension/interactive/os/proc/recalc_power_usage()

/datum/extension/interactive/os/proc/voltage_overload()
	var/atom/A = holder
	if(istype(A))
		spark_at(A, amount = 10, cardinal_only = TRUE, holder = A)

	var/obj/item/stock_parts/computer/hard_drive = get_component(PART_HDD)
	if(hard_drive)
		qdel(hard_drive)

	var/obj/item/stock_parts/computer/battery_module = get_component(PART_BATTERY)
	if(battery_module && prob(25))
		qdel(battery_module)

	var/obj/item/stock_parts/computer/tesla_link = get_component(PART_TESLA)
	if(tesla_link && prob(50))
		qdel(tesla_link)