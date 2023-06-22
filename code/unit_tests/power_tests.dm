/datum/unit_test/roundstart_cable_connectivity
	name = "POWER: Roundstart Cables that are Connected Share Powernets"

/datum/unit_test/roundstart_cable_connectivity/proc/find_connected_neighbours(var/obj/structure/cable/C)
	. = list()
	if(C.d1 != 0)
		. += get_connected_neighbours(C, C.d1)
	if(C.d2 != 0)
		. += get_connected_neighbours(C, C.d2)

/datum/unit_test/roundstart_cable_connectivity/proc/get_connected_neighbours(var/obj/structure/cable/self, var/dir)
	var/turf/T = get_step(get_turf(self), dir)
	var/reverse = global.reverse_dir[dir]

	. = list() //can have multiple connected neighbours for a dir, e.g. Y-junctions
	for(var/obj/structure/cable/other in T)
		if(other.d1 == reverse || other.d2 == reverse)
			. += other

/datum/unit_test/roundstart_cable_connectivity/start_test()
	var/failed = 0
	var/list/found_cables = list()

	for(var/obj/structure/cable/C in global.cable_list)
		if(C in found_cables)
			continue
		var/list/to_search = list(C)
		var/list/searched = list()
		while(to_search.len)
			var/obj/structure/cable/next = to_search[to_search.len]
			to_search.len--
			searched += next
			for(var/obj/structure/cable/other in find_connected_neighbours(next))
				if(other in searched)
					continue
				if(next.powernet != other.powernet)
					fail("Cable at ([next.x], [next.y], [next.z]) did not share powernet with connected neighbour at ([other.x], [other.y], [other.z])")
					failed++
				to_search += other

		found_cables += searched

	if(failed)
		fail("Found [failed] bad cables.")
	else
		pass("All connected roundstart cables have matching powernets.")

	return 1


/datum/unit_test/areas_apc_uniqueness
	name = "POWER: Each area should have at most one APC."

/datum/unit_test/areas_apc_uniqueness/start_test()
	var/failure = ""
	for(var/area/A in global.areas)
		var/obj/machinery/power/apc/found_apc = null
		for(var/obj/machinery/power/apc/APC in A)
			if(!found_apc)
				found_apc = APC
				continue
			if(failure)
				failure = "[failure]\n"
			failure = "[failure]Duplicated APCs in area: [A.proper_name]. #1: [log_info_line(found_apc)]  #2: [log_info_line(APC)]"

	if(failure)
		fail(failure)
	else
		pass("No areas with duplicated APCs have been found.")
	return 1

/datum/unit_test/area_power_tally_accuracy
	name = "POWER: All areas must have accurate power use values."
	var/list/channel_names = list("equip", "light", "environ")
/obj/machinery/test_machine
	power_channel = EQUIP
	idle_power_usage = 1000
	use_power = POWER_USE_IDLE
	is_spawnable_type = FALSE
	simulated = FALSE // Otherwise it would be lost to space edge handling.

/datum/unit_test/area_power_tally_accuracy/proc/check_power(var/area/A)
	var/list/old_values = list(A.used_equip, A.used_light, A.used_environ)
	A.retally_power()
	var/list/new_values = list(A.used_equip, A.used_light, A.used_environ)
	for(var/i in 1 to length(old_values))
		if(abs(old_values[i] - new_values[i]) > 1) // Round because there can in fact be roundoff error here apparently.
			. = TRUE
			log_bad("The area [A.proper_name] had improper power use values on the [channel_names[i]] channel: was [old_values[i]] but should be [new_values[i]].")
			log_bad("This area contained the following power-using machines on this channel:")
			for(var/obj/machinery/machine in A)
				if(machine.power_channel == i)
					log_bad(log_info_line(machine) + " with power use [machine.get_power_usage()]")

/datum/unit_test/area_power_tally_accuracy/start_test()
	var/failed = FALSE

	for(var/area/A in global.areas)
		var/area_failed = check_power(A)
		if(!area_failed) // spawn a "hand-made" machine and check again
			var/turf/T = locate() in A.contents
			if(T)
				var/obj/machinery/test_machine/machine = new (T)
				area_failed = check_power(A)
				qdel(machine)
		failed |= area_failed

	if(failed)
		fail("At least one area had improper power use values")
	else
		pass("All areas had accurate power use values.")
	return 1