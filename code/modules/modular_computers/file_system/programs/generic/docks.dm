/datum/computer_file/program/docking
	filename = "docking"
	filedesc = "Docking Control"
	required_access = list(access_bridge)
	nanomodule_path = /datum/nano_module/program/docking
	program_icon_state = "supply"
	program_key_state = "rd_key"
	program_menu_icon = "triangle-2-e-w"
	extended_desc = "A management tool that lets you see the status of the docking ports and beacons."
	size = 10
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	available_on_network = 1
	requires_network = 1
	category = PROG_SUPPLY

/datum/computer_file/program/docking/on_startup()
	. = ..()
	if(NM)
		var/datum/nano_module/program/docking/NMD = NM
		NMD.refresh_docks()

/datum/nano_module/program/docking
	name = "Docking Control program"
	var/list/docking_controllers = list() //list of tags
	var/list/docking_beacons = list()	  //list of magnetic docking beacon tags

/datum/nano_module/program/docking/New(var/datum/host, var/topic_manager)
	..()
	refresh_docks()

/datum/nano_module/program/docking/proc/refresh_docks()
	docking_controllers.Cut()
	docking_beacons.Cut()
	var/list/zlevels = GetConnectedZlevels(get_host_z())
	for(var/obj/machinery/embedded_controller/radio/airlock/docking_port/D in SSmachines.machinery)
		if(D.z in zlevels)
			var/shuttleside = 0
			for(var/sname in SSshuttle.shuttles) //do not touch shuttle-side ones
				var/datum/shuttle/autodock/S = SSshuttle.shuttles[sname]
				if(istype(S) && S.shuttle_docking_controller)
					if(S.shuttle_docking_controller.id_tag == D.program.id_tag)
						shuttleside = 1
						break
			if(shuttleside)	
				continue
			docking_controllers += D.program.id_tag
		
	// Add magnetic docking beacons.
	var/datum/computer_network/network = get_network()
	if(network)
		docking_beacons |= network.get_tags_by_type(/obj/machinery/docking_beacon)
	
/datum/nano_module/program/docking/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/docks = list()
	var/list/beacons = list()
	var/datum/computer_network/network = get_network()

	for(var/docktag in docking_controllers)
		var/datum/computer/file/embedded_program/docking/P = SSshuttle.docking_registry[docktag]
		if(P)
			var/docking_attempt = P.tag_target && !P.dock_state
			var/docked = P.tag_target && (P.dock_state == STATE_DOCKED)
			docks.Add(list(list(
				"tag" = P.id_tag,
				"location" = P.get_name(),
				"status" = capitalize(P.get_docking_status()),
				"docking_attempt" = docking_attempt,
				"docked" = docked,
				"codes" = P.docking_codes ? P.docking_codes : "Unset"
				)))
	
	for(var/beacontag in docking_beacons)
		var/datum/extension/network_device/D = network.get_device_by_tag(beacontag)
		var/obj/machinery/docking_beacon/beacon = D.holder
		if(istype(beacon))
			beacons.Add(list(list(
				"size" = "[beacon.docking_width], [beacon.docking_height]",
				"name" = beacon.display_name,
				"locked" = beacon.locked,
				"network_tag" = D.network_tag,
				"code_docking" = beacon.docking_by_codes,
			)))
		else
			docking_beacons -= beacontag
	data["docks"] = docks
	data["docking_beacons"] = beacons
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "docking.tmpl", name, 600, 450, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/docking/Topic(href, href_list, state)
	if(..())
		return TOPIC_HANDLED
	
	if(istext(href_list["edit_docking_codes"]))
		var/datum/computer/file/embedded_program/docking/P = SSshuttle.docking_registry[href_list["edit_docking_codes"]]
		if(P)
			var/newcode = input("Input new docking codes", "Docking codes", P.docking_codes) as text|null
			if(!CanInteract(usr,state))
				return
			if(newcode)
				P.docking_codes = uppertext(newcode)
		return TOPIC_HANDLED

	if(istext(href_list["dock"]))
		var/datum/computer/file/embedded_program/docking/P = SSshuttle.docking_registry[href_list["dock"]]
		if(P)
			P.receive_user_command("dock")
		return TOPIC_HANDLED

	if(istext(href_list["undock"]))
		var/datum/computer/file/embedded_program/docking/P = SSshuttle.docking_registry[href_list["undock"]]
		if(P)
			P.receive_user_command("undock")
		return TOPIC_HANDLED
	
	if(istext(href_list["beacon"]))
		var/datum/computer_network/network = get_network()
		var/datum/extension/network_device/device = network.get_device_by_tag(href_list["beacon"])
		var/obj/machinery/docking_beacon/beacon = device.holder
		if(istype(beacon))
			var/datum/topic_state/remote/R = new(src, beacon)
			beacon.ui_interact(usr, state = R)
			return TOPIC_REFRESH