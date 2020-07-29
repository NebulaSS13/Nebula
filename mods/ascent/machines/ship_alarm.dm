/decl/environment_data/mantid
	important_gasses = list(
		/decl/material/gas/oxygen =         TRUE,
		/decl/material/gas/methyl_bromide = TRUE,
		/decl/material/gas/carbon_dioxide = TRUE,
		/decl/material/gas/methane =        TRUE
	)
	dangerous_gasses = list(
		/decl/material/gas/carbon_dioxide = TRUE,
		/decl/material/gas/methane =        TRUE
	)

MANTIDIFY(/obj/machinery/alarm, "mantid thermostat", "atmospherics")

/obj/machinery/alarm/ascent
	req_access = list(access_ascent)
	construct_state = null
	environment_type = /decl/environment_data/mantid
	base_type = /obj/machinery/alarm/ascent

/obj/machinery/alarm/ascent/Initialize()
	. = ..()
	TLV[/decl/material/gas/methyl_bromide] = list(16, 19, 135, 140)
	TLV[/decl/material/gas/methane] = list(-1.0, -1.0, 5, 10)