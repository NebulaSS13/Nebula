/obj/effect/shuttle_landmark/lower_level
	name = "Lower Level Dock"
	landmark_tag = "nav_debug_station"
	docking_controller = "lower_level_dock"
	special_dock_targets = list(
		/datum/shuttle/autodock/ferry/debug = "STARBOARD"
	)

/obj/effect/shuttle_landmark/upper_level
	name = "Upper Level Dock"
	landmark_tag = "nav_debug_offsite"
	docking_controller = "upper_level_dock"
	special_dock_targets = list(
		/datum/shuttle/autodock/ferry/debug = "PORT"
	)

/datum/shuttle/autodock/ferry/debug
	name = "Testing Site Ferry"
	shuttle_area = /area/shuttle/ferry
	dock_target = "debug_shuttle_starboard"
	warmup_time = 10

	location = 0
	waypoint_station = "nav_debug_station"
	waypoint_offsite = "nav_debug_offsite"
	docking_cues = list(
		"STARBOARD" = "debug_shuttle_starboard",
		"PORT" = "debug_shuttle_port"
	)
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/turbolift_map_holder/debug
	name = "Testing Site elevator placeholder"
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
		/area/turbolift/debug/first,
		/area/turbolift/debug/second,
		/area/turbolift/debug/third
	)
	floor_departure_sound = 'sound/effects/lift_heavy_start.ogg'
	floor_arrival_sound = 'sound/effects/lift_heavy_stop.ogg'
