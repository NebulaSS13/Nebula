/decl/environment_data/mantid
	important_gasses = list(
		MAT_OXYGEN =         TRUE,
		MAT_METHYL_BROMIDE = TRUE,
		MAT_CO2 = TRUE,
		MAT_METHANE =        TRUE
	)
	dangerous_gasses = list(
		MAT_CO2 = TRUE,
		MAT_METHANE =        TRUE
	)

MANTIDIFY(/obj/machinery/alarm, "mantid thermostat", "atmospherics")

/obj/machinery/alarm/ascent
	req_access = list(access_ascent)
	construct_state = null
	environment_type = /decl/environment_data/mantid

/obj/machinery/alarm/ascent/Initialize()
	. = ..()
	TLV[MAT_METHYL_BROMIDE] = list(16, 19, 135, 140)
	TLV[MAT_METHANE] = list(-1.0, -1.0, 5, 10)