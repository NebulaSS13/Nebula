/obj/machinery/network/relay
	name = "network relay"
	network_device_type =  /datum/extension/network_device/broadcaster/relay
	main_template = "network_router.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/relay

/obj/machinery/network/relay/Initialize()
	if(!initial_network_id)
		initial_network_id = "network[random_id(type, 100, 999)]"
	. = ..()

/obj/machinery/network/relay/ui_data(mob/user, ui_key)
	var/data = ..()
	var/datum/extension/network_device/broadcaster/relay/R = get_extension(src, /datum/extension/network_device)
	if(!istype(R))
		return data
	var/datum/computer_network/net = R.get_network()
	if(net)
		data["is_router"] = FALSE
	return data

/obj/machinery/network/relay/on_update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"