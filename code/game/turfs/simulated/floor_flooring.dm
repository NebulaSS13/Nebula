/turf/simulated/floor/refresh_flooring(var/defer_icon_update = FALSE, var/assume_unchanged = FALSE)
	set_light(0)
	if(!assume_unchanged)
		layer = PLATING_LAYER
		set_turf_broken(null, skip_icon_update = TRUE)
		set_turf_burned(null, skip_icon_update = defer_icon_update)

	var/check_z_flags
	var/decl/flooring/flooring = get_flooring()
	if(flooring)
		check_z_flags = flooring.z_flags
	else if(assume_unchanged)
		check_z_flags = z_flags
	else
		check_z_flags = initial(z_flags)
	if(check_z_flags & ZM_MIMIC_BELOW)
		enable_zmimic(check_z_flags)
	else
		disable_zmimic()

	levelupdate()

	..()
