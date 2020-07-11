/obj/item/stock_parts/computer/network_card
	name = "basic network card"
	desc = "A basic network card for usage with standard network protocols."
	power_usage = 50
	origin_tech = "{'programming':2,'engineering':1}"
	critical = 0
	icon_state = "netcard_basic"
	hardware_size = 1
	material = /decl/material/solid/glass

	var/long_range = 0
	var/ethernet = 0 // Hard-wired, therefore always on, ignores wireless checks.
	var/proxy_id     // If set, uses the value to funnel connections through another network card.

/obj/item/stock_parts/computer/network_card/diagnostics()
	. = ..()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	. += "NIX Unique ID: [D.address]"
	. += "NIX User Tag: [D.network_tag]"
	. += "Network ID: [D.network_id]"
	. += "Supported protocols:"
	. += "511.m SFS (Subspace) - Standard Frequency Spread"
	if(long_range)
		. += "511.n WFS/HB (Subspace) - Wide Frequency Spread/High Bandiwdth"
	if(ethernet)
		. += "OpenEth (Physical Connection) - Physical network connection port"

/obj/item/stock_parts/computer/network_card/Initialize()
	set_extension(src, /datum/extension/network_device)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(long_range)
		D.connection_type = NETWORK_CONNECTION_STRONG_WIRELESS
	if(ethernet)
		D.connection_type = NETWORK_CONNECTION_WIRED
	. = ..()

/obj/item/stock_parts/computer/network_card/advanced
	name = "advanced network card"
	desc = "An advanced network card for usage with standard network protocols. It's transmitter is strong enough to connect even when far away."
	long_range = 1
	origin_tech = "{'programming':4,'engineering':2}"
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 1
	material = /decl/material/solid/glass

/obj/item/stock_parts/computer/network_card/wired
	name = "wired network card"
	desc = "An advanced network card for usage with standard network protocols. This one also supports wired connection."
	ethernet = 1
	origin_tech = "{'programming':5,'engineering':3}"
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	hardware_size = 3
	material = /decl/material/solid/glass


// Returns a string identifier of this network card
/obj/item/stock_parts/computer/network_card/proc/get_network_tag()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	return D.network_tag

/obj/item/stock_parts/computer/network_card/proc/get_nid()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	return D.address

/obj/item/stock_parts/computer/network_card/proc/is_banned()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	return D.is_banned()

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/stock_parts/computer/network_card/proc/get_signal(var/specific_action = 0)
	. = 0
	if(!enabled)
		return

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	return D.check_connection(specific_action)

/obj/item/stock_parts/computer/network_card/on_disable()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(D)
		D.disconnect()

/obj/item/stock_parts/computer/network_card/on_enable(var/datum/extension/interactive/ntos/os)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(D)
		D.connect()

/obj/item/stock_parts/computer/network_card/on_install(var/obj/machinery/machine)
	..()
	var/datum/extension/interactive/ntos/os = get_extension(machine, /datum/extension/interactive/ntos)
	if(os)
		on_enable(os)

/obj/item/stock_parts/computer/network_card/on_uninstall(var/obj/machinery/machine, var/temporary = FALSE)
	..()
	on_disable()

/obj/item/stock_parts/computer/network_card/nano_host()
	return loc ? loc.nano_host() : ..()