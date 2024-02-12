/*
 *
 *  Zas Unit Tests.
 *  Shuttle Pressurized.
 *
 *
 */

//
// Generic check for an area.
//

/datum/unit_test/zas_area_test
	name = "ZAS: Area Test Template"
	template = /datum/unit_test/zas_area_test
	var/area_path = null                    // Put the area you are testing here.
	var/expectation = UT_NORMAL             // See defines above.

/datum/unit_test/zas_area_test/start_test()
	var/list/test = test_air_in_area(area_path, expectation)

	if(isnull(test))
		fail("Check Runtimed")

	switch(test["result"])
		if(SUCCESS) pass(test["msg"])
		if(SKIP)    skip(test["msg"])
		else        fail(test["msg"])
	return 1

// ==================================================================================================

//
//	The primary helper proc.
//
/proc/test_air_in_area(var/test_area, var/expectation = UT_NORMAL)
	var/test_result = list("result" = FAILURE, "msg"    = "")

	var/area/A = locate(test_area)

	// BYOND creates an instance of every area, so this can't be !A or !istype(A, test_area)
	if(!(A.x || A.y || A.z))
		test_result["msg"] = "Unable to get [test_area]"
		test_result["result"] = FAILURE
		return test_result

	var/list/GM_checked = list()

	for(var/turf/T in A)

		if(T.initial_gas == null)
			continue

		var/datum/gas_mixture/GM = T.return_air()
		if(!GM || (GM in GM_checked))
			continue
		GM_checked += GM

		var/t_msg = "Turf: [T] |  Location: [T.x] // [T.y] // [T.z]"
		var/pressure = GM.return_pressure()
		var/temp = GM.temperature

		switch(expectation)

			if(UT_VACUUM)
				if(pressure > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result

			if(UT_NORMAL, UT_NORMAL_COLD)
				if(abs(pressure - ONE_ATMOSPHERE) > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result

				if(expectation == UT_NORMAL)

					if(abs(temp - T20C) > 10)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

				if(expectation == UT_NORMAL_COLD)

					if(temp > 120)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

	if(GM_checked.len)
		test_result["result"] = SUCCESS
		test_result["msg"] = "Checked [GM_checked.len] gasmixes."
	else
		test_result["msg"] = "No gasmixes checked."

	return test_result


// ==================================================================================================


/// Here we move a shuttle then test it's area once the shuttle has arrived.
/datum/unit_test/zas_supply_shuttle_moved
	name  = "ZAS: Supply Shuttle (When Moved)"
	async = TRUE // We're moving the shuttle using built in procs.

	///The shuttle datum of the supply shuttle
	var/datum/shuttle/autodock/ferry/supply/shuttle = null
	///The shuttle movetime initially set for the cargo shuttle, so we can restore it
	var/initial_movetime
	///The starting waypoint of the shuttle
	var/obj/effect/shuttle_landmark/shuttle_start
	///The destination waypoint of the shuttle
	var/obj/effect/shuttle_landmark/shuttle_destination

/datum/unit_test/zas_supply_shuttle_moved/subsystems_to_await()
	return list(SSair, SStimer, SSmachines, SSsupply, SSshuttle)

/datum/unit_test/zas_supply_shuttle_moved/start_test()

	if(!SSshuttle)
		fail("Shuttle Controller not setup at time of test.")
		return 1
	if(length(SSshuttle.shuttles) <= 0)
		skip("No shuttles have been setup for this map.")
		return 1
	if(!SSsupply.shuttle)
		skip("This map has no supply shuttle.")
		return 1
	shuttle = SSsupply.shuttle

	//This test is only valid if the shuttle still works this way
	ASSERT(shuttle.location == 0 || shuttle.location == 1)

	//Setup our variables
	initial_movetime    = SSsupply.movetime
	SSsupply.movetime   = 5 // Speed up the shuttle movement.
	shuttle_start       = shuttle.get_location_waypoint(shuttle.location)
	shuttle_destination = shuttle.get_location_waypoint(!shuttle.location)

	// Initiate the Move.
	shuttle.short_jump(shuttle_destination)
	return 1

/datum/unit_test/zas_supply_shuttle_moved/check_result()
	if(shuttle.moving_status == SHUTTLE_INTRANSIT || shuttle.moving_status == SHUTTLE_WARMUP)
		return 0 //Return 0 to keep checking async

	testing("Supply shuttle is now idle.")

	//Check if we moved
	if(shuttle.current_location == shuttle_start)
		fail("Shuttle Did not Move")
		return 1

	//Do the air zone test
	for(var/area/A in shuttle.shuttle_area)
		var/list/test = test_air_in_area(A.type, global.using_map.shuttle_atmos_expectation)
		if(isnull(test))
			fail("Check Runtimed")
			return 1

		switch(test["result"])
			if(SUCCESS) pass(test["msg"])
			if(SKIP)    skip(test["msg"])
			else        fail(test["msg"])
	return 1

/datum/unit_test/zas_supply_shuttle_moved/teardown_test()
	//Restore shuttle movetime for any following tests
	SSsupply.movetime = initial_movetime
	return ..()