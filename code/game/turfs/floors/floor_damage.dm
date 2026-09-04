/turf/floor/proc/break_tile_to_plating()
	if(has_flooring())
		clear_flooring()
	break_tile()

/turf/floor/proc/break_tile()
	var/decl/flooring/flooring = get_topmost_flooring()
	if(!istype(flooring) || !length(flooring.broken_states) || is_floor_broken())
		return
	set_floor_broken(TRUE)
	remove_decals()

/turf/floor/proc/burn_tile(var/exposed_temperature)
	var/decl/flooring/flooring = get_topmost_flooring()
	if(!istype(flooring) || !length(flooring.burned_states) || is_floor_burned())
		return
	set_floor_burned(TRUE)
	remove_decals()
