/obj/machinery/computer/exonet/access_directory
	name = "\improper EXONET Access Controller"
	desc = "A very complex machine that manages the security for an EXONET system. Looks fragile."
	active_power_usage = 4 KILOWATTS
	ui_template = "exonet_access_directory.tmpl"
	// These are program stateful variables.
	var/file_server							// What file_server we're viewing. This is a net_tag or other.
	var/editing_user						// If we're editing a user, it's assigned here.
	var/obj/item/card/id/stored_card	// The ID card currently stored.

/obj/machinery/computer/exonet/access_directory/proc/get_default_mainframe()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/list/mainframes = exonet.get_mainframes()
	if(length(mainframes) <= 0)
		return
	var/obj/machinery/computer/exonet/mainframe/MF = mainframes[1]
	return MF

// Gets all grants on the machine we're currently linked to.
/obj/machinery/computer/exonet/access_directory/proc/get_all_grants()
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
	if(!mainframe)
		return // No connection.
	var/list/grants = list()
	for(var/datum/computer_file/data/grant_record/GR in mainframe.stored_files)
		grants.Add(GR)
	return grants

// Get the access record for the user we're *currently* editing.
/obj/machinery/computer/exonet/access_directory/proc/get_access_record(var/for_specific_id)
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
	if(!mainframe)
		return
	var/for_user = for_specific_id
	if(!for_user)
		for_user = editing_user
	for(var/datum/computer_file/report/crew_record/AR in mainframe.stored_files)
		if(AR.user_id != for_user)
			continue
		return AR

/obj/machinery/computer/exonet/access_directory/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id))
		if(stored_card)
			to_chat(user, SPAN_WARNING("There appears to already be a card inserted into \the [src]."))
			return
		if(!user.unEquip(W, src))
			return
		visible_message(SPAN_NOTICE("\The [user] inserts \a [W] into \the [src]."))
		stored_card = W
		return
	return ..()

/obj/machinery/computer/exonet/access_directory/clear_errors()
	..()
	editing_user = null
	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	if(!file_server)
		var/obj/machinery/computer/exonet/mainframe/MF = get_default_mainframe()
		if(MF)
			file_server = exonet.get_network_tag(MF)

