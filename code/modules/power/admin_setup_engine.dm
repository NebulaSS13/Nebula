#define ENGINE_SETUP_OK 1			// All good
#define ENGINE_SETUP_WARNING 2		// Something that shouldn't happen happened, but it's not critical so we will continue
#define ENGINE_SETUP_ERROR 3		// Something bad happened, and it's important so we won't continue setup.
#define ENGINE_SETUP_DELAYED 4		// Wait for other things first.

var/global/list/engine_setup_markers = list()

/obj/effect/engine_setup
	name = "Engine Setup Marker"
	desc = "You shouldn't see this."
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	density = FALSE
	icon = 'icons/effects/markers.dmi'
	icon_state = "x3"

/obj/effect/engine_setup/Initialize()
	. = ..()
	global.engine_setup_markers += src

/obj/effect/engine_setup/Destroy()
	global.engine_setup_markers -= src
	. = ..()

/obj/effect/engine_setup/proc/activate(var/last = 0)
	return 1



// Tries to locate a pump, enables it, and sets it to MAX. Triggers warning if unable to locate a pump.
/obj/effect/engine_setup/pump_max
	name = "Pump Setup Marker"

/obj/effect/engine_setup/pump_max/activate()
	..()
	var/obj/machinery/atmospherics/binary/pump/P = locate() in get_turf(src)
	if(!P)
		log_and_message_admins("## WARNING: Unable to locate pump at [x] [y] [z]!")
		return ENGINE_SETUP_WARNING
	P.target_pressure = P.max_pressure_setting
	P.update_use_power(POWER_USE_IDLE)
	return ENGINE_SETUP_OK



// Spawns an empty canister on this turf, if it has a connector port. Triggers warning if unable to find a connector port
/obj/effect/engine_setup/empty_canister
	name = "Empty Canister Marker"

/obj/effect/engine_setup/empty_canister/activate()
	..()
	var/obj/machinery/atmospherics/portables_connector/P = locate() in get_turf(src)
	if(!P)
		log_and_message_admins("## WARNING: Unable to locate connector port at [x] [y] [z]!")
		return ENGINE_SETUP_WARNING
	new/obj/machinery/portable_atmospherics/canister(get_turf(src)) // Canisters automatically connect to connectors in New()
	return ENGINE_SETUP_OK




// Spawns a coolant canister on this turf, if it has a connector port.
// Triggers error when unable to locate connector port or when coolant canister type is unset.
/obj/effect/engine_setup/coolant_canister
	name = "Coolant Canister Marker"
	var/canister_type = null

/obj/effect/engine_setup/coolant_canister/activate()
	..()
	var/obj/machinery/atmospherics/portables_connector/P = locate() in get_turf(src)
	if(!P)
		log_and_message_admins("## ERROR: Unable to locate coolant connector port at [x] [y] [z]!")
		return ENGINE_SETUP_ERROR
	if(!canister_type)
		log_and_message_admins("## ERROR: Canister type unset at [x] [y] [z]!")
		return ENGINE_SETUP_ERROR
	new canister_type(get_turf(src))
	return ENGINE_SETUP_OK



// Tries to enable the SMES on max input/output settings. With load balancing it should be fine as long as engine outputs at least ~500kW
/obj/effect/engine_setup/smes
	name = "SMES Marker"

	var/target_input_level		//These are in watts, the display is in kilowatts. Add three zeros to the value you want.
	var/target_output_level		//These are in watts, the display is in kilowatts. Add three zeros to the value you want.

/obj/effect/engine_setup/smes/main
	name = "Main SMES Marker"
	target_input_level =  INFINITY
	target_output_level = INFINITY

/obj/effect/engine_setup/smes/activate()
	..()
	var/obj/machinery/power/smes/S = locate() in get_turf(src)
	if(!S)
		log_and_message_admins("## WARNING: Unable to locate SMES unit at [x] [y] [z]!")
		return ENGINE_SETUP_WARNING
	S.input_attempt = 1
	S.input_level = min(target_input_level, S.input_level_max)
	S.output_attempt = 1
	S.output_level = min(target_output_level, S.output_level_max)
	S.update_icon()
	return ENGINE_SETUP_OK

// Sets up filters. This assumes filters are set to filter out CO2 back to the core loop by default!
/obj/effect/engine_setup/filter
	name = "Omni Filter Marker"
	var/coolant = null

/obj/effect/engine_setup/filter/activate()
	..()
	var/obj/machinery/atmospherics/omni/filter/F = locate() in get_turf(src)
	if(!F)
		log_and_message_admins("## WARNING: Unable to locate omni filter at [x] [y] [z]!")
		return ENGINE_SETUP_WARNING
	if(!coolant)
		log_and_message_admins("## WARNING: No coolant type set at [x] [y] [z]!")
		return ENGINE_SETUP_WARNING

	// Non-co2 coolant, adjust the filter's config first.
	if(coolant != "CO2")
		for(var/datum/omni_port/P in F.ports)
			if(P.filtering != /decl/material/gas/carbon_dioxide)
				continue
			else if(coolant == "N2")
				P.filtering = /decl/material/gas/nitrogen
				break
			else if(coolant == "H2")
				P.filtering = /decl/material/gas/hydrogen
				break
			else
				log_and_message_admins("## WARNING: Inapropriate filter coolant type set at [x] [y] [z]!")
				return ENGINE_SETUP_WARNING
		F.rebuild_filtering_list()

	F.update_use_power(POWER_USE_IDLE)
	return ENGINE_SETUP_OK

// Closes the monitoring room shutters so the first Engi to show up doesn't get microwaved
/obj/effect/engine_setup/shutters
	name = "Shutter Button Marker"
	// This needs to be set to whatever the shutter button is called
	var/target_button = "Engine Monitoring Room Blast Doors"

/obj/effect/engine_setup/shutters/activate()
	if(!target_button)
		log_and_message_admins("## WARNING: No button type set at [x] [y] [z]!")
		return ENGINE_SETUP_WARNING
	var/obj/machinery/button/blast_door/found = null
	var/turf/T = get_turf(src)
	for(var/obj/machinery/button/blast_door/B in T.contents)
		if(B.name == target_button)
			found = B
			break
	if(!found)
		log_and_message_admins("## WARNING: Unable to locate button at [x] [y] [z]!")
		return ENGINE_SETUP_WARNING
	found.activate()
	found.update_icon()
	return ENGINE_SETUP_OK