/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	defer_initialisation = TRUE
	warmup_time = 0
	destination_tags = list(
		"nav_skipjack_start"
		)
	shuttle_area =  /area/map_template/skipjack_station/start
	dock_target = "skipjack_shuttle"
	current_location = "nav_skipjack_start"
	announcer = "Proximity Sensor Array"
	home_waypoint = "nav_skipjack_start"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."

/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Outpost"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "skipjack_base"

/obj/machinery/computer/shuttle_control/multi/raider
	name = "skipjack control console"
	initial_access = list(access_raider)
	shuttle_tag = "Skipjack"
