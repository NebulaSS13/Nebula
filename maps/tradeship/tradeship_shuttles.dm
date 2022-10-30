/obj/machinery/computer/shuttle_control/explore/tradeship
	name = "exploration shuttle console"
	shuttle_tag = "Exploration Shuttle"

/datum/shuttle/autodock/overmap/exploration
	name = "Exploration Shuttle"
	shuttle_area = /area/ship/trade/shuttle/outgoing
	dock_target = "tradeship_shuttle"
	current_location = "nav_tradeship_port_dock_shuttle"

//In case multiple shuttles can dock at a location,
//subtypes can be used to hold the shuttle-specific data
/obj/effect/shuttle_landmark/docking_arm_starboard
	name = "Tradeship Starboard-side Docking Arm"
	docking_controller = "tradeship_starboard_dock"

/obj/effect/shuttle_landmark/docking_arm_starboard/pod
	landmark_tag = "nav_tradeship_starboard_dock_pod"

/obj/effect/shuttle_landmark/docking_arm_port
	name = "Tradeship Port-side Docking Arm"
	docking_controller = "tradeship_dock_port"

/obj/effect/shuttle_landmark/docking_arm_port/shuttle
	landmark_tag = "nav_tradeship_port_dock_shuttle"

/obj/effect/shuttle_landmark/below_deck_bow
	name = "Near CSV Tradeship Bow"
	landmark_tag = "nav_tradeship_below_bow"

/obj/effect/shuttle_landmark/below_deck_starboardastern
	name = "Near CSV Tradeship Starboard Astern"
	landmark_tag = "nav_tradeship_below_starboardastern"

// Essentially a bare platform that moves up and down.
/obj/turbolift_map_holder/tradeship
	name = "Tradeship cargo elevator placeholder"
	icon = 'icons/obj/turbolift_preview_nowalls_4x4.dmi'
	depth = 4
	lift_size_x = 3
	lift_size_y = 3
	door_type =     null
	wall_type =     null
	firedoor_type = null
	light_type =    null
	floor_type =  /turf/simulated/floor/tiled/steel_grid
	button_type = /obj/structure/lift/button/standalone
	panel_type =  /obj/structure/lift/panel/standalone
	areas_to_use = list(
		/area/turbolift/tradeship_enclave,
		/area/turbolift/tradeship_cargo,
		/area/turbolift/tradeship_upper,
		/area/turbolift/tradeship_roof
	)
	floor_departure_sound = 'sound/effects/lift_heavy_start.ogg'
	floor_arrival_sound =   'sound/effects/lift_heavy_stop.ogg'
