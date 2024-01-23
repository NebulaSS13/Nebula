/*******************
* Unit Test Runner *
*******************/
SUBSYSTEM_DEF(unit_tests)
	name = "Unit Tests"
	wait = 2 SECONDS
	init_order = SS_INIT_UNIT_TESTS
	runlevels = (RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY)
	var/list/queue = list()
	var/list/async_tests = list()
	var/list/current_async
	var/stage = 1
	var/end_unit_tests

	var/static/list/skipped_template_categories = list(
		MAP_TEMPLATE_CATEGORY_AWAYSITE,
		MAP_TEMPLATE_CATEGORY_PLANET,
		MAP_TEMPLATE_CATEGORY_EXOPLANET,
		MAP_TEMPLATE_CATEGORY_LANDMARK_LOADED
	)

/datum/controller/subsystem/unit_tests/Initialize(timeofday)

	#ifndef UNIT_TEST_COLOURED
	if(world.system_type != UNIX) // Not a Unix/Linux/etc system, we probably don't want to print color escapes (unless UNIT_TEST_COLOURED was defined to force escapes)
		ascii_esc = ""
		ascii_red = ""
		ascii_green = ""
		ascii_yellow = ""
		ascii_reset = ""
	#endif
	log_unit_test("Initializing Unit Testing")

	// Load Map Templates
	load_map_templates()

	//
	//Start the Round.
	//
	SSticker.master_mode = "extended"
	for(var/test_datum_type in get_test_datums())
		queue += new test_datum_type
	sortTim(queue, /proc/cmp_unit_test_priority)
	log_unit_test("[queue.len] unit tests loaded.")
	. = ..()

///Returns whether a template should be loaded for all unit tests or if it's tested in a specific unit test on its own.
/datum/controller/subsystem/unit_tests/proc/is_tested_separately(var/datum/map_template/map_template)
	for(var/cat in map_template.template_categories)
		if(cat in skipped_template_categories)
			return TRUE
	return FALSE

/datum/controller/subsystem/unit_tests/proc/load_map_templates()
	for(var/map_template_name in SSmapping.map_templates)
		var/datum/map_template/map_template = SSmapping.get_template(map_template_name)
		// Away sites are supposed to be tested separately in the Away Site environment
		if(is_tested_separately(map_template))
			report_progress("Skipping template '[map_template]' ([map_template.type]): Is tested separately.")
			continue
		if(map_template.is_runtime_generated())
			report_progress("Skipping template '[map_template]' ([map_template.type]): Is generated at runtime.")
			continue
		load_template(map_template)
		if(map_template.template_flags & TEMPLATE_FLAG_TEST_DUPLICATES)
			load_template(map_template)
	log_unit_test("Map Templates Loaded")

/datum/controller/subsystem/unit_tests/proc/load_template(datum/map_template/map_template)
	// Suggestion: Do smart things here to squeeze as many templates as possible into the same Z-level
	if(map_template.tallness == 1)
		SSmapping.increment_world_z_size(/datum/level_data/unit_test)
		var/turf/center = WORLD_CENTER_TURF(world.maxz)
		if(!center)
			CRASH("'[map_template]' (size: [map_template.width]x[map_template.height]) couldn't locate center turf at ([WORLD_CENTER_X][WORLD_CENTER_Y][world.maxz]) with world size ([WORLD_SIZE_TO_STRING])")
		log_unit_test("Loading template '[map_template]' ([map_template.type]) at [log_info_line(center)]")
		map_template.load(center, centered = TRUE)
	else // Multi-Z templates are loaded using different means
		log_unit_test("Loading template '[map_template]' ([map_template.type]) at Z-level [world.maxz+1] with a tallness of [map_template.tallness]")
		map_template.load_new_z()

/datum/controller/subsystem/unit_tests/proc/start_game()
	if (GAME_STATE >= RUNLEVEL_POSTGAME)
		log_unit_test("Unable to start testing - game is finished!")
		del world
		return

	if ((GAME_STATE == RUNLEVEL_LOBBY) && !SSticker.start_now())
		log_unit_test("Unable to start testing - SSticker failed to start the game!")
		del world
		return

	stage++
	log_unit_test("Game start has been requested.")

/datum/controller/subsystem/unit_tests/proc/await_game_running()
	if(GAME_STATE == RUNLEVEL_GAME)
		log_unit_test("The game is now in progress.")
		stage++

/datum/controller/subsystem/unit_tests/proc/handle_tests()
	var/list/curr = queue
	while (curr.len)
		var/datum/unit_test/test = curr[curr.len]
		curr.len--
		if(test.async)
			async_tests += test
		else
			do_unit_test(test, end_unit_tests)
		total_unit_tests++
		if (MC_TICK_CHECK)
			return

	// Once we have dealt with all synchronous tests
	//  start all async tests and proceed to the next stage
	if (!curr.len)
		for(var/test in async_tests)
			do_unit_test(test, end_unit_tests)
		stage++

/datum/controller/subsystem/unit_tests/proc/handle_async(resumed = 0)
	if (!resumed)
		current_async = async_tests.Copy()

	var/list/async = current_async
	while (async.len)
		var/datum/unit_test/test = current_async[async.len]
		for(var/S in test.subsystems_to_await())
			var/datum/controller/subsystem/subsystem = S
			if(subsystem.times_fired <= test.times_fired_at_setup[subsystem])
				return
		async.len--
		if(check_unit_test(test, end_unit_tests))
			async_tests -= test
			test.teardown_test()
		if (MC_TICK_CHECK)
			return
	if (!async_tests.len)
		stage++

/datum/controller/subsystem/unit_tests/fire(resumed = 0)
	switch (stage)
		if (1)
			start_game()

		if (2)	// wait a moment
			await_game_running()

		if (3)
			stage++
			log_unit_test("Testing Started.")
			end_unit_tests = world.time + MAX_UNIT_TEST_RUN_TIME

		if (4)	// do normal tests
			handle_tests()

		if (5) // do async tests
			handle_async(resumed)

		if (6)	// Finalization.
			unit_test_final_message()
			log_unit_test("Caught [global.total_runtimes] Runtime\s.")
			del world

