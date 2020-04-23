/obj/machinery/network
	name = "base network machine"
	icon_state = "bus"

	var/main_template = "network_mainframe.tmpl"
	var/network_device_type =  /datum/extension/network_device
	var/error
	
	var/initial_network_id
	var/initial_network_key
	var/lateload

/obj/machinery/network/Initialize()
	. = ..()
	set_extension(src, network_device_type, initial_network_id, initial_network_key, NETWORK_CONNECTION_WIRED, !lateload)
	if(lateload)
		return INITIALIZE_HINT_LATELOAD

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