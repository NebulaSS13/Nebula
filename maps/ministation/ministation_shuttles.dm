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

/obj/effect/shuttle_landmark/bridge_north
	landmark_tag = "nav_ministation_bridge_north"

/obj/effect/shuttle_landmark/arrivas_south
	landmark_tag = "nav_ministation_arrivals_south"

/obj/machinery/computer/shuttle_control/explore/ministation
	name = "science shuttle console"
	shuttle_tag = "Science Shuttle"

/datum/shuttle/autodock/overmap/science_shuttle
	name = "Science Shuttle"
	shuttle_area = /area/ministation/shuttle/outgoing
	dock_target = "science_shuttle"
	current_location = "nav_ministation_science_dock_shuttle"

/obj/effect/shuttle_landmark/science_dock
	name = "Science Department Docking Arm"
	docking_controller = "ministation_science_dock"
	landmark_tag = "nav_ministation_science_dock_shuttle"

/obj/effect/overmap/visitable/ship/landable/science_shuttle
	name = "Science Shuttle"
	shuttle = "Science Shuttle"
	moving_state = "ship_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = EAST
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL

// Essentially a bare platform that moves up and down.
/obj/abstract/turbolift_spawner/ministation
	name = "Tradestation cargo elevator placeholder"
//	icon = 'icons/obj/turbolift_preview_nowalls_3x3.dmi'
	depth = 3
	lift_size_x = 2
	lift_size_y = 2
	door_type =     null
	wall_type =     null
	firedoor_type = null
	light_type =    null
	floor_type =  /turf/floor/tiled/steel_grid
	button_type = /obj/structure/lift/button/standalone
	panel_type =  /obj/structure/lift/panel/standalone
	areas_to_use = list(
		/area/turbolift/l1,
		/area/turbolift/l2,
		/area/turbolift/l3
	)
	floor_departure_sound = 'sound/effects/lift_heavy_start.ogg'
	floor_arrival_sound =   'sound/effects/lift_heavy_stop.ogg'
