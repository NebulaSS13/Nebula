/obj/machinery/atmospherics/unary/heat_exchanger

	icon = 'icons/obj/atmospherics/heat_exchanger.dmi'
	icon_state = "intact"
	density = 1

	name = "Heat Exchanger"
	desc = "Exchanges heat between two input gases. Setup for fast heat transfer."

	var/obj/machinery/atmospherics/unary/heat_exchanger/partner = null
	var/update_cycle

	connect_types = CONNECT_TYPE_REGULAR | CONNECT_TYPE_FUEL
	build_icon_state = "heunary"

	frame_type = /obj/item/pipe
	uncreated_component_parts = null
	construct_state = /decl/machine_construction/pipe
	interact_offline = TRUE

/obj/machinery/atmospherics/unary/heat_exchanger/Destroy()
	if(partner)
		partner.partner = null
		partner = null
	. = ..()

/obj/machinery/atmospherics/unary/heat_exchanger/on_update_icon()
	if(LAZYLEN(nodes_to_networks))
		icon_state = "intact"
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/unary/heat_exchanger/atmos_init()
	if(partner)
		partner.partner = null
		partner = null
	var/partner_connect = turn(dir,180)

	for(var/obj/machinery/atmospherics/unary/heat_exchanger/target in get_step(src,partner_connect))
		if(target.dir & get_dir(src,target))
			partner = target
			partner.partner = src
			break
	..()

/obj/machinery/atmospherics/unary/heat_exchanger/Process()
	..()
	if(!partner)
		return 0

	if(SSair.times_fired <= update_cycle)
		return 0

	update_cycle = SSair.times_fired
	partner.update_cycle = SSair.times_fired

	var/air_heat_capacity = air_contents.heat_capacity()
	var/other_air_heat_capacity = partner.air_contents.heat_capacity()
	var/combined_heat_capacity = other_air_heat_capacity + air_heat_capacity

	var/old_temperature = air_contents.temperature
	var/other_old_temperature = partner.air_contents.temperature

	if(combined_heat_capacity > 0)
		var/combined_energy = partner.air_contents.temperature*other_air_heat_capacity + air_heat_capacity*air_contents.temperature

		var/new_temperature = combined_energy/combined_heat_capacity
		air_contents.temperature = new_temperature
		partner.air_contents.temperature = new_temperature


	if(abs(old_temperature-air_contents.temperature) > 1)
		update_networks()

	if(abs(other_old_temperature-partner.air_contents.temperature) > 1)
		partner.update_networks()

/obj/machinery/atmospherics/unary/heat_exchanger/deconstruction_pressure_check()
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()

	if ((int_air.return_pressure()-env_air.return_pressure()) > (2 ATM))
		return FALSE
	return TRUE

/obj/machinery/atmospherics/unary/heat_exchanger/cannot_transition_to(state_path, mob/user)
	if(state_path == /decl/machine_construction/default/deconstructed)
		var/turf/T = get_turf(src)
		if (level==1 && isturf(T) && !T.is_plating())
			return SPAN_WARNING("You must remove the plating first.")
	return ..()