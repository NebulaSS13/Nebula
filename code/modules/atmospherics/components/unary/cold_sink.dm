//TODO: Put this under a common parent type with heaters to cut down on the copypasta
#define FREEZER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/temperature/freezer
	name = "gas cooling system"
	desc = "Cools gas when connected to a pipe network."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "freezer_0"
	base_icon_state = "freezer"
	base_type = /obj/machinery/atmospherics/unary/temperature/freezer
	ui_title = "Gas Cooling System"
	performance_multiplier = FREEZER_PERF_MULT
	var/heatsink_temperature = T20C	// The constant temperature reservoir into which the freezer pumps heat. Probably the hull of the station or something.

/obj/machinery/atmospherics/unary/temperature/freezer/get_temperature_class()
	. = "good"
	if(air_contents.temperature > (T0C - 20))
		. = "bad"
	else if(air_contents.temperature < (T0C - 20) && air_contents.temperature > (T0C - 100))
		. = "average"

/obj/machinery/atmospherics/unary/temperature/freezer/should_modify_gas()
	return air_contents.temperature > set_temperature

/obj/machinery/atmospherics/unary/temperature/freezer/modify_gas()
	var/heat_transfer = min(air_contents.get_thermal_energy_change(set_temperature - 5), 0)

	//Assume the heat is being pumped into the hull which is fixed at heatsink_temperature
	//not /really/ proper thermodynamics but whatever
	var/cop = performance_multiplier * air_contents.temperature/heatsink_temperature	//heatpump coefficient of performance from thermodynamics -> power used = heat_transfer/cop
	heat_transfer = min(heat_transfer, cop * power_rating)	//limit heat transfer by available power

	var/removed = -air_contents.add_thermal_energy(heat_transfer)		//remove the heat
	if(debug)
		visible_message("[src]: Removing [removed] W.")

//upgrading parts
/obj/machinery/atmospherics/unary/temperature/freezer/RefreshParts()
	..()
	var/manip_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 1, 10)
	var/bin_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)
	heatsink_temperature = initial(heatsink_temperature) / ((manip_rating + bin_rating) / 2)	//more efficient