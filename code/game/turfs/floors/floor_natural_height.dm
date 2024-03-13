/turf/floor/natural
	var/height = 0

/turf/floor/natural/get_physical_height()
	return density ? 0 : height

/turf/floor/natural/set_physical_height(new_height)
	if(height != new_height)
		height = new_height
		for(var/turf/neighbor as anything in RANGE_TURFS(src, 1))
			neighbor.update_icon()
		fluid_update()
		var/atom/movable/fluid_overlay/fluids = locate() in src
		if(fluids)
			fluids.update_icon()
		return TRUE
	return FALSE
