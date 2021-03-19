#include "heist_antag.dm"
#include "heist_outfit.dm"

/datum/map_template/ruin/antag_spawn/heist
	name = "Heist Base"
	id = "heist_spawn"
	suffixes = list("heist/heist_base.dmm")
	modify_tag_vars = FALSE
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/skipjack)
	apc_test_exempt_areas = list(
		/area/map_template/skipjack_station = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/syndicate_mothership/raider_base = NO_SCRUBBER|NO_VENT|NO_APC
	)

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

//Areas
/area/map_template/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0
	req_access = list(access_syndicate)

/area/map_template/skipjack_station/start
	name = "\improper Skipjack"
	icon_state = "yellow"
	req_access = list(access_syndicate)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/map_template/syndicate_mothership/raider_base
	name = "\improper Raider Base"
	requires_power = 0
	dynamic_lighting = FALSE
	req_access = list(access_syndicate)

/obj/machinery/computer/shuttle_control/multi/raider
	name = "skipjack control console"
	initial_access = list(access_syndicate)
	shuttle_tag = "Skipjack"
