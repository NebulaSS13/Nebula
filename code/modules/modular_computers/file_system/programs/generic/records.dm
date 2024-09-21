/datum/computer_file/program/records
	filename = "crewrecords"
	filedesc = "Crew Records"
	extended_desc = "This program allows access to the crew's various records."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 14
	available_on_network = 1
	requires_network = 1
	requires_network_feature = NET_FEATURE_RECORDS
	nanomodule_path = /datum/nano_module/program/records
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

/datum/nano_module/program/records
	name = "Crew Records"
	var/datum/computer_file/report/crew_record/active_record
	var/message = null

/datum/nano_module/program/records/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/list/user_access = get_record_access(user)

	data["message"] = message
	if(active_record)
		send_rsc(user, active_record.photo_front, "front_[active_record.uid].png")
		send_rsc(user, active_record.photo_side, "side_[active_record.uid].png")
		data["pic_edit"] = check_access(user, access_bridge) || check_access(user, access_security)
		data += active_record.generate_nano_data(user_access, user)
	else
		var/list/all_records = list()
		var/list/searchable_names = list()
		data["show_milrank"] = (global.using_map.flags & MAP_HAS_BRANCH)
		for(var/datum/computer_file/report/crew_record/R in get_records())
			all_records.Add(list(list(
				"name" = R.get_name(),
				"rank" = R.get_job(),
				"milrank" = R.get_rank(),
				"id" = R.uid
			)))
			searchable_names |= R.searchable_fields
		data["all_records"] = all_records
		data["searchable"] = searchable_names

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "crew_records.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/program/records/proc/get_record_access(var/mob/user)
	var/list/user_access = get_access(user)

	var/obj/PC = nano_host()
	var/datum/extension/interactive/os/os = get_extension(PC, /datum/extension/interactive/os)
	if(os && os.emagged())
		user_access = user_access ? user_access.Copy() : list()
		user_access |= access_hacked

	return user_access

/datum/nano_module/program/records/proc/edit_field(var/mob/user, var/field_ID)
	var/datum/computer_file/report/crew_record/R = active_record
	if(!R)
		return
	var/datum/report_field/F = R.field_from_ID(field_ID)
	if(!F)
		return
	if(!(F.get_perms(get_access(user),user) & OS_WRITE_ACCESS))
		to_chat(user, "<span class='notice'>\The [nano_host()] flashes an \"Access Denied\" warning.</span>")
		return
	F.ask_value(user)

/datum/nano_module/program/records/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["clear_active"])
		active_record = null
		return 1
	if(href_list["clear_message"])
		message = null
		return 1
	if(href_list["set_active"])
		var/ID = text2num(href_list["set_active"])
		for(var/datum/computer_file/report/crew_record/R in get_records())
			if(R.uid == ID)
				if(R.get_file_perms(get_access(usr), usr) & OS_READ_ACCESS)
					active_record = R
				else
					to_chat(usr, SPAN_WARNING("Access denied."))
				break
		return 1
	if(href_list["new_record"])
		var/datum/computer_network/network = get_network()
		if(!network)
			to_chat(usr, SPAN_WARNING("Network error."))
			return
		var/list/accesses = get_access(usr)
		if(!network.get_mainframes_by_role(MF_ROLE_CREW_RECORDS, accesses))
			to_chat(usr, SPAN_WARNING("You may not have access to generate new crew records, or there may not be a crew record mainframe active on the network."))
			return
		active_record = new/datum/computer_file/report/crew_record()
		if(network.store_file(active_record, OS_RECORDS_DIR, TRUE, accesses, usr, mainframe_role = MF_ROLE_CREW_RECORDS) != OS_FILE_SUCCESS)
			to_chat(usr, SPAN_WARNING("Unable to store new crew record. The file server may be non-functional or out of disk space."))
			qdel(active_record)
			active_record = null
			return
		global.all_crew_records.Add(active_record)
		return 1
	if(href_list["print_active"])
		if(!active_record)
			return
		print_text(record_to_html(active_record, get_record_access(usr)), usr)
		return 1
	if(href_list["search"])
		var/datum/computer_network/network = get_network()
		if(!network)
			to_chat(usr, SPAN_WARNING("Network error."))
			return
		var/field_name = href_list["search"]
		var/search = sanitize(input("Enter the value for search for.") as null|text)
		if(!search)
			return
		for(var/datum/computer_file/report/crew_record/R in get_records())
			if(!(R.get_file_perms(get_access(usr), usr) & OS_READ_ACCESS))
				continue
			var/datum/report_field/field = R.field_from_name(field_name)
			if(!field.searchable)
				continue
			if(!(field.get_perms(get_access(usr), usr) & OS_READ_ACCESS))
				continue
			if(findtext(lowertext(field.get_value()), lowertext(search)))
				active_record = R
				return 1
		message = "Unable to find record containing '[search]'. You may lack access to search for this."
		return 1

	var/datum/computer_file/report/crew_record/R = active_record
	if(!istype(R))
		return 1
	var/datum/computer_network/network = get_network()
	if(!network)
		to_chat(usr, SPAN_WARNING("Network error."))
		return
	if(href_list["edit_photo_front"])
		var/photo = get_photo(usr)
		if(photo && active_record)
			active_record.photo_front = photo
		return 1
	if(href_list["edit_photo_side"])
		var/photo = get_photo(usr)
		if(photo && active_record)
			active_record.photo_side = photo
		return 1
	if(href_list["edit_field"])
		edit_field(usr, text2num(href_list["edit_field"]))
		return 1

/datum/nano_module/program/records/proc/get_photo(var/mob/user)
	if(istype(user.get_active_held_item(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_held_item()
		return photo.img
	if(issilicon(user))
		var/mob/living/silicon/tempAI = usr
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img
