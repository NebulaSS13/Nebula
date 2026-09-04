#define BASE_INTERNET_RANGE 5

var/global/list/internet_uplinks = list()
/obj/machinery/internet_uplink
	name = "\improper PLEXUS uplink"
	desc = "A machine designed to route massive amounts of data to and from PLEXUS receivers in a local area using a miniaturized wormhole."
	icon = 'icons/obj/machines/internet_uplink.dmi'
	icon_state = "unpowered"
	density = TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)

	var/overmap_range = BASE_INTERNET_RANGE
	var/max_overmap_range = BASE_INTERNET_RANGE

	var/max_temperature = 100 CELSIUS
	var/power_per_range = 20000

	var/restrict_networks = FALSE		 // Whether or not a network needs to be permitted to use this uplink.
	var/list/permitted_networks = list() // Network IDs which are permitted to connect through this uplink.
	var/initial_id_tag = "plexus"

/obj/machinery/internet_uplink/Initialize()
	. = ..()
	global.internet_uplinks += src
	set_extension(src, /datum/extension/local_network_member, TRUE)
	if(initial_id_tag)
		var/datum/extension/local_network_member/uplink_comp = get_extension(src, /datum/extension/local_network_member)
		uplink_comp.set_tag(null, initial_id_tag)
	update_range(overmap_range)

/obj/machinery/internet_uplink/Destroy()
	global.internet_uplinks -= src
	. = ..()

/obj/machinery/internet_uplink/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_MULTITOOL(used_item))
		var/datum/extension/local_network_member/uplink_comp = get_extension(src, /datum/extension/local_network_member)
		uplink_comp.get_new_tag(user)
		return TRUE

	return ..()

/obj/machinery/internet_uplink/Process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(use_power != POWER_USE_ACTIVE)
		return

	// Larger ranges not only require more power, but greater cooling.
	var/inefficiency = clamp(0.3 + (0.1 * (overmap_range - BASE_INTERNET_RANGE)), 0.1, 0.6)

	var/datum/gas_mixture/env = return_air()
	if(!istype(env) || env.return_pressure() < 10) // Vacuum cooling is insufficient for this machine.
		take_damage(10, BURN)
		return
	env.add_thermal_energy(active_power_usage * inefficiency)
	if(env.temperature > max_temperature)
		take_damage(5, BURN)

/obj/machinery/internet_uplink/set_broken(new_state, cause)
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		visible_message(SPAN_WARNING("\The [src]'s wormhole collapses as its containment mechanisms fail!"))
		update_use_power(POWER_USE_IDLE)

/obj/machinery/internet_uplink/on_update_icon()
	if((use_power == POWER_USE_ACTIVE) && !(stat & NOPOWER))
		if(icon_state == "unpowered") // Switching states, flash an animation.
			flick("startup", src)

		icon_state = "powered"
	else
		icon_state = "unpowered"

/obj/machinery/internet_uplink/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return

	if(href_list["toggle_power"])
		var/new_power = (use_power == POWER_USE_ACTIVE ? POWER_USE_IDLE : POWER_USE_ACTIVE)
		update_use_power(new_power)
		return TOPIC_REFRESH

	if(href_list["modify_range"])
		var/new_range = input(user,"Enter the desired range in standard sectors (1 - [max_overmap_range]). Higher ranges increase power usage and heat production.", "Enter new range") as num|null
		if(!CanInteract(user, state))
			return TOPIC_HANDLED
		if(!new_range)
			return TOPIC_HANDLED
		update_range(new_range)
		return TOPIC_REFRESH

	if(href_list["restrict_networks"])
		restrict_networks = !restrict_networks
		return TOPIC_REFRESH

	if(href_list["toggle_permitted_network"])
		var/network_id = sanitize(input(user,"Enter the network ID you wish to permit/unpermit for this uplink:", "Enter Network ID") as text|null)
		if(!CanInteract(user, state))
			return TOPIC_HANDLED
		if(network_id)
			if(network_id in permitted_networks)
				permitted_networks -= network_id
				return TOPIC_REFRESH
			else if(network_id in SSnetworking.networks)
				permitted_networks += network_id
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("The network '[network_id]' could not be found!"))
				return TOPIC_HANDLED

/obj/machinery/internet_uplink/proc/update_range(new_range)
	overmap_range = clamp(1, new_range, max_overmap_range)
	change_power_consumption(power_per_range * overmap_range, POWER_USE_ACTIVE)

/obj/machinery/internet_uplink/power_change()
	. = ..()
	if(.)
		if(use_power == POWER_USE_ACTIVE)
			playsound(src, 'sound/mecha/powerup.ogg', 50)
		else
			playsound(src, 'sound/machines/apc_nopower.ogg', 50)

/obj/machinery/internet_uplink/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, datum/topic_state/state = global.default_topic_state)
	var/list/data = list()
	data["active"] = (use_power == POWER_USE_ACTIVE)
	data["power_draw"] = "[active_power_usage/1000] kW"
	var/datum/gas_mixture/env = return_air()
	data["temperature"] = (env?.get_total_moles() > 10) ? env.temperature : "NO HEATSINK FOUND"
	data["max_temperature"] = max_temperature
	data["overmap_range"] = overmap_range
	data["restrict_networks"] = restrict_networks
	if(restrict_networks)
		data["permitted"] = permitted_networks

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "internet_uplink.tmpl", "PLEXUS Uplink Settings", 540, 400, state = state)
		ui.set_initial_data(data)
		ui.set_auto_update(TRUE)
		ui.open()

/obj/machinery/internet_uplink/RefreshParts()
	max_overmap_range = BASE_INTERNET_RANGE + clamp(total_component_rating_of_type(/obj/item/stock_parts/smes_coil), 0, 10)
	update_range(overmap_range) // Check to ensure the set overmap range is still below the new maximum.
	. = ..()

#undef BASE_INTERNET_RANGE

/obj/machinery/computer/internet_uplink
	name = "PLEXUS uplink control computer"
	icon_keyboard = "power_key"
	icon_screen = "comm_logs"
	light_color = COLOR_GREEN
	idle_power_usage = 250
	active_power_usage = 500
	var/initial_id_tag = "plexus"

/obj/machinery/computer/internet_uplink/Initialize()
	. = ..()
	set_extension(src, /datum/extension/local_network_member, TRUE)
	if(initial_id_tag)
		var/datum/extension/local_network_member/uplink_comp = get_extension(src, /datum/extension/local_network_member)
		uplink_comp.set_tag(null, initial_id_tag)

/obj/machinery/computer/internet_uplink/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_MULTITOOL(used_item))
		var/datum/extension/local_network_member/uplink_comp = get_extension(src, /datum/extension/local_network_member)
		uplink_comp.get_new_tag(user)
		return TRUE

	return ..()

/obj/machinery/computer/internet_uplink/interface_interact(mob/user)
	var/datum/extension/local_network_member/uplink_comp = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = uplink_comp.get_local_network()

	// Internet uplinks are restricted to one per network, so this should return the only uplink linked.
	var/obj/machinery/internet_uplink/linked = lan.get_devices(/obj/machinery/internet_uplink)?[1]

	if(!istype(linked))
		to_chat(user, SPAN_WARNING("\The [src] flashes an error: No PLEXUS uplink connected!"))
		return FALSE

	var/datum/topic_state/remote/R = new(src, linked)
	linked.ui_interact(user, state = R)
	return TRUE