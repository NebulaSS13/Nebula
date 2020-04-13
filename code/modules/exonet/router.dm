/obj/machinery/computer/exonet/broadcaster/router
	name = "\improper EXONET Router"
	desc = "A very complex router and transmitter capable of connecting electronic devices together. Looks fragile."
	active_power_usage = 8 KILOWATTS
	ui_template = "exonet_router_configuration.tmpl"
	var/dos_failure = 0			// Set to 1 if the router failed due to (D)DoS attack
	var/list/dos_sources = list()	// Backwards reference for qdel() stuff

	// Denial of Service attack variables
	var/dos_overload = 0		// Amount of DoS "packets" in this relay's buffer
	var/dos_capacity = 500		// Amount of DoS "packets" in buffer required to crash the relay
	var/dos_dissipate = 1		// Amount of DoS "packets" dissipated over time.

	// some machine-specific configuration
	var/allow_file_download 	= TRUE
	var/allow_peer_to_peer 		= TRUE
	var/allow_communication 	= TRUE
	var/allow_remote_control 	= TRUE

/obj/machinery/computer/exonet/broadcaster/router/update_ennid(var/new_ennid)
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	network = exonet.get_local_network()
	if(network)
		network.change_ennid(new_ennid)
	exonet.ennid = new_ennid
	exonet.broadcast_network()