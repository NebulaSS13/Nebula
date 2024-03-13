/turf/floor/proc/gets_drilled()
	return

/turf/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/floor/proc/break_tile()
	if(!flooring || !(flooring.flags & TURF_CAN_BREAK) || !isnull(broken))
		return
	if(flooring.has_damage_range)
		broken = text2num(rand(0,flooring.has_damage_range))
	else
		broken = "0"
	remove_decals()
	update_icon()

/turf/floor/proc/burn_tile(var/exposed_temperature)
	if(!flooring || !(flooring.flags & TURF_CAN_BURN) || !isnull(burnt))
		return
	if(flooring.has_burn_range)
		burnt = text2num(rand(0,flooring.has_burn_range))
	else
		burnt = "0"
	remove_decals()
	update_icon()