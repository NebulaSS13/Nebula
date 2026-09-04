// ERT camera monitor
/datum/computer_file/program/camera_monitor/ert
	filename = "ntcammon"
	filedesc = "Advanced Camera Monitoring"
	extended_desc = "This program allows remote access to a camera system. This version has an integrated database with additional encryption keys."
	size = 14
	nanomodule_path = /datum/nano_module/program/camera_monitor/ert
	available_on_network = FALSE

/datum/nano_module/program/camera_monitor/ert
	name = "ERT Camera Monitoring program"

/datum/nano_module/program/camera_monitor/ert/get_forbidden_channels()
	var/static/list/forbidden_channels = list(
		(CAMERA_CHANNEL_MERCENARY)
	)
	return forbidden_channels

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