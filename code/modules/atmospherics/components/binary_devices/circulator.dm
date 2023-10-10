//node1, air1, network1 correspond to input
//node2, air2, network2 correspond to output

/obj/machinery/atmospherics/binary/circulator
	name = "circulator"
	desc = "A gas circulator turbine and heat exchanger."
	icon = 'icons/obj/power.dmi'
	icon_state = "circ-unassembled"
	anchored = 0
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	layer = STRUCTURE_LAYER

	var/kinetic_efficiency = 0.04 //combined kinetic and kinetic-to-electric efficiency
	var/volume_ratio = 0.2

	var/recent_moles_transferred = 0
	var/last_heat_capacity = 0
	var/last_temperature = 0
	var/last_pressure_delta = 0
	var/last_worldtime_transfer = 0
	var/last_stored_energy_transferred = 0
	var/volume_capacity_used = 0
	var/stored_energy = 0
	var/temperature_overlay

	density = 1
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed

/obj/machinery/atmospherics/binary/circulator/Initialize()
	. = ..()
	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]."
	air1.volume = 400

/obj/machinery/atmospherics/binary/circulator/proc/return_transfer_air()
	var/datum/gas_mixture/removed
	var/datum/pipe_network/input = network_in_dir(turn(dir, 180))
	if(anchored && !(stat&BROKEN) && input)
		var/input_starting_pressure = air1.return_pressure()
		var/output_starting_pressure = air2.return_pressure()
		last_pressure_delta = max(input_starting_pressure - output_starting_pressure - 5, 0)

		//only circulate air if there is a pressure difference (plus 5kPa kinetic, 10kPa static friction)
		if(air1.temperature > 0 && last_pressure_delta > 5)

			//Calculate necessary moles to transfer using PV = nRT
			recent_moles_transferred = (last_pressure_delta*input.volume/(air1.temperature * R_IDEAL_GAS_EQUATION))/3 //uses the volume of the whole network, not just itself
			volume_capacity_used = min( (last_pressure_delta*input.volume/3)/(input_starting_pressure*air1.volume) , 1) //how much of the gas in the input air volume is consumed

			//Calculate energy generated from kinetic turbine
			stored_energy += 1/ADIABATIC_EXPONENT * min(last_pressure_delta * input.volume , input_starting_pressure*air1.volume) * (1 - volume_ratio**ADIABATIC_EXPONENT) * kinetic_efficiency

			//Actually transfer the gas
			removed = air1.remove(recent_moles_transferred)
			if(removed)
				last_heat_capacity = removed.heat_capacity()
				last_temperature = removed.temperature

				//Update the gas networks.
				input.update = 1

				last_worldtime_transfer = world.time
		else
			recent_moles_transferred = 0

		update_icon()
		return removed

/obj/machinery/atmospherics/binary/circulator/proc/return_stored_energy()
	last_stored_energy_transferred = stored_energy
	stored_energy = 0
	return last_stored_energy_transferred

/obj/machinery/atmospherics/binary/circulator/Process()
	..()

	if(last_worldtime_transfer < world.time - 50)
		recent_moles_transferred = 0
		update_icon()

/obj/machinery/atmospherics/binary/circulator/on_update_icon()
	icon_state = anchored ? "circ-assembled" : "circ-unassembled"
	overlays.Cut()
	if (stat & (BROKEN|NOPOWER) || !anchored)
		return 1
	if (last_pressure_delta > 0 && recent_moles_transferred > 0)
		if (temperature_overlay)
			overlays += image('icons/obj/power.dmi', temperature_overlay)
		if (last_pressure_delta > (5 ATM))
			overlays += image('icons/obj/power.dmi', "circ-run")
		else
			overlays += image('icons/obj/power.dmi', "circ-slow")
	else
		overlays += image('icons/obj/power.dmi', "circ-off")

	return 1

/obj/machinery/atmospherics/binary/circulator/set_dir(new_dir)
	. = ..()
	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]."