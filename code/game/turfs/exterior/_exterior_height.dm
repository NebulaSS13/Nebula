/turf/exterior
	var/height = 0

/turf/exterior/get_physical_height()
	return density ? 0 : height

/turf/exterior/set_height(new_height)
	if(height != new_height)
		height = new_height
		for(var/turf/neighbor as anything in RANGE_TURFS(src, 1))
			neighbor.update_icon()
		fluid_update()
		return TRUE
	return FALSE
