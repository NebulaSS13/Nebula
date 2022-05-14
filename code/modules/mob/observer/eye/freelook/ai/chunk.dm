// CAMERA CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/chunk/camera/acquire_visible_turfs(var/list/visible)
	for(var/source in sources)
		var/datum/extension/network_device/camera/camera_device  = get_extension(source, /datum/extension/network_device)
		if(istype(camera_device))
			if(!camera_device.is_functional())
				continue
			for(var/turf/t in camera_device.can_see())
				visible[t] = t
		else if(isAI(source))
			var/mob/living/silicon/ai/AI = source
			if(AI.stat == DEAD)
				continue
			for(var/turf/t in seen_turfs_in_range(AI, world.view))
				visible[t] = t
		else
			log_visualnet("Contained an unhandled source", source)
			sources -= source
