/turf/simulated/floor/before_save()
	. = ..()
	var/decl/saved_flooring = flooring
	if(istype(saved_flooring))
		initial_flooring = saved_flooring.type
		return
	initial_flooring = null