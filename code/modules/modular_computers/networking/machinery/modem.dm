/obj/machinery/network/modem
	name = "network modem"
	desc = "A modern modem used to allow communication between computer networks using the PLEXUS infrastructure."
	icon = 'icons/obj/machines/tcomms/hub.dmi'
	icon_state = "hub"
	network_device_type =  /datum/extension/network_device/modem
	main_template = "network_modem.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/modem

	// What you can do over PLEXUS alone is limited.
	var/static/list/feature_options = list(
		"Communication Systems" = NET_FEATURE_COMMUNICATION,
		"Access systems" = NET_FEATURE_ACCESS,
		"Security systems" = NET_FEATURE_SECURITY,
		"Filesystem access" = NET_FEATURE_FILESYSTEM
		)

/obj/machinery/network/modem/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	var/datum/extension/network_device/modem/M = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = M.get_network()
	if(!network || network.modem != M)
		error = "NETWORK ERROR: Connection lost. Another modem may be active on the network."
		return TOPIC_REFRESH

	if(href_list["toggle_feature"])
		var/feature = feature_options[href_list["toggle_feature"]]
		if(!feature)
			return TOPIC_HANDLED
		M.allowed_features ^= feature
		return TOPIC_REFRESH

/obj/machinery/network/modem/ui_data(mob/user, ui_key)
	. = ..()
	var/datum/extension/network_device/modem/M = get_extension(src, /datum/extension/network_device)
	if(!istype(M))
		return

	var/list/features = list()
	for(var/feature in feature_options)
		var/list/fdata[0]
		fdata["name"] = feature
		fdata["enabled"] = M.allowed_features & feature_options[feature]
		features.Add(list(fdata))
	
	.["features"] = features