/obj/item/stock_parts/computer/network_card/
	name = "basic EXONET network card"
	desc = "A basic network card for usage with standard EXONET frequencies."
	power_usage = 50
	origin_tech = "{'" + TECH_DATA + "':2,'" + TECH_ENGINEERING + "':1}"
	critical = 0
	icon_state = "netcard_basic"
	hardware_size = 1
	matter = list(MAT_STEEL = 250, MAT_GLASS = 100)
	var/long_range = 0
	var/ethernet = 0 // Hard-wired, therefore always on, ignores NTNet wireless checks.
	var/proxy_id     // If set, uses the value to funnel connections through another network card.

/obj/item/stock_parts/computer/network_card/diagnostics()
	. = ..()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	. += "NIX Unique ID: [exonet.nid]"
	. += "NIX User Tag: [exonet.net_tag]"
	. += "EXONET ennid: [exonet.ennid]"
	. += "Supported protocols:"
	. += "511.m SFS (Subspace) - Standard Frequency Spread"
	if(long_range)
		. += "511.n WFS/HB (Subspace) - Wide Frequency Spread/High Bandiwdth"
	if(ethernet)
		. += "OpenEth (Physical Connection) - Physical network connection port"

/obj/item/stock_parts/computer/network_card/Initialize()
	. = ..()
	set_extension(src, /datum/extension/exonet_device, get_netspeed())

/obj/item/stock_parts/computer/network_card/advanced
	name = "advanced EXONET network card"
	desc = "An advanced network card for usage with standard EXONET frequencies. It's transmitter is strong enough to connect even when far away."
	long_range = 1
	origin_tech = "{'" + TECH_DATA + "':4,'" + TECH_ENGINEERING + "':2}"
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 1
	matter = list(MAT_STEEL = 500, MAT_GLASS = 200)

/obj/item/stock_parts/computer/network_card/wired
	name = "wired EXONET network card"
	desc = "An advanced network card for usage with standard EXONET frequencies. This one also supports wired connection."
	ethernet = 1
	origin_tech = "{'" + TECH_DATA + "':5,'" + TECH_ENGINEERING + "':3}"
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	hardware_size = 3
	matter = list(MAT_STEEL = 2500, MAT_GLASS = 400)

/obj/item/stock_parts/computer/network_card/proc/is_banned()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/datum/exonet/network = exonet.get_local_network()
	if(!network)
		return
	return network.check_banned(exonet.nid)

/obj/item/stock_parts/computer/network_card/proc/get_netspeed()
	var/strength = 1
	if(ethernet)
		strength = 3
	else if(long_range)
		strength = 2
	return strength

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/stock_parts/computer/network_card/proc/get_signal(var/specific_action = 0)
	. = 0
	if(!enabled || !check_functionality())
		return

	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/datum/exonet/network = exonet.get_local_network()
	if(!network || is_banned())
		return

	if(!network.check_function(specific_action)) // EXONET is down and we are not connected via wired connection. No signal.
		if(!ethernet || specific_action) // Wired connection ensures a basic connection to EXONET, however no usage of disabled network services.
			return

	var/turf/T = get_turf(src)
	if(!istype(T)) //no reception in nullspace
		return

	var/strength = network.get_signal_strength(src, get_netspeed())
	if(strength <= 0)
		return 0
	else if(strength <= 6)
		return 1
	else
		return 2

/obj/item/stock_parts/computer/network_card/on_disable()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.disconnect_network()

/obj/item/stock_parts/computer/network_card/on_enable(var/datum/extension/interactive/ntos/os)
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	exonet.connect_network()

/obj/item/stock_parts/computer/network_card/on_install(var/obj/machinery/machine)
	..()
	var/datum/extension/interactive/ntos/os = get_extension(machine, /datum/extension/interactive/ntos)
	if(os)
		on_enable(os)

/obj/item/stock_parts/computer/network_card/on_uninstall(var/obj/machinery/machine, var/temporary = FALSE)
	..()
	on_disable()