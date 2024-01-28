/turf/unsimulated
	name = "command"
	initial_gas = list(
		/decl/material/gas/oxygen = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	abstract_type = /turf/unsimulated
	simulated = FALSE

/turf/unsimulated/get_lumcount(var/minlum = 0, var/maxlum = 1)
	return 0.8

/turf/unsimulated/on_defilement()
	return
