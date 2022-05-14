var/global/repository/cameras/camera_repository = new()

/proc/invalidateCameraCache()
	camera_repository.camera_cache_id = ++camera_repository.camera_cache_id

/repository/cameras
	var/list/devices_by_channel = list()
	var/camera_cache_id = 1

/repository/cameras/proc/devices_in_channel(var/channel)
	var/list/device_list = devices_by_channel[channel]
	if(device_list)
		return device_list.Copy()

/repository/cameras/proc/get_devices_by_channel()
	return devices_by_channel.Copy()

// TODO: Tie AI to a single computer network and replace.
/repository/cameras/proc/add_camera_to_channels(var/datum/extension/network_device/camera/added, var/list/channels)
	if(!islist(channels))
		channels = list(channels)
	for(var/channel in channels)
		if(!devices_by_channel[channel])
			ADD_SORTED(devices_by_channel, channel, /proc/cmp_text_asc)
			devices_by_channel[channel] = list()
		devices_by_channel[channel] |= added

/repository/cameras/proc/remove_camera_from_channels(var/datum/extension/network_device/camera/removed, var/list/channels)
	if(!islist(channels))
		channels = list(channels)
	for(var/channel in channels)
		if(!devices_by_channel[channel])
			continue
		devices_by_channel[channel] -= removed