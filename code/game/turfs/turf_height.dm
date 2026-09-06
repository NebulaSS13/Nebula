/turf/proc/set_physical_height(var/new_height)
	return

// Open turfs should count as as low as possible for the purposes of fluid flows, etc.
/turf/proc/get_physical_height()
	return is_open() ? -(FLUID_DEEP) : 0
