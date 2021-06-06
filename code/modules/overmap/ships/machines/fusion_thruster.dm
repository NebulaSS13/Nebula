/obj/machinery/atmospherics/unary/engine/fusion
	name = "direct fusion drive"
	desc = "Advanced nuclear fusion drive, capable of generating magnetic fields strong enough to contain and utilize reacting nuclei power to accelerate spacecraft."

	base_type = /obj/machinery/atmospherics/unary/engine/fusion
	construct_state = /decl/machine_construction/default/panel_closed
	maximum_component_parts = list(/obj/item/stock_parts = 16)
	engine_extension = /datum/extension/ship_engine/gas/fusion

	idle_power_usage = 6000 //constant magnetic field generation, internal circuitry

/obj/machinery/atmospherics/unary/engine/fusion/emp_act(severity)
	. = ..()
	if(!operable() || !use_power) return
	var/datum/extension/ship_engine/gas/fusion/boom = get_extension(src,engine_extension)
	var/datum/gas_mixture/mix = boom.get_propellant(sample_only = FALSE)
	for(var/I in 1 to 4 - severity)
		mix.merge(boom.get_propellant(sample_only = FALSE)) //Pull up some more of that tasty hydrogen w/e
	if(mix.get_total_moles() != 0 && mix.temperature > 1000)
		var/effective_boomrange = round(mix.temperature * mix.get_total_moles() * (1/10e5))
		loc.assume_air(mix)
		explosion(get_turf(src),1,effective_boomrange*0.1,effective_boomrange*0.3,6,TRUE)

