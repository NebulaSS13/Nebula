#define MAX_CAMCHAN_TAG_LENGTH 20

/datum/extension/network_device/camera
	var/list/channels = list(CAMERA_CHANNEL_PUBLIC) // Camera channels for sorting cameras while looking via programs or as an AI. No longer connected to access.
	expected_type = /obj/machinery/camera

	var/cameranet_enabled		 // Whether this camera will act as a source for AI cameranets
	var/display_name			 // The display name for the camera. Unlike the network tag, uniqueness is not enforced, so this can/should be much shorter.
	var/requires_connection = TRUE // Whether the camera requires to be connected to its own network to be seen through. Used for television/thunderdome cameras.
	var/view_range = 7

	var/xray_enabled = FALSE
	has_commands = TRUE

/datum/extension/network_device/camera/New(datum/holder, n_id, n_key, c_type, autojoin, list/preset_channels, camera_name, camnet_enabled = TRUE, req_connection = TRUE)
	if(length(preset_channels))
		channels = preset_channels.Copy()
	. = ..()
	cameranet_enabled = camnet_enabled
	requires_connection = req_connection
	camera_repository.add_camera_to_channels(src, channels)
	display_name = camera_name

/datum/extension/network_device/camera/post_construction()
	if(cameranet_enabled)
		cameranet.add_source(holder)

/datum/extension/network_device/camera/Destroy()
	camera_repository.remove_camera_from_channels(src, channels)
	. = ..()

/datum/extension/network_device/camera/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		var/atom/A = holder
		ui = new(user, src, ui_key, "camera_settings.tmpl", capitalize(A.name), 500, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/extension/network_device/camera/ui_data(mob/user, ui_key)
	. = ..()
	.["channels"] = channels.Copy()

/datum/extension/network_device/camera/Topic(href, href_list)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!can_interact(user))
		return TOPIC_NOACTION
	if(href_list["add_channel"])
		var/cam_channel = sanitize(input(usr, "Enter the camera channel tag. Adding the channel \"[CAMERA_CHANNEL_TELEVISION]\" will enable broadband broadcast to all receivers in the local area:", "Enter camera channel tag") as text|null)
		if(length(cam_channel) && can_interact(user))
			if(length(cam_channel) > MAX_CAMCHAN_TAG_LENGTH)
				to_chat(user, SPAN_WARNING("Maximum camera channel tag length is 20 characters."))
				return TOPIC_NOACTION
			add_channels(cam_channel)
			return TOPIC_REFRESH
	if(href_list["remove_channel"])
		remove_channels(href_list["remove_channel"])
		return TOPIC_REFRESH

/datum/extension/network_device/camera/proc/is_functional()
	var/obj/machinery/camera/C = holder
	if(!istype(holder))
		CRASH("Camera device was created with invalid holder: [holder]!")
	return C.can_use()

/datum/extension/network_device/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(holder)
	if(!pos)
		return list()

	if(xray_enabled)
		see = range(view_range, pos)
	else
		see = hear(view_range, pos)
	return see

/datum/extension/network_device/camera/proc/show_paper(obj/item/paper/shown, mob/user)
	if(cameranet_enabled && is_functional() && isliving(user))
		var/mob/living/U = user
		var/itemname = shown.name
		var/info = shown.info
		to_chat(U, SPAN_NOTICE("You hold \a [itemname] up to the camera ..."))
		for(var/mob/living/silicon/ai/O in global.living_mob_list_)
			if(!O.client)
				continue
			if(U.name == "Unknown")
				to_chat(O, "<b>[U]</b> holds \a [itemname] up to one of your cameras ...")
			else
				to_chat(O, "<b><a href='byond://?src=\ref[O];track2=\ref[O];track=\ref[U];trackname=[U.name]'>[U]</a></b> holds \a [itemname] up to one of your cameras ...")
			show_browser(O, text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", itemname, info), text("window=[]", itemname))
		return TRUE

/datum/extension/network_device/camera/proc/add_channels(list/added_channels)
	if(!islist(added_channels))
		added_channels = list(added_channels)
	added_channels -= channels
	channels += added_channels
	var/datum/computer_network/net = get_network()
	if(net)
		net.add_camera_to_channels(src, added_channels)
	camera_repository.add_camera_to_channels(src, added_channels)

/datum/extension/network_device/camera/proc/remove_channels(list/removed_channels)
	if(!islist(removed_channels))
		removed_channels = list(removed_channels)
	removed_channels &= channels
	channels -= removed_channels
	var/datum/computer_network/net = get_network()
	if(net)
		net.remove_camera_from_channels(src, removed_channels)
	camera_repository.remove_camera_from_channels(src, removed_channels)

/datum/extension/network_device/camera/proc/set_view_range(var/new_range)
	if(view_range != new_range)
		view_range = new_range
		if(cameranet_enabled)
			cameranet.update_visibility(holder, 0)

/datum/extension/network_device/camera/proc/nano_structure()
	var/cam[0]
	cam["display_name"] = sanitize(display_name)
	cam["network_tag"] = network_tag
	cam["deact"] = !is_functional()
	cam["x"] = get_x(holder)
	cam["y"] = get_y(holder)
	cam["z"] = get_z(holder)
	return cam

/datum/extension/network_device/camera/apply_visual(mob/M)
	return holder.apply_visual(M)

/datum/extension/network_device/camera/remove_visual(mob/M)
	return holder.remove_visual(M)

/datum/extension/network_device/camera/proc/check_eye(mob/user)
	if(!is_functional())
		return -1
	if(xray_enabled)
		return SEE_TURFS|SEE_MOBS|SEE_OBJS
	return 0