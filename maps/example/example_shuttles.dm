/obj/effect/shuttle_landmark/lower_level
	name = "Lower Level Dock"
	landmark_tag = "nav_example_station"
	docking_controller = "lower_level_dock"
	special_dock_targets = list(
		/datum/shuttle/autodock/ferry/example = "STARBOARD"
	)

/obj/effect/shuttle_landmark/upper_level
	name = "Upper Level Dock"
	landmark_tag = "nav_example_offsite"
	docking_controller = "upper_level_dock"
	special_dock_targets = list(
		/datum/shuttle/autodock/ferry/example = "PORT"
	)

/datum/shuttle/autodock/ferry/example
	name = "Testing Site Ferry"
	shuttle_area = /area/shuttle/ferry
	dock_target = "example_shuttle_starboard"
	warmup_time = 10

	location = 0
	waypoint_station = "nav_example_station"
	waypoint_offsite = "nav_example_offsite"
	docking_cues = list(
		"STARBOARD" = "example_shuttle_starboard",
		"PORT" = "example_shuttle_port"
	)
	ceiling_type = /turf/floor/shuttle_ceiling

