/obj/machinery/network/acl
	name = "network access controller"
	network_device_type =  /datum/extension/network_device/acl
	main_template = "network_acl.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/acl
	runtimeload = TRUE

	// Datum file source for where grants/records are.
	var/datum/file_storage/network/file_source = /datum/file_storage/network/machine
	var/editing_user	// Numerical user ID of the user being editing on this device.
	var/list/initial_grants = list(
		access_security,
		access_brig,
		access_armory,
		access_forensics_lockers,
		access_medical,
		access_morgue,
		access_tox,
		access_tox_storage,
		access_engine,
		access_engine_equip,
		access_maint_tunnels,
		access_external_airlocks,
		access_emergency_storage,
		access_change_ids,
		access_ai_upload,
		access_teleporter,
		access_eva,
		access_bridge,
		access_captain,
		access_all_personal_lockers,
		access_chapel_office,
		access_tech_storage,
		access_atmospherics,
		access_bar,
		access_janitor,
		access_crematorium,
		access_kitchen,
		access_robotics,
		access_rd,
		access_cargo,
		access_construction,
		access_chemistry,
		access_cargo_bot,
		access_hydroponics,
		access_manufacturing,
		access_library,
		access_lawyer,
		access_virology,
		access_cmo,
		access_qm,
		access_network,
		access_surgery,
		access_research,
		access_mining,
		access_mining_office,
		access_mailsorting,
		access_heads_vault,
		access_mining_station,
		access_xenobiology,
		access_ce,
		access_hop,
		access_hos,
		access_RC_announce,
		access_keycard_auth,
		access_tcomsat,
		access_gateway,
		access_sec_doors,
		access_psychiatrist,
		access_xenoarch,
		access_medical_equip,
		access_heads
	)

/obj/machinery/network/acl/merchant
	initial_grants = list(
		access_crate_cash,
		access_merchant
	)

/obj/machinery/network/acl/antag
	initial_grants = list(
		access_syndicate
	)


/obj/machinery/network/acl/Initialize()
	. = ..()
	if(ispath(file_source))
		file_source = new file_source(null, src)

/obj/machinery/network/acl/RuntimeInitialize()
	// Get default file server.
	var/datum/extension/network_device/acl/FW = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = FW.get_network()
	if(network)
		var/datum/extension/network_device/file_server = network.get_file_server_by_role(MF_ROLE_CREW_RECORDS)
		if(file_server)
			file_source.server = file_server.network_tag
			// Populate initial grants.
			for(var/grant in initial_grants)
				create_grant(grant)

/obj/machinery/network/acl/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/card/id)) // ID Card, try to insert it.
		var/obj/item/card/id/I = W
		var/obj/item/stock_parts/computer/card_slot/card_slot = get_component_of_type(/obj/item/stock_parts/computer/card_slot)
		if(!card_slot)
			return
		card_slot.insert_id(I, user)
		return
	. = ..()

/obj/machinery/network/acl/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	var/datum/extension/network_device/acl/computer = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = computer.get_network()
	if(!network)
		error = "NETWORK ERROR: Connection lost."
		return TOPIC_REFRESH

	if(href_list["back"])
		editing_user = null
		return TOPIC_REFRESH

	if(href_list["change_file_server"])
		var/list/file_servers = network.get_file_server_tags(MF_ROLE_CREW_RECORDS)
		var/file_server = input(usr, "Choose a fileserver to view access records on:", "Select File Server") as null|anything in file_servers
		if(file_server)
			file_source.server = file_server
			return TOPIC_REFRESH

	if(href_list["assign_grant"])
		// Resolve our selection back to a file.
		var/datum/computer_file/data/grant_record/grant = computer.get_grant(href_list["assign_grant"])
		if(!grant)
			error = "ERROR: Grant record not found."
			return TOPIC_REFRESH
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		if(!AR)
			error = "ERROR: Access record not found."
			return TOPIC_REFRESH
		AR.add_grant(grant)

	if(href_list["remove_grant"])
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		if(!AR)
			error = "ERROR: Access record not found."
			return TOPIC_REFRESH
		AR.remove_grant(href_list["remove_grant"]) // Add the grant to the record.

	if(href_list["create_grant"])
		var/new_grant_name = uppertext(sanitize(input(usr, "Enter the name of the new grant:", "Create Grant")))
		if(!CanInteract(user, GLOB.default_state))
			return TOPIC_REFRESH
		if(!new_grant_name)
			return TOPIC_REFRESH
		if(!create_grant(new_grant_name))
			error = "MAINFRAME ERROR: Unable to store grant on mainframe."
			return TOPIC_REFRESH

	if(href_list["delete_grant"])
		if(!file_source.delete_file(href_list["delete_grant"]))
			error = "FIREWALL ERROR: Unable to delete grant."
			return TOPIC_REFRESH

	if(href_list["view_user"])
		editing_user = href_list["view_user"]

	if(href_list["write_id"])
		var/obj/item/stock_parts/computer/card_slot/card_slot = get_component_of_type(/obj/item/stock_parts/computer/card_slot)
		if(!card_slot)
			error = "HARDWARE ERROR: No NTOS-v2 compatible device found."
			return TOPIC_REFRESH
		var/obj/item/card/id/network/card = card_slot.stored_card
		if(!card)
			error = "HARDWARE ERROR: No valid card inserted."
			return TOPIC_REFRESH
		// Write to the card.
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		card.network_id = computer.network_id
		card.user_id = AR.user_id
		card.access_record = AR
		visible_message(SPAN_NOTICE("\The [src] clicks and hums, writing new data to \a [card]."))

	if(href_list["eject_id"])
		var/obj/item/stock_parts/computer/card_slot/card_slot = get_component_of_type(/obj/item/stock_parts/computer/card_slot)
		if(!card_slot)
			error = "HARDWARE ERROR: No NTOS-v2 compatible device found."
			return TOPIC_REFRESH
		if(!card_slot.stored_card)
			error = "HARDWARE ERROR: No valid card inserted."
			return TOPIC_REFRESH
		card_slot.eject_id(user)

	if(href_list["add_admin"])
		network.access_controller.add_admin(editing_user)

	if(href_list["remove_admin"])
		network.access_controller.rem_admin(editing_user)

