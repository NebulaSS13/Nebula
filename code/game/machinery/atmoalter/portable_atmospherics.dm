/obj/machinery/portable_atmospherics
	name = "atmoalter"
	use_power = POWER_USE_OFF
	construct_state = /decl/machine_construction/default/panel_closed
	atom_flags = ATOM_FLAG_CLIMBABLE

	var/datum/gas_mixture/air_contents = new
	var/obj/item/tank/holding
	var/volume = 0
	var/destroyed = 0
	var/start_pressure = ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/get_single_monetary_worth()
	. = ..()
	for(var/gas in air_contents?.gas)
		var/decl/material/gas_data = GET_DECL(gas)
		. += gas_data.get_value() * air_contents.gas[gas] * GAS_WORTH_MULTIPLIER
	. = max(1, round(.))

/obj/machinery/portable_atmospherics/Initialize()
	..()
	air_contents.volume = volume
	air_contents.temperature = T20C


	set_extension(src, /datum/extension/atmospherics_connection, TRUE, air_contents)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/portable_atmospherics/Destroy()
	QDEL_NULL(air_contents)
	QDEL_NULL(holding)
	. = ..()

/obj/machinery/portable_atmospherics/LateInitialize()
	var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
	if(port)
		var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)
		if(connection)
			connection.connect(port)
			update_icon()

/obj/machinery/portable_atmospherics/Process()
	if(get_port()) // Only react when pipe_network will not do it for you
		air_contents.react()
	else
		update_icon()

/obj/machinery/portable_atmospherics/proc/StandardAirMix()
	return list(
		/decl/material/gas/oxygen = O2STANDARD * MolesForPressure(),
		/decl/material/gas/nitrogen = N2STANDARD *  MolesForPressure())

/obj/machinery/portable_atmospherics/proc/MolesForPressure(var/target_pressure = start_pressure)
	return (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)

/obj/machinery/portable_atmospherics/on_update_icon()
	return null

/obj/machinery/portable_atmospherics/proc/get_port()
	var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)

	return connection?.connected_port

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)

	return connection?.connect(new_port)

/obj/machinery/portable_atmospherics/proc/disconnect()
	var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)

	return connection?.disconnect()

/obj/machinery/portable_atmospherics/proc/update_connected_network()
	var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)
	connection?.update_connected_network()

/obj/machinery/portable_atmospherics/attackby(var/obj/item/used_item, var/mob/user)
	if ((istype(used_item, /obj/item/tank) && !destroyed))
		if (holding)
			return TRUE
		if(!user.try_unequip(used_item, src))
			return TRUE
		holding = used_item
		update_icon()
		return TRUE

	else if(IS_WRENCH(used_item) && !panel_open)
		if(disconnect())
			to_chat(user, SPAN_NOTICE("You disconnect \the [src] from the port."))
			update_icon()
			return TRUE
		var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector) in loc
		if(possible_port)
			if(connect(possible_port))
				to_chat(user, SPAN_NOTICE("You connect \the [src] to the port."))
				update_icon()
				return TRUE
			to_chat(user, SPAN_NOTICE("\The [src] failed to connect to the port."))
			return TRUE
		return ..()

	else if (istype(used_item, /obj/item/scanner/gas))
		return FALSE // allow the scanner's afterattack to run

	return ..()

/obj/machinery/portable_atmospherics/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered
	uncreated_component_parts = null
	stat_immune = 0
	use_power = POWER_USE_IDLE
	var/power_rating
	var/power_losses
	var/last_power_draw = 0

/obj/machinery/portable_atmospherics/powered/power_change()
	. = ..()
	if(. && (stat & NOPOWER))
		update_use_power(POWER_USE_IDLE)

/obj/machinery/portable_atmospherics/powered/components_are_accessible(path)
	return panel_open

/obj/machinery/portable_atmospherics/proc/log_open()
	if(length(air_contents?.gas))
		var/list/gases
		for(var/gas in air_contents.gas)
			var/decl/material/gasdata = GET_DECL(gas)
			LAZYADD(gases, gasdata.gas_name)
		if(length(gases))
			log_and_message_admins("opened \the [src], containing [english_list(gases)].")

/obj/machinery/portable_atmospherics/powered/dismantle()
	if(isturf(loc))
		playsound(loc, 'sound/effects/spray.ogg', 10, 1, -3)
		loc.assume_air(air_contents)
	. = ..()