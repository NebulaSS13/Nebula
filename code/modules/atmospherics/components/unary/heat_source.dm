//TODO: Put this under a common parent type with freezers to cut down on the copypasta
#define HEATER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/temperature/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe network."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "heater_0"
	base_icon_state = "heater"
	base_type = /obj/machinery/atmospherics/unary/temperature/heater
	performance_multiplier = HEATER_PERF_MULT

/obj/machinery/atmospherics/unary/temperature/heater/should_modify_gas()
	return air_contents.temperature < set_temperature

/obj/machinery/atmospherics/unary/temperature/heater/modify_gas()
	// amount of heat needed to heat air_contents to set_temperature + 5
	var/heat_transfer = max(air_contents.get_thermal_energy_change(set_temperature + 5), 0)
	heat_transfer = min(heat_transfer, performance_multiplier * power_rating) // don't overshoot
	air_contents.add_thermal_energy(heat_transfer)

/obj/machinery/atmospherics/unary/temperature/heater/get_temperature_class()
	. = "normal"
	if(air_contents.temperature > (T20C+40))
		. = "bad"

//upgrading parts
/obj/machinery/atmospherics/unary/temperature/heater/RefreshParts()
	..()
	var/cap_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 1, 20)
	var/bin_rating = clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)
	max_temperature = max(initial(max_temperature) - T20C, 0) * ((bin_rating * 4 + cap_rating) / 5) + T20C
