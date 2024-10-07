/turf/floor/proc/break_tile_to_plating()
	if(!is_plating())
		set_flooring(null)
	break_tile()

/turf/floor/proc/break_tile()
	if(!istype(flooring) || !(flooring.flooring_flags & TURF_CAN_BREAK) || is_floor_broken())
		return
	set_floor_broken(TRUE)
	remove_decals()

/turf/floor/proc/burn_tile(var/exposed_temperature)
	if(!istype(flooring) || !(flooring.flooring_flags & TURF_CAN_BURN) || is_floor_burned())
		return
	set_floor_burned(TRUE)
	remove_decals()
