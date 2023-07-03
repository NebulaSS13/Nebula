/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply Shuttle"
	warmup_time = 10
	location = 1
	dock_target = "supply_shuttle"
	shuttle_area = /area/shuttle/supply_shuttle
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"

/obj/effect/shuttle_landmark/supply/start
	landmark_tag = "nav_cargo_start"
	docking_controller = "cargo_bay_centcom"

/obj/effect/shuttle_landmark/supply/station
	landmark_tag = "nav_cargo_station"
	docking_controller = "cargo_bay"
	base_area = /area/fairpoint/supply_shuttle_dock
	base_turf = /turf/simulated/floor/plating