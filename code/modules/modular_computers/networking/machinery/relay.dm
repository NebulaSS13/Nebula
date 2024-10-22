/obj/machinery/network/relay
	name = "network relay"
	icon = 'icons/obj/machines/tcomms/relay.dmi'
	icon_state = "relay"
	network_device_type =  /datum/extension/network_device/broadcaster/relay
	main_template = "network_router.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/relay
	produces_heat = FALSE // for convenience

/obj/machinery/network/relay/RefreshParts()
	. = ..()
	var/datum/extension/network_device/broadcaster/relay/R = get_extension(src, /datum/extension/network_device)
	R.cached_rating = null // regenerate cached value

/obj/machinery/network/relay/ui_data(mob/user, ui_key)
	var/data = ..()
	var/datum/extension/network_device/broadcaster/relay/R = get_extension(src, /datum/extension/network_device)
	if(!istype(R))
		return data
	data["wifi"] = R.allow_wifi
	return data

/obj/machinery/network/relay/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["toggle_wifi"])
		var/datum/extension/network_device/broadcaster/relay/R = get_extension(src, /datum/extension/network_device)
		if(R)
			R.allow_wifi = !R.allow_wifi
			return TOPIC_REFRESH
	. = ..()

// Long ranged network relay. Alternative to PLEXUS for maps which don't wish to use it. Otherwise difficult to obtain.
/obj/machinery/network/relay/long_range
	name = "long-ranged network relay"
	icon = 'icons/obj/machines/tcomms/relay.dmi'
	icon_state = "relay"
	network_device_type = /datum/extension/network_device/broadcaster/relay/long_range
	base_type = /obj/machinery/network/relay/long_range
