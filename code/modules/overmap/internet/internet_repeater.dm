var/global/list/internet_repeaters = list()

/obj/machinery/internet_repeater
	name = "\improper PLEXUS repeater"
	desc = "A signal repeater that provides access to PLEXUS for all network devices in the local area, provided a PLEXUS uplink is in range."
	icon = 'icons/obj/machines/tcomms/bus.dmi'
	icon_state = "bus"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 50
	active_power_usage = 5000
	construct_state = /decl/machine_construction/default/panel_closed
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
	)

/obj/machinery/internet_repeater/Initialize()
	. = ..()
	internet_repeaters += src

/obj/machinery/internet_repeater/Destroy()
	internet_repeaters -= src
	. = ..()

/obj/machinery/internet_repeater/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(href_list["toggle"])
		if(use_power == POWER_USE_IDLE)
			update_use_power(POWER_USE_ACTIVE)
		else
			update_use_power(POWER_USE_IDLE)
		return TOPIC_REFRESH

/obj/machinery/internet_repeater/on_update_icon()
	icon_state = initial(icon_state)
	if(panel_open)
		icon_state = "[icon_state]_o"
	if(use_power != POWER_USE_ACTIVE || !operable())
		icon_state = "[icon_state]_off"

/obj/machinery/internet_repeater/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/internet_repeater/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	. = ..()
	var/data = list()
	data["powered"] = (use_power == POWER_USE_ACTIVE)

	var/obj/effect/overmap/visitable/sector = global.overmap_sectors[num2text(get_z(src))]

	if(sector)
		var/list/internet_connections = sector.get_internet_connections()
		var/list/connections = list()
		for(var/list/pos in internet_connections)
			var/list/connection_data = list()
			connection_data["position"] = "([pos[1]], [pos[2]])"
			connection_data["permitted"] = internet_connections[pos]
			connections.Add(list(connection_data))

		data["connections"] = connections

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "internet_repeater.tmpl", "PLEXUS Repeater", 420, 530, nref = src)
		ui.set_initial_data(data)
		ui.open()