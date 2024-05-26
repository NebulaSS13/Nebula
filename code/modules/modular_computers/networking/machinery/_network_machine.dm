/obj/machinery/network
	name = "base network machine"
	icon = 'icons/obj/machines/tcomms/bus.dmi'
	icon_state = "bus"
	density = TRUE
	anchored = TRUE

	var/main_template = "network_mainframe.tmpl"
	var/network_device_type =  /datum/extension/network_device
	var/error

	var/initial_network_id
	var/initial_network_key
	var/wired_connection = FALSE	// Whether or not this machine will start with a local network connection.
	var/produces_heat = TRUE		// If true, produces and is affected by heat.
	var/inefficiency = 0.12			// How much power is waste heat.
	var/heat_threshold = 90 CELSIUS	// At what temperature the machine will lock up.
	var/overheated = FALSE

	var/tmp/tag_network_tag //The name of this device on the network set by mapper

/obj/machinery/network/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_network_id, map_hash)
	ADJUST_TAG_VAR(initial_network_key, map_hash)
	ADJUST_TAG_VAR(tag_network_tag, map_hash)

/obj/machinery/network/Initialize()
	var/datum/extension/network_device/ND = get_or_create_extension(src, network_device_type, initial_network_id, initial_network_key, RECEIVER_STRONG_WIRELESS)
	if(length(tag_network_tag))
		ND.set_network_tag(tag_network_tag)
	. = ..()

/obj/machinery/network/populate_parts(full_populate)
	. = ..()
	if(full_populate && wired_connection)
		install_component(/obj/item/stock_parts/computer/lan_port, FALSE)

/obj/machinery/network/proc/is_overheated()
	var/turf/L = loc
	if(istype(L) && L.simulated)
		var/datum/gas_mixture/env = L.return_air()
		if(env.temperature >= heat_threshold)
			return TRUE

/obj/machinery/network/on_update_icon()
	icon_state = initial(icon_state)
	if(panel_open)
		icon_state = "[icon_state]_o"
	if(!operable())
		icon_state = "[icon_state]_off"

/obj/machinery/network/proc/produce_heat()
	if (!produces_heat || !use_power || !operable())
		return
	var/turf/L = loc
	if(istype(L) && L.simulated)
		var/datum/gas_mixture/env = L.return_air()
		var/transfer_moles = 0.25 * env.total_moles
		var/datum/gas_mixture/removed = env.remove(transfer_moles) // Air is moved through computer vents.
		if(removed)
			removed.add_thermal_energy(idle_power_usage * inefficiency)
		env.merge(removed)

/obj/machinery/network/Process()
	set_overheated(is_overheated())
	if(stat & (BROKEN|NOPOWER))
		return
	produce_heat()

/obj/machinery/network/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/network/ui_data(mob/user, ui_key)
	var/list/data[0]
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!istype(D))
		error = "HARDWARE FAILURE: NETWORK DEVICE NOT FOUND"
		data["error"] = error
		return data
	data["error"] = error
	data += D.ui_data(user, ui_key)
	return data

/obj/machinery/network/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	if(href_list["refresh"])
		error = null
		return TOPIC_REFRESH
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!D)
		return TOPIC_HANDLED
	if(href_list["settings"])
		D.ui_interact(user)
		return TOPIC_HANDLED

/obj/machinery/network/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, main_template, capitalize(name), 380, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/network/power_change()
	. = ..()
	if(. && get_extension(src, /datum/extension/network_device))
		update_network_status()

/obj/machinery/network/set_broken(new_state, cause = MACHINE_BROKEN_GENERIC)
	. = ..()
	if(. && get_extension(src, /datum/extension/network_device))
		update_network_status()

/obj/machinery/network/proc/set_overheated(new_state)
	if(new_state != overheated)
		set_broken(new_state)
	overheated = new_state

/obj/machinery/network/proc/update_network_status()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!D)
		return
	if(operable())
		SSnetworking.queue_connection(D) // must queue, due to router race conditions
	else
		D.disconnect()

/obj/machinery/network/proc/get_message_server()
	var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = network_device?.get_network()
	for(var/datum/extension/network_device/message_server in network?.devices)
		var/obj/machinery/network/message_server/MS = message_server.holder
		if(istype(MS) && !(MS.stat & (BROKEN|NOPOWER)))
			return MS