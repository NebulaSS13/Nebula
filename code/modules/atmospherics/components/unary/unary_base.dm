/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH

	layer = ABOVE_TILE_LAYER

	var/datum/gas_mixture/air_contents
	pipe_class = PIPE_CLASS_UNARY

/obj/machinery/atmospherics/unary/get_single_monetary_worth()
	. = ..()
	for(var/gas in air_contents?.gas)
		var/decl/material/gas_data = GET_DECL(gas)
		. += gas_data.get_value() * air_contents.gas[gas] * GAS_WORTH_MULTIPLIER
	. = max(1, round(.))

/obj/machinery/atmospherics/unary/Initialize()
	air_contents = new
	air_contents.volume = 200
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