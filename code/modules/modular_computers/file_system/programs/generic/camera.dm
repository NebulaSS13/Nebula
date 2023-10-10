/datum/computer_file/program/camera_monitor
	filename = "cammon"
	filedesc = "Camera Monitoring"
	nanomodule_path = /datum/nano_module/program/camera_monitor
	program_icon_state = "cameras"
	program_key_state = "generic_key"
	program_menu_icon = "search"
	extended_desc = "This program allows remote access to the camera system. Some cameras may have additional access requirements."
	size = 12
	available_on_network = 1
	requires_network = 1
	requires_network_feature = NET_FEATURE_SECURITY
	category = PROG_MONITOR

/datum/nano_module/program/camera_monitor
	name = "Camera Monitoring program"
	var/weakref/current_camera = null
	var/current_channel = null
	var/list/viewers = list()
	var/bypass_access = FALSE

/datum/nano_module/program/camera_monitor/Destroy()
	unlook_all()
	. = ..()

/datum/nano_module/program/camera_monitor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = global.default_topic_state)
	var/list/data = host.initial_data()

	var/datum/extension/network_device/camera/camera_device = current_camera?.resolve()
	data["current_camera"] = camera_device ? camera_device.nano_structure() : null
	data["current_channel"] = current_channel

	var/list/all_channels[0]
	var/list/cameras_by_channel = get_cameras_by_channel()
	for(var/channel in cameras_by_channel)
		all_channels += channel

	data["channels"] = all_channels

	if(current_channel)
		var/list/channel_cameras[0]
		for(var/datum/extension/network_device/camera/C in cameras_by_channel[current_channel])
			channel_cameras.Add(list(list(
								"name" = C.display_name,
								"device" = "\ref[C]",
								"deactivated" = !can_connect_to_camera(C)
								)))
		data["cameras"] = channel_cameras

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sec_camera.tmpl", "Camera Monitoring", 900, 800, src, state = state)
		// ui.auto_update_layout = 1 // Disabled as with suit sensors monitor - breaks the UI map. Re-enable once it's fixed somehow.

		ui.add_template("mapContent", "sec_camera_map_content.tmpl")
		ui.add_template("mapHeader", "sec_camera_map_header.tmpl")
		ui.set_initial_data(data)
		ui.open()

	user.machine = nano_host()

/datum/nano_module/program/camera_monitor/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["close"])
		unlook(usr)
		return TOPIC_NOACTION
	if(href_list["switch_camera"])
		var/datum/extension/network_device/camera/camera_device = locate(href_list["switch_camera"])
		if(!camera_device || !can_connect_to_camera(camera_device))
			return TOPIC_NOACTION
		var/atom/movable/holder = camera_device.holder
		// Only check for access when switching the camera - leave the program open at your own peril.
		if(!holder.allowed(usr) && !bypass_access)
			to_chat(usr, SPAN_WARNING("Access denied!"))
			return TOPIC_NOACTION
		switch_to_camera(usr, camera_device)
		return TOPIC_REFRESH

	if(href_list["view_camera"])
		if(usr in viewers)
			unlook(usr)
		else
			look(usr)
		return TOPIC_REFRESH

	else if(href_list["switch_channel"])
		if((href_list["switch_channel"]) in get_cameras_by_channel())
			current_channel = href_list["switch_channel"]
		return TOPIC_REFRESH

	else if(href_list["reset"])
		unlook_all()
		reset_current()
		return TOPIC_REFRESH

/datum/nano_module/program/camera_monitor/proc/look(var/mob/user)
	if(current_camera)
		var/datum/extension/network_device/camera/camera_device = current_camera.resolve()
		if(can_connect_to_camera(camera_device))
			user.reset_view(camera_device.holder)
			viewers |= user
			apply_visual(user)

/datum/nano_module/program/camera_monitor/proc/unlook(var/mob/user, var/reset_view = TRUE)
	if(user in viewers)
		if(reset_view)
			user.reset_view()
		viewers -= user
		remove_visual(user)

/datum/nano_module/program/camera_monitor/proc/unlook_all()
	for(var/mob/looker in viewers)
		looker.reset_view()
		viewers -= looker
		remove_visual(looker)

/datum/nano_module/program/camera_monitor/proc/can_connect_to_camera(var/datum/extension/network_device/camera/camera_device)
	if(!camera_device)
		return FALSE
	if(!camera_device.is_functional())
		return FALSE
	// Even if the camera itself does not need to be connected to the network, the program does in order to receive the signal.
	var/datum/computer_network/network = get_network()
	if(!network)
		return FALSE
	if(camera_device.requires_connection)
		if(camera_device.network_id != network.network_id)
			return FALSE
		if(!camera_device.check_connection())
			return FALSE
	return TRUE

