/obj/machinery/computer/shuttle_control/explore/tradeship
	name = "exploration shuttle console"
	shuttle_tag = "Bee Shuttle"

/obj/machinery/computer/shuttle_control/explore/rescue
	name = "rescue shuttle console"
	shuttle_tag = "Rescue Shuttle"

/datum/shuttle/autodock/overmap/exploration
	name = "Bee Shuttle"
	shuttle_area = list(/area/ship/trade/shuttle/outgoing/general, /area/ship/trade/shuttle/outgoing/engineering)
	dock_target = "bee_star"
	current_location = "nav_tradeship_port_dock_shuttle"

/datum/shuttle/autodock/overmap/rescue
	name = "Rescue Shuttle"
	shuttle_area = /area/ship/trade/shuttle/rescue
	dock_target = "tradeship_rescue_shuttle"
	current_location = "nav_tradeship_starboard_dock_rescue"

//In case multiple shuttles can dock at a location,
//subtypes can be used to hold the shuttle-specific data
/obj/effect/shuttle_landmark/docking_arm_starboard
	name = "Tradeship Starboard-side Docking Arm"
	docking_controller = "tradeship_starboard_dock"
	flags = SLANDMARK_FLAG_REORIENT

/obj/effect/shuttle_landmark/docking_arm_starboard/rescue
	landmark_tag = "nav_tradeship_starboard_dock_rescue"

/obj/effect/shuttle_landmark/docking_arm_port
	name = "Tradeship Port-side Docking Arm"
	docking_controller = "tradeship_dock_port"
	flags = SLANDMARK_FLAG_REORIENT

/obj/effect/shuttle_landmark/docking_arm_port/shuttle
	landmark_tag = "nav_tradeship_port_dock_shuttle"

/obj/effect/shuttle_landmark/below_deck_bow
	name = "Near CSV Tradeship Bow"
	landmark_tag = "nav_tradeship_below_bow"

/obj/effect/shuttle_landmark/below_deck_starboardastern
	name = "Near CSV Tradeship Starboard Astern"
	landmark_tag = "nav_tradeship_below_starboardastern"
