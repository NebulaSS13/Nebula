/datum/unit_test/generic_shuttle_landmarks_shall_not_appear_in_restricted_list
	name = "SHUTTLE: Generic shuttle landmarks shall not appear in the restricted landmark list."

/datum/unit_test/generic_shuttle_landmarks_shall_not_appear_in_restricted_list/start_test()
	var/fail = FALSE

	for(var/sz in global.overmap_sectors)
		var/obj/effect/overmap/visitable/sector = global.overmap_sectors[sz]
		if(!istype(sector))
			continue
		var/list/failures = list()
		for(var/generic in sector.initial_generic_waypoints)
			for(var/shuttle_type in sector.initial_restricted_waypoints)
				if(generic in sector.initial_restricted_waypoints[shuttle_type])
					failures += generic
					break
		if(length(failures))
			log_bad("The sector [log_info_line(sector)] has the following generic landmarks also appearing on the restricted list: [english_list(failures)]")
			fail = TRUE

	if (fail)
		fail("Some sector landmark lists were misconfigured.")
	else
		pass("All sector landmark lists were configured properly.")
	return 1

// These tests help make sure shuttles on duplicate-capable maps are set up properly. Note that:
// - You cannot set any of a /ferry or /multidock shuttle's waypoints to be on other templates if your template allows duplicates.
/datum/unit_test/shuttles_shall_find_all_waypoints
	name = "SHUTTLE: Shuttles shall find all of their set waypoints."

/datum/unit_test/shuttles_shall_find_all_waypoints/start_test()
	var/fail = FALSE

	for(var/shuttle_name in SSshuttle.shuttles)
		var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_name]
		var/problem = shuttle.test_landmark_setup()
		if(problem)
			log_bad("Shuttle [shuttle_name] of type [shuttle.type] had the following problem: [problem]")
			fail = TRUE

	if (fail)
		fail("Some shuttles were misconfigured.")
	else
		pass("All shuttles were properly configured.")
	return 1

/datum/unit_test/allow_duplicate_templates_shall_use_tag_modification
	name = "SHUTTLE: All map templates allowing duplicate spawns use tag modification."

/datum/unit_test/allow_duplicate_templates_shall_use_tag_modification/start_test()
	var/list/failures = list()

	for(var/template_name in SSmapping.map_templates)
		var/datum/map_template/template = SSmapping.get_template(template_name)
		if((template.template_flags & (TEMPLATE_FLAG_ALLOW_DUPLICATES | TEMPLATE_FLAG_TEST_DUPLICATES)) && !template.modify_tag_vars)
			failures += template_name
	if (length(failures))
		fail("The following templates were misconfigured: [english_list(failures)].")
	else
		pass("All templates were properly configured.")
	return 1