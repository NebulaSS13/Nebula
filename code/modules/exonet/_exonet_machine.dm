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
	var/ui_template				// If interacted with by a multitool, what UI (if any) to display.

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
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 640, 500)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/computer/exonet/proc/build_ui_data()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/datum/exonet/network = exonet.get_local_network()
	var/list/data = list()
	data["network"] = network
	data["name"] = name
	data["ennid"] = ennid
	data["keydata"] = keydata
	data["net_tag"] = net_tag

	. = data

/obj/machinery/computer/exonet/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/exonet/Destroy()
	..()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.disconnect_network()