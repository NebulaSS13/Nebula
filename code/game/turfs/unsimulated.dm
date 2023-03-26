/turf/unsimulated
	name = "command"
	initial_gas = list(
		/decl/material/gas/oxygen = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	abstract_type = /turf/unsimulated
	simulated = FALSE
	flooring_layers = null

/turf/unsimulated/get_lumcount(var/minlum = 0, var/maxlum = 1)
	return 0.8

/turf/unsimulated/on_defilement()
	return

/turf/unsimulated/get_flooring()
	SHOULD_CALL_PARENT(FALSE)

/turf/unsimulated/set_flooring_layers(var/decl/flooring/new_flooring, var/defer_icon_update, var/assume_unchanged = FALSE)
	SHOULD_CALL_PARENT(FALSE)

/turf/unsimulated/refresh_flooring(var/defer_icon_update = FALSE, var/assume_unchanged = FALSE)
	SHOULD_CALL_PARENT(FALSE)

/turf/unsimulated/on_update_icon(var/update_neighbors = FALSE)
	SHOULD_CALL_PARENT(FALSE)
