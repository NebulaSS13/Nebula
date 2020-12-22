/obj/machinery/network/mainframe
	name = "network mainframe"
	icon = 'icons/obj/machines/server.dmi'
	icon_state = "server"
	network_device_type =  /datum/extension/network_device/mainframe
	main_template = "network_mainframe.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/mainframe
	var/list/initial_roles = list(
		MF_ROLE_FILESERVER, 
		MF_ROLE_EMAIL_SERVER, 
		MF_ROLE_LOG_SERVER,
		MF_ROLE_CREW_RECORDS,
		MF_ROLE_SOFTWARE
		)

/obj/machinery/network/mainframe/Initialize()
	. = ..()
	var/datum/extension/network_device/mainframe/M = get_extension(src, /datum/extension/network_device)
	M.roles |= initial_roles

/obj/machinery/network/mainframe/ui_data(mob/user, ui_key)
	var/data = ..()
	var/datum/extension/network_device/mainframe/M = get_extension(src, /datum/extension/network_device)
	if(!istype(M))
		return data
	var/list/roles[0]
	for(var/role in GLOB.all_mainframe_roles)
		var/list/rdata[0]
		rdata["name"] = role
		rdata["enabled"] = !!(role in M.roles)
		roles.Add(list(rdata))
	data["roles"] = roles

	data["storage_exists"] = !!M.get_storage()
	data["capacity"] = M.get_capacity()
	data["used"] = M.get_used()
	return data
	
/obj/machinery/network/mainframe/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	if(href_list["toggle_role"])
		var/datum/extension/network_device/mainframe/M = get_extension(src, /datum/extension/network_device)
		M.toggle_role(href_list["toggle_role"])
		return TOPIC_REFRESH