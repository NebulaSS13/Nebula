/turf/unsimulated
	name = "command"
	initial_gas = list(
		/decl/material/gas/oxygen = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	abstract_type = /turf/unsimulated
	simulated = FALSE

// Shortcut a bunch of simulation stuff since this turf just needs to sit there.
/turf/unsimulated/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_FLAG_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/turf/unsimulated/get_lumcount(var/minlum = 0, var/maxlum = 1)
	return 0.8
