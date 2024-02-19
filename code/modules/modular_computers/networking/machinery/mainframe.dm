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
		MF_ROLE_LOG_SERVER,
		MF_ROLE_CREW_RECORDS,
		MF_ROLE_SOFTWARE,
		MF_ROLE_ACCOUNT_SERVER
		)

/obj/machinery/network/mainframe/Initialize()
	. = ..()

	var/datum/extension/network_device/mainframe/M = get_extension(src, /datum/extension/network_device)
	M.roles |= initial_roles
	M.update_roles()

	if(!(MF_ROLE_SOFTWARE in initial_roles))
		return

	var/obj/item/stock_parts/computer/hard_drive/drive = get_component_of_type(PART_HDD)
	for(var/F in subtypesof(/datum/computer_file/report))
		var/datum/computer_file/report/type = F
		if(TYPE_IS_ABSTRACT(type))
			continue
		if(initial(type.available_on_network))
			drive.store_file(new type, "reports", TRUE)

	for(var/F in subtypesof(/datum/computer_file/program))
		var/datum/computer_file/program/type = F
		if(TYPE_IS_ABSTRACT(type))
			continue
		if(initial(type.available_on_network))
			drive.store_file(new type, OS_PROGRAMS_DIR, TRUE)

/obj/machinery/network/mainframe/ui_data(mob/user, ui_key)
	var/data = ..()
	var/datum/extension/network_device/mainframe/M = get_extension(src, /datum/extension/network_device)
	if(!istype(M))
		return data
	var/list/roles[0]
	for(var/role in global.all_mainframe_roles)
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

//Network Presets

/obj/machinery/network/mainframe/empty
	initial_roles = list()

/obj/machinery/network/mainframe/files
	initial_roles = list(MF_ROLE_FILESERVER)

/obj/machinery/network/mainframe/account
	initial_roles = list(MF_ROLE_ACCOUNT_SERVER)

/obj/machinery/network/mainframe/logs
	initial_roles = list(MF_ROLE_LOG_SERVER)

/obj/machinery/network/mainframe/records
	initial_roles = list(MF_ROLE_CREW_RECORDS)

/obj/machinery/network/mainframe/software
	initial_roles = list(MF_ROLE_SOFTWARE)
