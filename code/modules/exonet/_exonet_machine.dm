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
	var/ui_template					// If interacted with by a multitool, what UI (if any) to display.
	var/current_ui_template 		// Do not set this. This is for the 'options' window of exonet systems. It'll be set automatically.
	var/error						// Error to display on the interface.
	var/rebuild_ui = FALSE

/obj/machinery/computer/exonet/Process()
	if(operable())
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)
	. = ..()

/obj/machinery/computer/exonet/on_update_icon()
	..()
	if(is_operable())
		overlays += image('icons/obj/computer.dmi', "ai-fixer-empty", overlay_layer)

/obj/machinery/computer/exonet/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!current_ui_template)
		current_ui_template = ui_template

	if(rebuild_ui)
		rebuild_ui = FALSE
		ui.close()
		ui = null

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
	data["ennid"] = exonet.ennid ? exonet.ennid : "Not Set"
	data["key"] = exonet.key ? (emagged ? exonet.key : "********") : "Not Set"
	data["net_tag"] = exonet.tag ? exonet.tag : "Not Set"
	data["power_usage"] = active_power_usage / 1000

	. = data

/obj/machinery/computer/exonet/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/exonet/OnTopic(var/mob/user, href_list)
	if(..())
		return TOPIC_HANDLED
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	. = TOPIC_REFRESH
	
	if(href_list["options"])
		clear_errors()
		current_ui_template = "exonet_options.tmpl"
		rebuild_ui = TRUE
		return TOPIC_HANDLED

	if(href_list["quit_options"])
		clear_errors()
		current_ui_template = ui_template
		rebuild_ui = TRUE
		return TOPIC_HANDLED

	if(href_list["refresh"])
		clear_errors()
		return TOPIC_REFRESH

	if(href_list["change_ennid"])
		var/list/result = exonet.do_change_ennid(user)
		if(!CanInteract(user, GLOB.default_state))
			to_world_log("can interact fail")
			return TOPIC_REFRESH
		// Guard statements.
		if(!result)
			to_world_log("null result")
			return TOPIC_REFRESH
		if("error" in result)
			to_world_log("error")
			error = result["error"]
			return TOPIC_REFRESH

		// Success.
		to_world_log("setting ennid to [result["ennid"]]")
		exonet.set_ennid(result["ennid"])
		to_world_log("setting key to [result["key"]]")
		exonet.set_key(result["key"])
		var/conn_result = exonet.connect_network(user)
		if(conn_result)
			to_world_log("failed to connect")
			error = conn_result
			return TOPIC_REFRESH
		to_world_log("connect success?")

	if(href_list["change_net_tag"])
		var/list/result = exonet.do_change_net_tag(user)
		if(!CanInteract(user, GLOB.default_state))
			return TOPIC_REFRESH
		// Guard statements.
		if(!result)
			return TOPIC_REFRESH
		if("error" in result)
			error = result["error"]
			return TOPIC_REFRESH
		exonet.set_net_tag(result["net_tag"])

	if(href_list["change_key"])
		var/list/result = exonet.do_change_key(user)
		if(!CanInteract(user, GLOB.default_state))
			return TOPIC_REFRESH
		// Guard statements.
		if(!result)
			return TOPIC_REFRESH
		if("error" in result)
			error = result["error"]
			return TOPIC_REFRESH

		exonet.set_key(result["key"])
		var/conn_result = exonet.connect_network(user)
		if(conn_result)
			error = conn_result


/obj/machinery/computer/exonet/proc/clear_errors()
	error = null