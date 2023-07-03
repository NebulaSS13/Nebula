/obj/effect/shuttle_landmark/supply/station
	landmark_tag = "nav_cargo_station"
	docking_controller = "cargo_bay"
	base_area = /area/fairpoint/supply_shuttle_dock
	base_turf = /turf/simulated/floor/plating

//supply
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	warmup_time = 10
	location = 1
	dock_target = "supply_shuttle"
	waypoint_station = "nav_cargo_station"