/obj/machinery/network/acl/ui_data(mob/user, ui_key)
	. = ..()

	if(error)
		return

	var/obj/item/stock_parts/computer/card_slot/card_slot = get_component_of_type(/obj/item/stock_parts/computer/card_slot)
	if(card_slot)
		.["card_inserted"] = !!card_slot.stored_card

	var/datum/extension/network_device/acl/computer = get_extension(src, /datum/extension/network_device)
	if(!computer.get_network())
		.["connected"] = FALSE
		return
	.["connected"] = TRUE
	.["file_server"] = file_source.server
	.["editing_user"] = editing_user

	// Let's build some data.
	if(editing_user)
		var/datum/computer_network/network = computer.get_network()
		.["user_id"] = editing_user
		.["is_admin"] = (editing_user in network.access_controller.administrators)
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		if(!istype(AR))
			// Something has gone wrong. Our AR file is missing.
			error = "NETWORK ERROR: Unable to find access record for user [editing_user]."
			return
		var/list/grants[0]
		var/list/assigned_grants = AR.get_valid_grants()
		// We're editing a user, so we only need to build a subset of data.
		.["desired_name"]	= AR.get_name()
		.["grant_count"] 	= length(assigned_grants)
		.["size"] 			= AR.size
		for(var/datum/computer_file/data/grant_record/GR in computer.get_all_grants())
			grants.Add(list(list(
				"grant_name" = GR.stored_data,
				"assigned" = (GR in assigned_grants)
			)))
		.["grants"] = grants
	else
		// We're looking at all records. Or lack thereof.
		var/list/users[0]
		for(var/datum/computer_file/report/crew_record/AR in get_all_users())
			users.Add(list(list(
				"desired_name" = AR.get_name(),
				"user_id" = AR.user_id,
				"grant_count" = length(AR.get_valid_grants()),
				"size" = AR.size
			)))
		.["users"] = users

/obj/machinery/network/acl/on_update_icon()
	if(operable())
		icon_state = panel_open ? "AAS_On_Open" : "AAS_On"
	else
		icon_state = panel_open ? "AAS_Off_Open" : "AAS_Off"

/obj/machinery/network/acl/proc/get_all_users()
	var/list/users = list()
	for(var/datum/computer_file/report/crew_record/CR in file_source.get_all_files())
		users |= CR
	return users

// Get the access record for the user we're *currently* editing.
/obj/machinery/network/acl/proc/get_access_record(var/for_specific_id)
	var/for_user = for_specific_id
	if(!for_user)
		for_user = editing_user
	for(var/datum/computer_file/report/crew_record/AR in get_all_users())
		if(AR.user_id != for_user)
			continue
		return AR

/obj/machinery/network/acl/proc/create_grant(var/grant_data)
	if(!file_source.create_file(grant_data, /datum/computer_file/data/grant_record))
		return FALSE
	var/datum/computer_file/data/grant_record/grant = file_source.get_file(grant_data)
	grant.set_value(grant_data)
	grant.calculate_size()
	return TRUE