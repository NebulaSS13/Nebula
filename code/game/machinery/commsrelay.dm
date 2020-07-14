/obj/machinery/commsrelay
	name = "emergency communication relay"
	desc = "This machine creates a microscopic wormhole between here and a suitable target, allowing for FTL communication."
	icon = 'icons/obj/machines/tcomms/bs_relay.dmi'
	icon_state = "bspacerelay"
	anchored = 1
	density = 1
	idle_power_usage = 15000
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

/obj/machinery/commsrelay/on_update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[initial(icon_state)]_off"
	else
		icon_state = initial(icon_state)