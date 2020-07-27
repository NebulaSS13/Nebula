/obj/machinery/network/router
	name = "network router"
	icon = 'icons/obj/machines/tcomms/comm_server.dmi'
	icon_state = "comm_server"
	network_device_type =  /datum/extension/network_device/broadcaster/router
	main_template = "network_router.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/router

/obj/machinery/network/router/Initialize()
	if(!initial_network_id)
		initial_network_id = "network[random_id(type, 100, 999)]"
	. = ..()

/obj/machinery/network/router/ui_data(mob/user, ui_key)
	var/data = ..()
	var/datum/extension/network_device/broadcaster/router/R = get_extension(src, /datum/extension/network_device)
	if(!istype(R))
		return data
	var/datum/computer_network/net = R.get_network()
	if(net)
		data["is_router"] = R.is_router()
	return data

/obj/machinery/network/router/update_network_status()
	..()
	var/datum/extension/network_device/broadcaster/router/R = get_extension(src, /datum/extension/network_device)
	if(R && operable())
		R.broadcast()