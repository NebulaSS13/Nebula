/obj/machinery/computer/exonet/broadcaster
	ui_template = "exonet_router_configuration.tmpl"

	var/datum/exonet/network				// This is a hard reference back to the attached network. Primarily for serialization purposes on persistence.
	var/signal_strength	= 20				// The range in tiles that the broadcaster is capable of transmitting.
	var/broadcasting_ennid					// The exonet network id being broadcast. This is a mapping var.
	var/broadcasting_key					// The exonet network key for the network being broadcast. This is a mapping var.
	var/delay_broadcasting = FALSE			// Whether or not to delay broadcasting to late init. This is a mapping var.

/obj/machinery/computer/exonet/broadcaster/Initialize()
	. = ..()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	if(broadcasting_ennid)
		exonet.set_ennid(broadcasting_ennid)
		exonet.set_key(broadcasting_key)
	if(broadcasting_ennid && !delay_broadcasting)
		exonet.broadcast_network()
		network = exonet.get_local_network()

/obj/machinery/computer/exonet/broadcaster/LateInitialize()
	. = ..()
	if(broadcasting_ennid && delay_broadcasting)
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		exonet.broadcast_network()
		network = exonet.get_local_network()

/obj/machinery/computer/exonet/broadcaster/build_ui_data()
	. = ..()

	if(error)
		.["error"] = error
		return .

	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	.["signal_strength"] = signal_strength
	if(exonet.get_local_network() && operable())
		.["broadcasting_status"] = "Active"
	else
		.["broadcasting_status"] = "Down"
	.["power_usage"] = active_power_usage / 1000

/obj/machinery/computer/exonet/broadcaster/OnTopic(var/mob/user, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["PRG_newennid"])
		// When a router's ennid changes, so does the network. Breaking *literally everything*.
		var/new_ennid = sanitize(input(usr, "Enter a new ennid or leave blank to cancel:", "Change ENNID"))
		if(!new_ennid)
			return TOPIC_REFRESH
		// Do a unique check...
		for(var/datum/exonet/E in GLOB.exonets)
			if(E.ennid == new_ennid)
				error = "Invalid ENNID. This ENNID is already registered."
				return TOPIC_REFRESH
		// time to break everything..
		update_ennid(new_ennid)
	if(href_list["PRG_back"])
		error = null

/obj/machinery/computer/exonet/broadcaster/proc/update_ennid(var/new_ennid)
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/result = exonet.connect_network(null, new_ennid, NETWORKSPEED_ETHERNET, broadcasting_key)
	broadcasting_ennid = new_ennid
	if(result)
		error = result
