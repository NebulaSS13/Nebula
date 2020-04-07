/obj/machinery/computer/exonet/broadcaster
	ui_template = "exonet_router_configuration.tmpl"

	var/datum/exonet/network	// This is a hard reference back to the attached network. Primarily for serialization purposes on persistence.
	var/error					// Error to display on the interface.
	var/signal_strength	= 20				// The range in tiles that the broadcaster is capable of transmitting.
	var/broadcasting_ennid					// The exonet network id being broadcast.

/obj/machinery/computer/exonet/broadcaster/Initialize()
	. = ..()
	if(!broadcasting_ennid)
		broadcasting_ennid = ennid
	if(broadcasting_ennid)
		// Sets up the network before anything else can. go go go go
		var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
		exonet.broadcast_network(broadcasting_ennid, keydata)
		network = exonet.get_local_network()

/obj/machinery/computer/exonet/broadcaster/build_ui_data()
	. = ..()

	if(error)
		.["error"] = error
		return .

	.["signal_strength"] = signal_strength
	if(broadcasting_ennid)
		.["ennid"] = broadcasting_ennid
	else
		.["ennid"] = "Not Set"
	if(keydata)
		if(emagged)
			.["key"] = keydata
		else
			.["key"] = "******************"
	else
		.["key"] = "Not Set"
	if(broadcasting_ennid && operable())
		.["broadcasting_status"] = "Active"
	else
		.["broadcasting_status"] = "Down"
	.["power_usage"] = active_power_usage / 1000

/obj/machinery/computer/exonet/broadcaster/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["PRG_newennid"])
		// When a router's ennid changes, so does the network. Breaking *literally everything*.
		var/new_ennid = sanitize(input(usr, "Enter a new ennid or leave blank to cancel:", "Change ENNID"))
		if(!new_ennid)
			return TOPIC_HANDLED
		// Do a unique check...
		for(var/datum/exonet/E in GLOB.exonets)
			if(E.ennid == new_ennid)
				error = "Invalid ENNID. This ENNID is already registered."
				return TOPIC_HANDLED
		// time to break everything..
		update_ennid(new_ennid)
	if(href_list["PRG_back"])
		error = null

/obj/machinery/computer/exonet/broadcaster/proc/update_ennid(var/new_ennid)
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/result = exonet.connect_network(null, new_ennid, NETWORKSPEED_ETHERNET, keydata)
	broadcasting_ennid = new_ennid
	if(result)
		error = result
