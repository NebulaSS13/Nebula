/obj/effect/shuttle_landmark/lower_level
	name = "Lower Level Dock"
	landmark_tag = "nav_example_station"
	docking_controller = "lower_level_dock"
	special_dock_targets = list(
		"Example" = "example_shuttle_starboard"
	)

/obj/effect/shuttle_landmark/upper_level
	name = "Upper Level Dock"
	landmark_tag = "nav_example_offsite"
	docking_controller = "upper_level_dock"
	special_dock_targets = list(
		"Example" = "example_shuttle_port"
	)

/datum/shuttle/autodock/ferry/example
	name = "Example"
	shuttle_area = /area/shuttle/escape
	dock_target = "example_shuttle_starboard"
	warmup_time = 10

	location = 0
	waypoint_station = "nav_example_station"
	waypoint_offsite = "nav_example_offsite"

/obj/turbolift_map_holder/example
	name = "Example elevator placeholder"
	icon = 'icons/obj/turbolift_preview_nowalls_3x3.dmi'
	depth = 3
	lift_size_x = 2
	lift_size_y = 2
	door_type =     null
	wall_type =     null
	firedoor_type = null
	light_type =    null
	floor_type =  /turf/simulated/floor/tiled/techfloor
	button_type = /obj/structure/lift/button/standalone
	panel_type =  /obj/structure/lift/panel/standalone
	areas_to_use = list(
		/area/turbolift/first,
		/area/turbolift/second,
		/area/turbolift/third
	)
	floor_departure_sound = 'sound/effects/lift_heavy_start.ogg'
	floor_arrival_sound =   'sound/effects/lift_heavy_stop.ogg'
