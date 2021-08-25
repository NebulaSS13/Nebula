/*
	Unit tests for ATMOSPHERICS primitives
*/
/datum/unit_test/atmos_machinery
	template = /datum/unit_test/atmos_machinery
	var/list/test_cases = list()

/datum/unit_test/atmos_machinery/proc/create_gas_mixes(gas_mix_data)
	var/list/gas_mixes = list()
	for(var/mix_name in gas_mix_data)
		var/list/mix_data = gas_mix_data[mix_name]

		var/datum/gas_mixture/gas_mix = new (CELL_VOLUME, mix_data["temperature"])

		var/list/initial_gas = mix_data["initial_gas"]
		if(initial_gas.len)
			var/list/gas_args = list()
			for(var/gasid in initial_gas)
				gas_args += gasid
				gas_args += initial_gas[gasid]
			gas_mix.adjust_multi(arglist(gas_args))

		gas_mixes[mix_name] = gas_mix
	return gas_mixes

/datum/unit_test/atmos_machinery/proc/gas_amount_changes(var/list/before_gas_mixes, var/list/after_gas_mixes)
	var/list/result = list()
	for(var/mix_name in before_gas_mixes & after_gas_mixes)
		var/change = list()

		var/datum/gas_mixture/before = before_gas_mixes[mix_name]
		var/datum/gas_mixture/after = after_gas_mixes[mix_name]

		var/list/all_gases = before.gas | after.gas
		for(var/gasid in all_gases)
			change[gasid] = after.get_gas(gasid) - before.get_gas(gasid)

		result[mix_name] = change

	return result

/datum/unit_test/atmos_machinery/proc/check_moles_conserved(var/case_name, var/list/before_gas_mixes, var/list/after_gas_mixes)
	var/failed = FALSE
	for(var/gasid in subtypesof(/decl/material/gas))
		var/before = 0
		for(var/gasmix in before_gas_mixes)
			var/datum/gas_mixture/G = before_gas_mixes[gasmix]
			before += G.get_gas(gasid)

		var/after = 0
		for(var/gasmix in after_gas_mixes)
			var/datum/gas_mixture/G = after_gas_mixes[gasmix]
			after += G.get_gas(gasid)

		if(abs(before - after) > ATMOS_PRECISION)
			fail("[case_name]: expected [before] moles of [gasid], found [after] moles.")
			failed |= TRUE

	if(!failed)
		pass("[case_name]: conserved moles of each gas ID.")

/datum/unit_test/atmos_machinery/conserve_moles
	template = /datum/unit_test/atmos_machinery/conserve_moles
	test_cases = list(
		uphill = list(
			source = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 5,
					/decl/material/gas/nitrogen       = 10,
					/decl/material/gas/carbon_dioxide = 5,
					/decl/material/gas/chlorine       = 10,
					/decl/material/gas/nitrous_oxide  = 5
				),
				temperature = T20C - 5,
			),
			sink = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 10,
					/decl/material/gas/nitrogen       = 20,
					/decl/material/gas/carbon_dioxide = 10,
					/decl/material/gas/chlorine       = 20,
					/decl/material/gas/nitrous_oxide  = 10
				),
				temperature = T20C + 5,
			)
		),
		downhill = list(
			source = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 10,
					/decl/material/gas/nitrogen       = 20,
					/decl/material/gas/carbon_dioxide = 10,
					/decl/material/gas/chlorine       = 20,
					/decl/material/gas/nitrous_oxide  = 10
				),
				temperature = T20C + 5,
			),
			sink = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 5,
					/decl/material/gas/nitrogen       = 10,
					/decl/material/gas/carbon_dioxide = 5,
					/decl/material/gas/chlorine       = 10,
					/decl/material/gas/nitrous_oxide  = 5
				),
				temperature = T20C - 5,
			),
		),
		flat = list(
			source = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 10,
					/decl/material/gas/nitrogen       = 20,
					/decl/material/gas/carbon_dioxide = 10,
					/decl/material/gas/chlorine       = 20,
					/decl/material/gas/nitrous_oxide  = 10
				),
				temperature = T20C,
			),
			sink = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 10,
					/decl/material/gas/nitrogen       = 20,
					/decl/material/gas/carbon_dioxide = 10,
					/decl/material/gas/chlorine       = 20,
					/decl/material/gas/nitrous_oxide  = 10
				),
				temperature = T20C,
			),
		),
		vacuum_sink = list(
			source = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 10,
					/decl/material/gas/nitrogen       = 20,
					/decl/material/gas/carbon_dioxide = 10,
					/decl/material/gas/chlorine       = 20,
					/decl/material/gas/nitrous_oxide  = 10
				),
				temperature = T20C,
			),
			sink = list(
				initial_gas = list(),
				temperature = 0,
			),
		),
		vacuum_source = list(
			source = list(
				initial_gas = list(),
				temperature = 0,
			),
			sink = list(
				initial_gas = list(
					/decl/material/gas/oxygen         = 10,
					/decl/material/gas/nitrogen       = 20,
					/decl/material/gas/carbon_dioxide = 10,
					/decl/material/gas/chlorine       = 20,
					/decl/material/gas/nitrous_oxide  = 10
				),
				temperature = T20C,
			),
		),
	)


