//supply
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	warmup_time = 10
	location = 1
	dock_target = "supply_shuttle"
	shuttle_area = /area/ministation/supply
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"

/obj/effect/shuttle_landmark/supply/start
	landmark_tag ="nav_cargo_start"

/obj/effect/shuttle_landmark/supply/station
	landmark_tag = "nav_cargo_station"
	docking_controller = "cargo_bay"
	base_area = /area/ministation/supply_dock
	base_turf = /turf/space

/datum/shuttle/autodock/ferry/emergency/escape_shuttle
	name = "Escape Shuttle"
	warmup_time = 10
	location = 1
	dock_target = "shuttle1"
	shuttle_area = /area/shuttle/escape_shuttle
	waypoint_offsite = "nav_escape_shuttle_start"
	waypoint_station = "nav_escape_shuttle_station"
	landmark_transition = "nav_escape_shuttle_transit"

/obj/effect/shuttle_landmark/escape_shuttle/start
	landmark_tag = "nav_escape_shuttle_start"
	//docking_controller = "centcom_escape_dock"

/obj/effect/shuttle_landmark/escape_shuttle/transit
	landmark_tag = "nav_escape_shuttle_transit"

/obj/effect/shuttle_landmark/escape_shuttle/station
	landmark_tag = "nav_escape_shuttle_station"
	docking_controller = "station1"
