/obj/machinery/computer/exonet/uplink
	name = "\improper EXONET Uplink"
	desc = "A very complex modem/firewall capable of transmitting information to PLEXUS, the space internet. Looks fragile."
	active_power_usage = 7.5 KILOWATTS
	ui_template = "exonet_uplink.tmpl"

/obj/machinery/computer/exonet/uplink/mapped
	base_type = /obj/machinery/computer/exonet/uplink
	var/ennid
	var/key

/obj/machinery/computer/exonet/uplink/mapped/LateInitialize()
	. = ..()
	if(ennid)
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		exonet.set_ennid(ennid)
		exonet.set_key(key)
		exonet.connect_network()