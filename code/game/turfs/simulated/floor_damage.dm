/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/proc/break_tile()
	var/decl/flooring/flooring = get_flooring()
	if(!flooring || !(flooring.flags & TURF_CAN_BREAK) || !isnull(is_turf_broken()))
		return
	if(flooring.has_damage_range)
		set_turf_broken(num2text(rand(0,flooring.has_damage_range)), skip_icon_update = TRUE)
	else
		set_turf_broken("0", skip_icon_update = TRUE)
	LAZYCLEARLIST(decals)
	update_icon()

/turf/simulated/floor/proc/burn_tile(var/exposed_temperature)
	var/decl/flooring/flooring = get_flooring()
	if(!flooring || !(flooring.flags & TURF_CAN_BURN) || !isnull(is_turf_burned()))
		return
	if(flooring.has_burn_range)
		set_turf_burned(num2text(rand(0,flooring.has_burn_range)), skip_icon_update = TRUE)
	else
		set_turf_burned("0", skip_icon_update = TRUE)
	LAZYCLEARLIST(decals)
	update_icon()