/datum/unit_test/machines_shall_obey_part_maximum
	name = "MACHINE: All mapped machines shall respect their own maximum component limit."

/datum/unit_test/machines_shall_obey_part_maximum/start_test()
	var/failed = list()
	var/passed = list()
	for(var/thing in SSmachines.machinery)
		var/obj/machinery/machine = thing
		if(passed[machine.type] || failed[machine.type])
			continue
		for(var/path in machine.maximum_component_parts)
			if(machine.number_of_components(path) > machine.maximum_component_parts[path])
				failed[machine.type] = TRUE
				log_bad("[log_info_line(machine)] had too many components of type [path].")
		if(!failed[machine.type])
			passed[machine.type] = TRUE

	if(length(failed))
		fail("One or more machines had too many components.")
	else
		pass("All machines respected component limits.")
	return  1

/datum/unit_test/machines_with_circuits_shall_have_construct_states
	name = "MACHINE: All mapped machines with corresponding circuits shall use construct states."

/datum/unit_test/machines_with_circuits_shall_have_construct_states/start_test()
	var/failed = list()
	var/passed = list()
	for(var/thing in SSmachines.machinery)
		var/obj/machinery/machine = thing
		if(passed[machine.type] || failed[machine.type])
			continue
		var/path = machine.base_type || machine.type
		var/circuit_type = get_circuit_by_build_path(path)
		if(circuit_type && !machine.construct_state)
			failed[machine.type] = TRUE
			log_bad("[log_info_line(machine)] had an associated circuit of type [circuit_type] but no construction state.")
		else
			passed[machine.type] = TRUE

	if(length(failed))
		fail("One or more machines lacked a construction state despite having a circuit.")
	else
		pass("All machines with circuits had construction states.")
	return  1

/datum/unit_test/machine_construct_states_shall_be_valid
	name = "MACHINE: All mapped machines with construct states shall meet state requirements."

/// Returns a failure string if the unit test should fail, FALSE if it should succeed.
/// Mostly just a wrapper to handle things like unlocking prior to testing, or skipping the testing entirely.
/obj/machinery/proc/fail_construct_state_unit_test()
	if(!construct_state)
		return FALSE
	return construct_state.fail_unit_test(src)

/datum/unit_test/machine_construct_states_shall_be_valid/start_test()
	var/failed = list()
	for(var/thing in SSmachines.machinery)
		var/obj/machinery/machine = thing
		if(failed[machine.type])
			continue
		var/fail = machine.fail_construct_state_unit_test()
		if(fail)
			failed[machine.type] = TRUE
			log_bad(fail)

	if(length(failed))
		fail("One or more machines had an invalid construction state.")
	else
		pass("All machines had valid construction states.")
	return  1

/datum/unit_test/machine_circuit_matches_basetype
	name = "MACHINE: All mapped machines with a circuit for their exact type will have a matching basetype."

/datum/unit_test/machine_circuit_matches_basetype/start_test()
	var/failed = list()
	for(var/obj/machinery/machine in SSmachines.machinery)
		if(failed[machine.type])
			continue
		var/exact_circuit = get_circuit_by_build_path(machine.type)
		var/base_circuit = machine.base_type && get_circuit_by_build_path(machine.base_type)
		if(exact_circuit && base_circuit && (exact_circuit != base_circuit) && (machine.base_type != machine.type))
			failed[machine.type] = TRUE
			log_bad("[machine.type] exactly matches [exact_circuit] but its base type is [machine.base_type], which has [base_circuit].")

	if(length(failed))
		fail("One or more machines had an invaild basetype.")
	else
		pass("All machines had valid basetypes.")
	return  1

/datum/unit_test/machines_shall_have_sane_stat_immune
	name = "MACHINE: All machines that do not require screens/keyboards must have NOSCREEN/NOINPUT stat immunity."

/datum/unit_test/machines_shall_have_sane_stat_immune/start_test()
	var/failed = list()
	var/passed = list()
	for(var/obj/machinery/machine as anything in SSmachines.machinery)
		var/candidate_type = machine.base_type || machine.type
		if(isnull(machine.construct_state))
			continue
		if(passed[candidate_type] || failed[candidate_type])
			continue
		var/obj/item/stock_parts/circuitboard/board = machine.get_component_of_type(/obj/item/stock_parts/circuitboard)
		var/has_screen = machine.get_component_of_type(/obj/item/stock_parts/console_screen)
		var/has_keyboard = machine.get_component_of_type(/obj/item/stock_parts/keyboard)
		if(board)
			has_screen ||= (/obj/item/stock_parts/console_screen in board.req_components) || (/obj/item/stock_parts/console_screen in board.additional_spawn_components)
			has_keyboard ||= (/obj/item/stock_parts/keyboard in board.req_components) || (/obj/item/stock_parts/keyboard in board.additional_spawn_components)
		if(!has_screen && !(machine.stat_immune & NOSCREEN))
			failed[candidate_type] = TRUE
			log_bad("[log_info_line(machine)] doesn't start with or require a screen, but did not have NOSCREEN in stat_immune.")
		if(!has_keyboard && !(machine.stat_immune & NOINPUT))
			failed[candidate_type] = TRUE
			log_bad("[log_info_line(machine)] doesn't start with or require a keyboard, but did not have NOINPUT in stat_immune.")
		if(!failed[candidate_type])
			passed[candidate_type] = TRUE

	if(length(failed))
		fail("One or more machines had incorrect stat_immune settings.")
	else
		pass("All machines had correct stat_immune settings.")
	return TRUE