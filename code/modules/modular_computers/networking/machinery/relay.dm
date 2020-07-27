/obj/machinery/network/relay
	name = "network relay"
	icon = 'icons/obj/machines/tcomms/relay.dmi'
	icon_state = "relay"
	network_device_type =  /datum/extension/network_device/broadcaster/relay
	main_template = "network_router.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/relay
	produces_heat = FALSE // for convenience