/datum/unit_test/atmos_machinery/conserve_moles/pump_gas
	name = "ATMOS MACHINERY: pump_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas(null, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas_passive
	name = "ATMOS MACHINERY: pump_gas_passive() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/pump_gas_passive/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		pump_gas_passive(null, after_gas_mixes["source"], after_gas_mixes["sink"], null)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/scrub_gas
	name = "ATMOS MACHINERY: scrub_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/scrub_gas/start_test()
	var/list/filtering = subtypesof(/decl/material/gas)
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		scrub_gas(null, filtering, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas
	name = "ATMOS MACHINERY: filter_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas/start_test()
	var/list/filtering = subtypesof(/decl/material/gas)
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		filter_gas(null, filtering, after_gas_mixes["source"], after_gas_mixes["sink"], after_gas_mixes["source"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas_multi
	name = "ATMOS MACHINERY: filter_gas_multi() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/filter_gas_multi/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		var/list/filtering = list()
		for(var/gasid in subtypesof(/decl/material/gas))
			filtering[gasid] = after_gas_mixes["sink"] //just filter everything to sink

		filter_gas_multi(null, filtering, after_gas_mixes["source"], after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/atmos_machinery/conserve_moles/mix_gas
	name = "ATMOS MACHINERY: mix_gas() Conserves Moles"

/datum/unit_test/atmos_machinery/conserve_moles/mix_gas/start_test()
	for(var/case_name in test_cases)
		var/gas_mix_data = test_cases[case_name]
		var/list/before_gas_mixes = create_gas_mixes(gas_mix_data)
		var/list/after_gas_mixes = create_gas_mixes(gas_mix_data)

		var/list/mix_sources = list()
		var/list/all_gasses = subtypesof(/decl/material/gas)
		var/gas_count = length(all_gasses)
		for(var/gasid in all_gasses)
			var/datum/gas_mixture/mix_source = after_gas_mixes["sink"]
			mix_sources[mix_source] = 1.0/gas_count //doesn't work as a macro for some reason

		mix_gas(null, mix_sources, after_gas_mixes["sink"], null, INFINITY)

		check_moles_conserved(case_name, before_gas_mixes, after_gas_mixes)

	return 1

/datum/unit_test/pipes_shall_belong_to_unique_pipelines
	name = "ATMOS MACHINERY: all pipes shall belong to a unique pipeline"

/datum/unit_test/pipes_shall_belong_to_unique_pipelines/start_test()
	var/list/checked_pipes = list()
	var/list/bad_pipelines = list()
	for(var/datum/pipeline/P)
		for(var/thing in P.members)
			var/obj/machinery/atmospherics/pipe/pipe = thing
			if(!checked_pipes[thing])
				checked_pipes[thing] = P
				continue
			LAZYDISTINCTADD(bad_pipelines[P], pipe)
			LAZYDISTINCTADD(bad_pipelines[checked_pipes[thing]], pipe) // Missed it the first time; thought it was good.

	if(length(bad_pipelines))
		for(var/datum/pipeline/badboy in bad_pipelines)
			var/info = list()
			for(var/bad_pipe in bad_pipelines[badboy])
				info += log_info_line(bad_pipe)
			log_bad("A pipeline with overlapping members contained the following overlapping pipes: [english_list(info)]")
		fail("Some pipes were in multiple pipelines at once.")
	else
		pass("All pipes belonged to a unique pipeline.")
	return 1

/datum/unit_test/pipelines_shall_belong_to_unique_pipenets
	name = "ATMOS MACHINERY: all pipelines shall belong to a unique pipenet"

/datum/unit_test/pipelines_shall_belong_to_unique_pipenets/start_test()
	var/list/checked_pipelines = list()
	var/list/bad_pipenets = list()
	for(var/datum/pipe_network/network)
		for(var/thing in network.line_members)
			if(!checked_pipelines[thing])
				checked_pipelines[thing] = network
				continue
			LAZYDISTINCTADD(bad_pipenets[network], thing)
			LAZYDISTINCTADD(bad_pipenets[checked_pipelines[thing]], thing)

	if(length(bad_pipenets))
		fail("There were [length(bad_pipenets)] which shared at least one pipeline with another pipenet.")
	else
		pass("All pipelines belonged to a unique pipenet.")
	return 1

/datum/unit_test/atmos_machinery_shall_not_have_conflicting_connections
	name = "ATMOS MACHINERY: all mapped atmos machinery shall not have more than one connection of each type per dir."

/datum/unit_test/atmos_machinery_shall_not_have_conflicting_connections/start_test()
	var/fail = FALSE
	for(var/obj/machinery/atmospherics/machine in SSmachines.machinery)
		for(var/obj/machinery/atmospherics/M in machine.loc)
			if(M == machine)
				continue
			if(!machine.check_connect_types(M, machine))
				continue
			if(M.initialize_directions & machine.initialize_directions)
				log_bad("[log_info_line(machine)] has conflicting connections.")
				fail = TRUE

	if(fail)
		fail("Some pipes had conflicting connections.")
	else
		pass("All pipes were mapped properly.")
	return 1

/datum/unit_test/atmos_machinery_node_reciprocity
	name = "ATMOS MACHINERY: all atmos machines shall be nodes of their nodes."

/datum/unit_test/atmos_machinery_node_reciprocity/start_test()
	var/fail = FALSE
	for(var/obj/machinery/atmospherics/machine in SSmachines.machinery)
		for(var/obj/machinery/atmospherics/node AS_ANYTHING in machine.nodes_to_networks)
			if(node == machine)
				log_bad("[log_info_line(machine)] was its own node.")
				fail = TRUE
			if(!(machine in node.nodes_to_networks))
				log_bad("[log_info_line(machine)] has [log_info_line(node)] in its nodes list, but not vice versa.")
				fail = TRUE

	if(fail)
		fail("Some machines failed to have reciprocal node connections.")
	else
		pass("All machines had reciprocal node connections.")
	return 1

/datum/unit_test/atmos_machinery_construction_inheritance
	name = "ATMOS MACHINERY: all atmos machines shall deconstruct and reconstruct themselves."

/datum/unit_test/atmos_machinery_construction_inheritance/proc/check_machine(var/obj/machinery/atmospherics/machine, var/obj/item/pipe/pipe)
	. = FALSE
	if(!machine.construct_state)
		return

	var/pipe_class = machine.pipe_class
	var/rotate_class = machine.rotate_class
	var/connect_types = machine.connect_types
	var/dir = machine.dir

	if(pipe_class != pipe.pipe_class)
		log_bad("Machine of type [machine.type] had pipe with class [pipe.pipe_class]; was expecting [pipe_class].")
		. = TRUE
	if(rotate_class != pipe.rotate_class)
		log_bad("Machine of type [machine.type] had pipe with rotate class [pipe.rotate_class]; was expecting [rotate_class].")
		. = TRUE
	if(connect_types != pipe.connect_types)
		log_bad("Machine of type [machine.type] had pipe with connect type [pipe.connect_types]; was expecting [connect_types].")
		. = TRUE
	if(dir != pipe.dir)
		log_bad("Machine of type [machine.type] had pipe with dir [pipe.dir]; was expecting [dir].")
		. = TRUE

/datum/unit_test/atmos_machinery_construction_inheritance/start_test()
	var/fail = FALSE

	// make a place to test
	INCREMENT_WORLD_Z_SIZE
	for(var/turf/T in block(locate(1, 1, world.maxz), locate(3, 3, world.maxz)))
		T.ChangeTurf(/turf/simulated/floor)
	var/turf/T = locate(2, 2, world.maxz)

	// first, every spawnable machine ("mapped" behavior)
	for(var/type in subtypesof(/obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/machine = new type(T)
		var/obj/item/pipe/pipe = machine.dismantle()
		if(!istype(pipe))
			qdel(pipe)
			continue

		fail |= check_machine(machine, pipe)
		qdel(pipe)

	if(!fail)
		// then, pipes from machine datums are used to spawn machines ("player-built" behavior)
		for(var/type in subtypesof(/datum/fabricator_recipe/pipe))
			var/datum/fabricator_recipe/pipe/recipe = new type()
			var/list/stuff = recipe.build(T)
			var/obj/item/pipe/pipe = locate() in stuff
			if(pipe)
				stuff -= pipe
				var/obj/machinery/atmospherics/machine = pipe.construct_pipe(T)
				if(!istype(machine))
					qdel(machine)
				else
					fail |= check_machine(machine, pipe) // compare to a newly built machine
					qdel(machine)
			QDEL_NULL_LIST(stuff) // clean up just in case

	if(fail)
		fail("Some atmos machines failed to rebuild themselves from pipes.")
	else
		pass("All atmos machines rebuilt themselves from pipes.")
	return 1