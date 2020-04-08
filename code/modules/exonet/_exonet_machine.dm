/obj/machinery/computer/exonet
	idle_power_usage = 100
	icon_state = "bus"
	anchored = 1
	density = 1
	construct_state = /decl/machine_construction/default/panel_closed
	stat_immune = 0
	use_power = POWER_USE_ACTIVE 		// Start turned on and active.
	icon_keyboard = "power_key"
	icon_screen = "ai-fixer"
	light_color = "#a97faa"
	maximum_component_parts = list(
		/obj/item/stock_parts = 8,
		/obj/item/stock_parts/exonet_lock/buildable = 1
	)
	// var/enabled = 1				// Set to 0 if the device was turned off
	var/ui_template					// If interacted with by a multitool, what UI (if any) to display.
	var/current_ui_template 		// Do not set this. This is for the 'options' window of exonet systems. It'll be set automatically.
	var/error						// Error to display on the interface.

/obj/machinery/computer/exonet/Process()
	if(operable())
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)
	..()

/obj/machinery/computer/exonet/on_update_icon()
	..()
	if(is_operable())
		overlays += image('icons/obj/computer.dmi', "ai-fixer-empty", overlay_layer)

/obj/machinery/computer/exonet/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!current_ui_template)
		current_ui_template = ui_template

	if(current_ui_template)
		var/list/data = build_ui_data()
		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, current_ui_template, name, 640, 500)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/computer/exonet/proc/build_ui_data()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/list/data = list()

	if(error)
		data["error"] = error
		return data

	data["name"] = name
	data["status"] = exonet.get_local_network() && operable() ? "Connected" : "Offline"
	data["ennid"] = ennid ? ennid : "Not Set"
	data["key"] = keydata ? (emagged ? keydata : "********") : "Not Set"
	data["net_tag"] = net_tag ? net_tag : "Not Set"
	data["power_usage"] = active_power_usage / 1000

	. = data

/obj/machinery/computer/exonet/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/exonet/Destroy()
	..()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.disconnect_network()

/obj/machinery/computer/exonet/OnTopic(var/mob/user, href_list)
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	. = TOPIC_REFRESH
	
	if(href_list["options"])
		current_ui_template = "exonet_options.tmpl"
		return TOPIC_REFRESH

	if(href_list["quit_options"])
		current_ui_template = ui_template
		return TOPIC_REFRESH

	if(href_list["refresh"])
		clear_errors()
		return TOPIC_REFRESH

	if(href_list["change_ennid"])
		var/list/result = exonet.do_change_ennid(user)
		// Guard statements.
		if(!result)
			return TOPIC_REFRESH
		if("error" in result)
			error = result["error"]
			return TOPIC_REFRESH

		// Success.
		exonet.disconnect_network()
		ennid = result["ennid"]
		keydata = result["key"]
		exonet.connect_network(user, ennid, NETWORKSPEED_ETHERNET, keydata)
		return TOPIC_REFRESH

	if(href_list["change_net_tag"])
		var/list/result = exonet.do_change_net_tag(user)
		// Guard statements.
		if(!result)
			return TOPIC_REFRESH
		if("error" in result)
			error = result["error"]
			return TOPIC_REFRESH

		net_tag = result["net_tag"]
		return TOPIC_REFRESH

	if(href_list["change_key"])
		var/list/result = exonet.do_change_key(user)
		// Guard statements.
		if(!result)
			return TOPIC_REFRESH
		if("error" in result)
			error = result["error"]
			return TOPIC_REFRESH

		exonet.disconnect_network()
		keydata = result["key"]
		exonet.connect_network(user, ennid, NETWORKSPEED_ETHERNET, keydata)
		return TOPIC_REFRESH


/obj/machinery/computer/exonet/proc/clear_errors()
	error = null