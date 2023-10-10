/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH

	layer = ABOVE_TILE_LAYER

	var/datum/gas_mixture/air_contents
	pipe_class = PIPE_CLASS_UNARY

	// code sharing between scrubbers and vents
	var/controlled = TRUE	// if true, report to air alarm, if false, probably in direct contact with something else by radio (e.g. airlocks)

/obj/machinery/atmospherics/unary/get_single_monetary_worth()
	. = ..()
	for(var/gas in air_contents?.gas)
		var/decl/material/gas_data = GET_DECL(gas)
		. += gas_data.get_value() * air_contents.gas[gas] * GAS_WORTH_MULTIPLIER
	. = max(1, round(.))

/obj/machinery/atmospherics/unary/Initialize()
	air_contents = new
	air_contents.volume = 200
	if(controlled)
		reset_area(null, get_area(src))
	. = ..()

/obj/machinery/atmospherics/unary/Destroy()
	reset_area(get_area(src), null)
	. = ..()

/obj/machinery/atmospherics/unary/get_mass()
	return ..() + air_contents.get_mass()

/obj/machinery/atmospherics/unary/physically_destroyed()
	if(loc && air_contents)
		loc.assume_air(air_contents)
	. = ..()	

/obj/machinery/atmospherics/unary/dismantle()
	if(loc && air_contents)
		loc.assume_air(air_contents)
	. = ..()

/obj/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	for(var/node in nodes_to_networks)
		if(nodes_to_networks[node] == reference)
			return list(air_contents)

/obj/machinery/atmospherics/unary/area_changed(area/old_area, area/new_area)
	. = ..()
	if(. && controlled)
		reset_area(old_area, new_area)
		toggle_input_toggle() // this sends an update to nearby air alarms

/obj/machinery/atmospherics/unary/proc/reset_area(area/old_area, area/new_area)