/obj/machinery/computer/exonet/access_directory/OnTopic(var/mob/user, href_list)
	if(..())
		return TOPIC_HANDLED
	. = TOPIC_HANDLED

	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)

	if(href_list["PRG_changefileserver"])
		var/old_value = file_server
		var/list/file_servers = list()
		for(var/obj/machinery/computer/exonet/mainframe/mainframe in exonet.get_mainframes())
			file_servers |= exonet.get_network_tag(mainframe)
		var/new_file_server = sanitize(input(usr, "Choose a fileserver to view access records on:", "Select File Server") as null|anything in file_servers)
		if(CanInteract(user, GLOB.default_state))
			file_server = new_file_server
			if(!file_server)
				file_server = old_value // Safety check.

	if(href_list["PRG_assigngrant"])
		var/list/all_grants = get_all_grants()
		// Resolve our selection back to a file.
		var/datum/computer_file/data/grant_record/grant
		for(var/datum/computer_file/data/grant_record/GR in all_grants)
			if(href_list["PRG_assigngrant"] == GR.stored_data)
				grant = GR
				break
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		if(!AR)
			error = "ERROR: Access record not found."
			return TOPIC_REFRESH
		AR.add_grant(grant) // Add the grant to the record.
	if(href_list["PRG_removegrant"])
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		if(!AR)
			error = "ERROR: Access record not found."
			return TOPIC_REFRESH
		AR.remove_grant(href_list["PRG_removegrant"]) // Add the grant to the record.
	if(href_list["PRG_creategrant"])
		var/new_grant_name = uppertext(sanitize(input(usr, "Enter the name of the new grant:", "Create Grant")))
		if(!CanInteract(user, GLOB.default_state))
			return TOPIC_REFRESH
		if(!new_grant_name)
			return TOPIC_REFRESH
		var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
		if(!mainframe)
			error = "NETWORK ERROR: Lost connection to mainframe. Unable to save new grant."
			return TOPIC_REFRESH
		var/datum/computer_file/data/grant_record/new_grant = new()
		new_grant.stored_data = new_grant_name
		new_grant.filename = new_grant_name
		new_grant.calculate_size()
		if(!mainframe.store_file(new_grant))
			error = "MAINFRAME ERROR: Unable to store grant on mainframe."
			return TOPIC_REFRESH
	if(href_list["PRG_deletegrant"])
		var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
		if(!mainframe)
			error = "NETWORK ERROR: Lost connection to mainframe."
			return TOPIC_REFRESH
		mainframe.delete_file_by_name(href_list["PRG_deletegrant"])
	if(href_list["PRG_adduser"])
		var/new_user_id = new_guid()
		var/new_user_name = sanitize(input(usr, "Enter user's desired name or leave blank to cancel:", "Add New User"))
		if(!CanInteract(user, GLOB.default_state))
			return TOPIC_REFRESH
		if(!new_user_name)
			return TOPIC_REFRESH
		// TODO: Add a check to see if this user actually exists if PLEXUS is online.
		// Add the record.
		var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
		if(!mainframe)
			error = "NETWORK ERROR: Lost connection to mainframe. Unable to save user access record."
			return TOPIC_REFRESH
		var/datum/computer_file/report/crew_record/new_record = new()
		new_record.filename = "[replacetext(new_user_name, " ", "_")]"
		new_record.user_id = new_user_id
		new_record.set_name(new_user_name)
		new_record.ennid = ennid
		new_record.calculate_size()
		if(!mainframe.store_file(new_record))
			error = "MAINFRAME ERROR: Unable to store record on mainframe."
			return TOPIC_REFRESH
		editing_user = new_user_id
	if(href_list["PRG_viewuser"])
		editing_user = href_list["PRG_viewuser"]
	if(href_list["PRG_deleteuser"])
		var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
		if(!mainframe)
			error = "NETWORK ERROR: Lost connection to mainframe."
			return TOPIC_REFRESH
		var/datum/computer_file/report/crew_record/AR = get_access_record(href_list["PRG_rename"])
		if(!AR)
			return TOPIC_REFRESH
		mainframe.delete_file_by_name(AR.filename)
	if(href_list["PRG_rename"])
		var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
		if(!mainframe)
			error = "NETWORK ERROR: Lost connection to mainframe."
			return TOPIC_REFRESH
		var/new_user_name = sanitize(input(usr, "Enter user's new desired name or leave blank to cancel:", "Rename User"))
		if(!CanInteract(user, GLOB.default_state))
			return TOPIC_REFRESH
		if(!new_user_name)
			return TOPIC_REFRESH
		var/datum/computer_file/report/crew_record/AR = get_access_record(href_list["PRG_rename"])
		if(!AR)
			return TOPIC_REFRESH
		AR.set_name(new_user_name)
	if(href_list["PRG_printid"])
		var/obj/item/card/id/exonet/card = stored_card
		if(!card)
			error = "HARDWARE ERROR: No valid card inserted."
			return TOPIC_REFRESH
		// Write to the card.
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		card.ennid = AR.ennid
		card.user_id = AR.user_id
		card.access_record = AR
		card.broken = FALSE
		visible_message(SPAN_NOTICE("\The [src] clicks and hums, writing new data to \a [card]."))
	if(href_list["PRG_ejectid"])
		if(!stored_card)
			error = "HARDWARE ERROR: No valid card inserted."
			return TOPIC_REFRESH
		visible_message(SPAN_NOTICE("\The [src] clunks noisily as it ejects \a [stored_card]."))
		stored_card.dropInto(loc)
		stored_card = null
	if(href_list["PRG_addadmin"])
		var/datum/exonet/network = exonet.get_local_network()
		if(!network)
			error = "NETWORK ERROR: Connection lost."
			return TOPIC_REFRESH
		network.administrators += editing_user
	if(href_list["PRG_removeadmin"])
		var/datum/exonet/network = exonet.get_local_network()
		if(!network)
			error = "NETWORK ERROR: Connection lost."
			return TOPIC_REFRESH
		network.administrators -= editing_user

/obj/machinery/computer/exonet/access_directory/build_ui_data()
	. = ..()

	if(error)
		return .

	if(current_ui_template != ui_template)
		return

	.["card_inserted"] = !!stored_card
	clear_errors() // This refreshes the file server if it's broken.

	var/datum/extension/exonet_device/exonet = get_extension(src, /datum/extension/exonet_device)
	if(!exonet.get_local_network())
		// Not connected to a network.
		error = "NETWORK ERROR: Not connected to a network."
		.["error"] = error
		return .

	if(!file_server)
		error = "NETWORK ERROR: No mainframes are available for storing security records."
		.["error"] = error
		return .

	.["file_server"] = file_server
	.["editing_user"] = editing_user

	// Let's build some data.
	var/obj/machinery/computer/exonet/mainframe/mainframe = exonet.get_device_by_tag(file_server)
	if(!mainframe || !mainframe.operable())
		file_server = null
		.["error"] = "NETWORK ERROR: Mainframe is offline."
		return .
	if(editing_user)
		var/datum/exonet/network = exonet.get_local_network()
		.["user_id"] = editing_user
		.["is_admin"] = (editing_user in network.administrators)
		var/datum/computer_file/report/crew_record/AR = get_access_record()
		var/list/grants[0]
		var/list/assigned_grants = AR.get_valid_grants()
		// We're editing a user, so we only need to build a subset of data.
		.["desired_name"]	= AR.get_name()
		.["grant_count"] 	= length(assigned_grants)
		.["size"] 			= AR.size
		for(var/datum/computer_file/data/grant_record/GR in get_all_grants())
			grants.Add(list(list(
				"grant_name" = GR.stored_data,
				"assigned" = (GR in assigned_grants)
			)))
		.["grants"] = grants
	else
		// We're looking at all records. Or lack thereof.
		var/list/users[0]
		for(var/datum/computer_file/report/crew_record/AR in mainframe.stored_files)
			users.Add(list(list(
				"desired_name" = AR.get_name(),
				"user_id" = AR.user_id,
				"grant_count" = length(AR.get_valid_grants()),
				"size" = AR.size
			)))
		.["users"] = users