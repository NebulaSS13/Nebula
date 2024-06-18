/obj/machinery/atmospherics/pipeturbine
	name = "turbine"
	desc = "A gas turbine. Converting pressure into energy since 1884."
	icon = 'icons/obj/pipeturbine.dmi'
	icon_state = "turbine"
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE

	var/efficiency = 0.4
	var/kin_energy = 0
	var/datum/gas_mixture/air_in = new
	var/datum/gas_mixture/air_out = new
	var/volume_ratio = 0.2
	var/kin_loss = 0.001

	var/dP = 0

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed

/obj/machinery/atmospherics/pipeturbine/Initialize()
	. = ..()
	air_in.volume = 200
	air_out.volume = 800
	volume_ratio = air_in.volume / (air_in.volume + air_out.volume)

/obj/machinery/atmospherics/pipeturbine/get_initialize_directions()
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|WEST
		if(SOUTH)
			initialize_directions = EAST|WEST
		if(EAST)
			initialize_directions = NORTH|SOUTH
		if(WEST)
			initialize_directions = NORTH|SOUTH

/obj/machinery/atmospherics/pipeturbine/air_in_dir(direction)
	if(direction == turn(dir, -90)) // can't tell from sprites if this is even right; old implementation basically randomized this
		return air_out
	else if(direction == turn(dir, 90))
		return air_in

/obj/machinery/atmospherics/pipeturbine/Process()
	..()
	if(anchored && !(stat&BROKEN))
		kin_energy *= 1 - kin_loss
		dP = max(air_in.return_pressure() - air_out.return_pressure(), 0)
		if(dP > 10)
			kin_energy += 1/ADIABATIC_EXPONENT * dP * air_in.volume * (1 - volume_ratio**ADIABATIC_EXPONENT) * efficiency
			air_in.temperature *= volume_ratio**ADIABATIC_EXPONENT

			var/datum/gas_mixture/air_all = new
			air_all.volume = air_in.volume + air_out.volume
			air_all.merge(air_in.remove_ratio(1))
			air_all.merge(air_out.remove_ratio(1))

			air_in.merge(air_all.remove(volume_ratio))
			air_out.merge(air_all)

		update_icon()
		update_networks()

/obj/machinery/atmospherics/pipeturbine/on_update_icon()
	cut_overlays()
	if (dP > 10)
		add_overlay("moto-turb")
	if (kin_energy > 100000)
		add_overlay("low-turb")
	if (kin_energy > 500000)
		add_overlay("med-turb")
	if (kin_energy > 1000000)
		add_overlay("hi-turb")

/obj/machinery/turbinemotor
	name = "motor"
	desc = "Electrogenerator. Converts rotation into power."
	icon = 'icons/obj/pipeturbine.dmi'
	icon_state = "motor"
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE

	var/kin_to_el_ratio = 0.1	//How much kinetic energy will be taken from turbine and converted into electricity
	var/obj/machinery/atmospherics/pipeturbine/turbine

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed

/obj/machinery/turbinemotor/Initialize()
	. = ..()
	updateConnection()

/obj/machinery/turbinemotor/proc/updateConnection()
	turbine = null
	if(src.loc && anchored)
		turbine = locate(/obj/machinery/atmospherics/pipeturbine) in get_step(src,dir)
		if (turbine.stat & (BROKEN) || !turbine.anchored || turn(turbine.dir,180) != dir)
			turbine = null

/obj/machinery/turbinemotor/wrench_floor_bolts(mob/user, delay = 2 SECONDS, obj/item/tool)
	. = ..()
	updateConnection()

/obj/machinery/turbinemotor/Process()
	updateConnection()
	if(!turbine || !anchored || stat & (BROKEN))
		return

	var/power_generated = kin_to_el_ratio * turbine.kin_energy
	turbine.kin_energy -= power_generated
	generate_power(power_generated)
