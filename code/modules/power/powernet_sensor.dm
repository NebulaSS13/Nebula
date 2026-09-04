// POWERNET SENSOR
//
// Last Change 31.12.2014 by Atlantis
//
// Powernet sensors are devices which relay information about connected powernet. This information may be relayed
// via two procs. Proc return_reading_text will return fully HTML styled string which contains all information. This
// may be used in PDAs or similar applications. Second proc, return_reading_data will return list containing needed data.
// This is used in NanoUI, for example.

/obj/machinery/power_sensor
	name = "powernet sensor"
	desc = "A sensor that records and transmits data about its connected power network."
	anchored = TRUE
	density = FALSE
	level = LEVEL_BELOW_PLATING
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon" // If anyone wants to make better sprite, feel free to do so without asking me.

	uncreated_component_parts = null
	stat_immune = NOINPUT | NOSCREEN | NOPOWER
	construct_state = /decl/machine_construction/pipe
	frame_type = /obj/item/machine_chassis/power_sensor

// Proc: New()
// Parameters: None
// Description: Automatically assigns name according to ID tag.
/obj/machinery/power_sensor/Initialize()
	. = ..()
	auto_set_name()

// Proc: auto_set_name()
// Parameters: None
// Description: Sets name of this sensor according to the ID tag.
/obj/machinery/power_sensor/proc/auto_set_name()
	if(!id_tag)
		var/area/A = get_area(src)
		if(!A)
			return // in nullspace
		var/suffix = uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, "[A.proper_name]power/sensor", 1) // unlike sequential_id, starts at 1 instead of 100
		if(suffix == 1)
			suffix = null
		id_tag = "[A.proper_name][suffix ? " #[suffix]" : null]"
	name = "[id_tag] - powernet sensor"

// Proc: has_grid_warning()
// Parameters: None
// Description: Checks connected powernet for warnings. If warning is found returns TRUE
/obj/machinery/power_sensor/proc/has_grid_warning()
	var/datum/powernet/net_to_check = get_powernet()
	return net_to_check?.problem ? TRUE : FALSE

// Proc: reading_to_text()
// Parameters: 1 (amount - Power in Watts to be converted to W, kW or MW)
// Description: Helper proc that converts reading in Watts to kW or MW (returns string version of amount parameter)
/obj/machinery/power_sensor/proc/reading_to_text(var/amount = 0)
	var/units = ""
	// 10kW and less - Watts
	if(amount < 10000)
		units = "W"
	// 10MW and less - KiloWatts
	else if(amount < 10000000)
		units = "kW"
		amount = (round(amount/100) / 10)
	// More than 10MW - MegaWatts
	else
		units = "MW"
		amount = (round(amount/10000) / 100)
	if (units == "W")
		return "[amount] W"
	else
		return "~[amount] [units]" //kW and MW are only approximate readings, therefore add "~"

// Proc: find_apcs()
// Parameters: None
// Description: Searches powernet for APCs and returns them in a list.
/obj/machinery/power_sensor/proc/find_apcs()
	var/datum/powernet/net_to_check = get_powernet()
	if(!net_to_check)
		return

	var/list/L = list()
	for(var/obj/machinery/power/terminal/term in net_to_check.nodes)
		var/obj/machinery/apc/A = term.master_machine()
		if(istype(A))
			L += A

	return L

// Proc: return_reading_data()
// Parameters: None
// Description: Generates list containing all powernet data. Optimised for usage with NanoUI
/obj/machinery/power_sensor/proc/return_reading_data()
	var/datum/powernet/net_to_check = get_powernet()
	var/list/data = list()
	data["name"] = id_tag
	if(!net_to_check)
		data["error"] = "# SYSTEM ERROR - NO POWERNET #"
		data["alarm"] = 0 // Runtime Prevention
		return data

	var/list/L = find_apcs()
	var/total_apc_load = 0
	var/list/APC_data = list()
	if(L.len > 0)
		// These lists are used as replacement for number based APC settings
		var/list/S = list("M-OFF", "DC-OFF","A-OFF","M-ON", "A-ON")
		var/list/chg = list("N","C","F")

		for(var/obj/machinery/apc/A in L)
			var/list/APC_entry = list()
			APC_entry["breaker"] = A.operating
			APC_entry["failure"] = A.failure_timer
			APC_entry["telemetry"] = A.aidisabled
			APC_entry["remote_control"] = A.remote_control
			// Channel Statuses
			APC_entry["s_equipment"] = S[A.equipment+1]
			APC_entry["s_lighting"] = S[A.lighting+1]
			APC_entry["s_environment"] = S[A.environ+1]
			// Channel Statuses (actual vars)
			APC_entry["n_equipment"] = A.equipment
			APC_entry["n_lighting"] = A.lighting
			APC_entry["n_environment"] = A.environ
			// Cell Status
			var/obj/item/cell/cell = A.get_cell()
			APC_entry["cell_charge"] = cell ? round(cell.percent()) : "NO CELL"
			APC_entry["cell_status"] = cell ? chg[A.charging+1] : "N"
			// Other info
			APC_entry["total_load"] = reading_to_text(A.lastused_total)
			APC_entry["name"] = A.area.proper_name
			APC_entry["ref"] = "\ref[A]"
			// Add data into main list of APC data.
			APC_data += list(APC_entry)
			// Add load of this APC to total APC load calculation
			total_apc_load += A.lastused_total
	data["apc_data"] = APC_data
	data["total_avail"] = reading_to_text(max(net_to_check.avail, 0))
	data["total_used_apc"] = reading_to_text(max(total_apc_load, 0))
	data["total_used_other"] = reading_to_text(max(net_to_check.viewload - total_apc_load, 0))
	data["total_used_all"] = reading_to_text(max(net_to_check.viewload, 0))
	// Prevents runtimes when avail is 0 (division by zero)
	if(net_to_check.avail)
		data["load_percentage"] = round((net_to_check.viewload / net_to_check.avail) * 100)
	else
		data["load_percentage"] = 100
	data["alarm"] = net_to_check.problem ? 1 : 0
	return data





