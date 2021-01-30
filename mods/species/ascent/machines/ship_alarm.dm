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
	environment_type = /decl/environment_data/mantid
	base_type = /obj/machinery/alarm/ascent

/obj/machinery/alarm/ascent/Initialize()
	. = ..()
	TLV[/decl/material/gas/methyl_bromide] = list(16, 19, 135, 140)
	TLV[/decl/material/gas/methane] = list(-1.0, -1.0, 5, 10)


/obj/item/frame/air_alarm/ascent
	name = "air alarm frame"
	desc = "Used for building air alarms."
	build_machine_type = /obj/machinery/alarm/ascent

/obj/item/frame/air_alarm/ascent/kit
	fully_construct = TRUE
	name = "air alarm kit"
	desc = "An all-in-one air alarm kit, comes preassembled."

/datum/fabricator_recipe/engineering/airalarm_kit/ascent
	path = /obj/item/frame/air_alarm/ascent/kit
	species_locked = list(
		/decl/species/mantid
	)

/obj/item/stock_parts/circuitboard/air_alarm/ascent
	name = "circuitboard (ascent air alarm)"
	build_path = /obj/machinery/alarm/ascent

/datum/fabricator_recipe/engineering/airalarm/ascent
	path = /obj/item/stock_parts/circuitboard/air_alarm/ascent
	species_locked = list(
		/decl/species/mantid
	)