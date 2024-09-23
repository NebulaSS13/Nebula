/turf/floor/proc/break_tile_to_plating()
	if(has_flooring())
		set_flooring(null)
	break_tile()

/turf/floor/proc/break_tile()
	var/decl/flooring/flooring = get_topmost_flooring()
	if(!istype(flooring) || !(flooring.flooring_flags & TURF_CAN_BREAK) || is_floor_broken())
		return
	set_floor_broken(TRUE)
	remove_decals()

/turf/floor/proc/burn_tile(var/exposed_temperature)
	var/decl/flooring/flooring = get_topmost_flooring()
	if(!istype(flooring) || !(flooring.flooring_flags & TURF_CAN_BURN) || is_floor_burned())
		return
	set_floor_burned(TRUE)
	remove_decals()
