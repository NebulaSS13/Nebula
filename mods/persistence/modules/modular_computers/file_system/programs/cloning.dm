/datum/computer_file/program/cloning
	filename = "organicbackup"
	filedesc = "Organic Backup System"
	extended_desc = "This system allows you to create a backup of yourself, in case of unfortunate death!"

	program_icon_state = "crew"
	program_key_state = "med_key"
	program_menu_icon = "heart"

	available_on_network = 1

	size = 12
	nanomodule_path = /datum/nano_module/program/cloning

	var/error
	var/datum/file_storage/network/current_filesource = /datum/file_storage/network

/datum/computer_file/program/cloning/on_startup(var/mob/living/user, var/datum/extension/interactive/ntos/new_host)
	. = ..()
	current_filesource = new(new_host)

/datum/computer_file/program/cloning/on_shutdown()
	. = ..()
	qdel(current_filesource)

/datum/nano_module/program/cloning
	name = "Organic Backup System"

/datum/nano_module/program/cloning/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/cloning/PRG = program
	if(PRG.error)
		data["error"] = PRG.error

	var/datum/computer_network/network = PRG.computer.get_network()
	if(!PRG.error && network)
		data["fileserver"] = PRG.current_filesource.server
		var/datum/extension/network_device/mainframe/MF = PRG.current_filesource.get_mainframe()
		if(MF)
			data["used_space"] = MF.get_used()
			data["total_space"] = MF.get_capacity()

		var/list/cloning_pods = list()
		for(var/datum/extension/network_device/cloning_pod/CP in network.devices)
			var/obj/machinery/machine = CP.holder
			var/list/cloning_pod = list(
				"id" = CP.network_tag,
				"online" = !(!machine.operable() || machine.stat & (BROKEN|NOPOWER)),
				"operation" = "Waiting.",
				"contents" = "Empty.",
				"total_progress" = 1
			)

			if(!cloning_pod["online"])
				cloning_pod["status"] = "Offline."
			else if(CP.occupied)
				cloning_pod["status"] = "Occupied."
				var/atom/movable/occupant = CP.get_occupant()
				if(istype(occupant, /obj/item/organ/internal/stack))
					var/obj/item/organ/internal/stack/stack = occupant
					if(!CP.cloning && stack.backup && stack.stackmob)
						cloning_pod["can_clone"] = TRUE
					else
						cloning_pod["operating"] = "Cloning."
						cloning_pod["progress"] = (world.time - CP.task_started_on) / (TASK_CLONE_TIME SECONDS)
						cloning_pod["remaining"] = round((TASK_CLONE_TIME SECONDS + CP.task_started_on - world.time) / 10)
					cloning_pod["contents"] = occupant.name
				else if(istype(occupant, /mob/living/carbon))
					var/mob/living/carbon/O = occupant
					cloning_pod["contents"] = "lifeform: [O.species.name]"
					if(O.mind && !CP.scanning)
						cloning_pod["can_backup"] = TRUE
						var/datum/computer_file/data/cloning/cloneFile = network.get_latest_clone_backup(O.mind.unique_id)
						if(cloneFile)
							cloning_pod["detailed"] = TRUE
							cloning_pod["last_backup"] = time2text(cloneFile.backup_date, "DDD, Month DD of YYYY")
							cloning_pod["backup_size"] = cloneFile.size
							cloning_pod["filename"] = cloneFile.filename
					else if(CP.scanning)
						cloning_pod["operation"] = "Scanning."
						cloning_pod["progress"] = (world.time - CP.task_started_on) / (TASK_SCAN_TIME SECONDS)
						cloning_pod["remaining"] = round((TASK_SCAN_TIME SECONDS + CP.task_started_on - world.time) / 10)
			else
				cloning_pod["status"] = "Online."
			cloning_pods += list(cloning_pod)
		data["cloning_pods"] = cloning_pods

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cloning_program.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()

/datum/computer_file/program/cloning/Topic(href, href_list)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	if(href_list["refresh"])
		error = null

	var/datum/computer_network/network = computer.get_network()
	if(!network)
		return

	if(href_list["change_file_server"])
		var/list/file_servers = network.get_file_server_tags(user, MF_ROLE_CLONING)
		var/file_server = input(usr, "Choose a fileserver to view files on:", "Select File Server") as null|anything in file_servers
		if(file_server)
			current_filesource.server = file_server

	if(href_list["backup"])
		error = current_filesource.check_errors()
		if(error)
			return
		var/datum/extension/network_device/cloning_pod/CP = network.get_device_by_tag(href_list["machine"])
		CP.begin_scan(user, current_filesource)

	if(href_list["clone"])
		var/datum/extension/network_device/cloning_pod/CP = network.get_device_by_tag(href_list["machine"])
		CP.begin_clone(user)

	if(href_list["eject"])
		var/datum/extension/network_device/cloning_pod/CP = network.get_device_by_tag(href_list["machine"])
		CP.eject_occupant()

	return TOPIC_REFRESH