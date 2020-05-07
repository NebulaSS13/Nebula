/datum/extension/ship_engine/gas/fusion
	expected_type = /obj/machinery/atmospherics/unary/engine/fusion
	var/efficiency = 0.8

/datum/extension/ship_engine/gas/fusion/get_propellant(var/sample_only = TRUE)
	var/obj/machinery/atmospherics/unary/engine/fusion/thruster = holder
	if(!thruster.harvest_from || !thruster.harvest_from.owned_field)
		return // No valid propellant.
	var/obj/effect/fusion_em_field/owned_field = thruster.harvest_from.owned_field
	var/datum/gas_mixture/propellant = ..()
	propellant.temperature += owned_field.plasma_temperature * efficiency
	return propellant

/datum/extension/ship_engine/gas/fusion/has_fuel()
	. = ..()
	if(!.)
		return
	var/obj/machinery/atmospherics/unary/engine/fusion/thruster = holder
	return thruster.harvest_from && thruster.harvest_from.owned_field

/datum/extension/ship_engine/gas/fusion/can_burn()
	. = ..()
	if(!.)
		return
	var/obj/machinery/atmospherics/unary/engine/fusion/thruster = holder
	return thruster.harvest_from && thruster.harvest_from.owned_field