/datum/nano_module/program/camera_monitor/proc/switch_to_camera(var/mob/user, var/datum/extension/network_device/camera/camera_device)
	//don't need to check if the camera works for AI because the AI jumps to the camera location and doesn't actually look through cameras.
	var/atom/C = camera_device.holder
	if(!C)
		return FALSE
	if(isAI(user) && camera_device.cameranet_enabled)
		var/mob/living/silicon/ai/A = user
		// Only allow non-carded AIs to view because the interaction with the eye gets all wonky otherwise.
		if(!A.is_in_chassis())
			return FALSE

		A.eyeobj.setLoc(get_turf(C))
		A.client.eye = A.eyeobj
		return TRUE

	set_current(camera_device)

	// Make sure everyone in the viewers list is looking at the same camera.
	for(var/mob/viewer in viewers)
		look(viewer)
	if(!(user in viewers))
		look(user)
	return TRUE

/datum/nano_module/program/camera_monitor/proc/set_current(var/datum/extension/network_device/camera/camera_device)
	if(current_camera)
		if(current_camera.resolve() == camera_device)
			return
		reset_current()

	current_camera = weakref(camera_device)
	var/mob/living/L = camera_device.holder
	if(istype(L))
		L.tracking_initiated()

/datum/nano_module/program/camera_monitor/proc/reset_current()
	if(current_camera)
		var/datum/extension/network_device/camera/camera_device = current_camera.resolve()
		var/mob/living/L = camera_device.holder
		if(istype(L))
			L.tracking_cancelled()
	current_camera = null

/datum/nano_module/program/camera_monitor/proc/get_cameras_by_channel()
	var/list/cameras_by_channel = list()
	var/datum/computer_network/network = get_network()
	if(network)
		cameras_by_channel = network.cameras_by_channel.Copy()
	// Cameras broadcasting on CAMERA_CHANNEL_TELEVISION are able to be received by all camera monitoring programs.
	var/list/television_channels = camera_repository.devices_in_channel(CAMERA_CHANNEL_TELEVISION)
	if(length(television_channels))
		if(!cameras_by_channel[CAMERA_CHANNEL_TELEVISION])
			cameras_by_channel[CAMERA_CHANNEL_TELEVISION] = list()
		cameras_by_channel[CAMERA_CHANNEL_TELEVISION] |= television_channels
	return cameras_by_channel

/datum/nano_module/program/camera_monitor/check_eye(var/mob/user)
	if(!current_camera)
		unlook(user, FALSE)
		return -1
	if(CanUseTopic(user, global.default_topic_state) != STATUS_INTERACTIVE)
		unlook(user, FALSE)
		return -1
	var/datum/extension/network_device/camera/camera_device = current_camera.resolve()
	if(!can_connect_to_camera(camera_device))
		unlook(user, FALSE)
		reset_current()
		return -1
	var/viewflag = camera_device.check_eye(user)
	if(viewflag < 0) // Camera isn't operational.
		unlook(user, FALSE)
		reset_current()
	return viewflag

// ERT Variant of the program
/datum/computer_file/program/camera_monitor/ert
	filename = "ntcammon"
	filedesc = "Advanced Camera Monitoring"
	extended_desc = "This program allows remote access to a camera system. This version has an integrated database with additional encrypted keys."
	size = 14
	nanomodule_path = /datum/nano_module/program/camera_monitor/ert
	available_on_network = 0

/datum/nano_module/program/camera_monitor/ert
	name = "Advanced Camera Monitoring Program"
	available_to_ai = FALSE

	bypass_access = TRUE

// ERT program ignores network connection requirement.
/datum/nano_module/program/camera_monitor/ert/can_connect_to_camera(datum/extension/network_device/camera/camera_device)
	if(!camera_device)
		return FALSE
	if(!camera_device.is_functional())
		return FALSE
	return TRUE

/datum/nano_module/program/camera_monitor/ert/get_cameras_by_channel()
	return camera_repository.get_devices_by_channel()

/datum/nano_module/program/camera_monitor/apply_visual(mob/M)
	if(current_camera)
		var/datum/camera_device = current_camera.resolve()
		camera_device.apply_visual(M)

/datum/nano_module/program/camera_monitor/remove_visual(mob/M)
	if(current_camera)
		var/datum/camera_device = current_camera.resolve()
		camera_device.remove_visual(M)
