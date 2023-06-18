#include "heist_antag.dm"
#include "heist_outfit.dm"

/datum/map_template/ruin/antag_spawn/heist
	name = "Heist Base"
	suffixes = list("heist/heist_base.dmm")
	modify_tag_vars = FALSE
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/skipjack)
	apc_test_exempt_areas = list(
		/area/map_template/skipjack_station = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/syndicate_mothership/raider_base = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/machinery/network/telecomms_hub/raider
	initial_network_id = "piratenet"
	req_access = list(access_raider)
	channels = list(
		COMMON_FREQUENCY_DATA,
		list(
			"name" = "Raider",
			"key" = "t",
			"frequency" = PUB_FREQ,
			"color" = COMMS_COLOR_SYNDICATE,
			"span_class" = CSS_CLASS_RADIO,
			"secured" = access_raider
		)
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
	req_access = list(access_raider)

/area/map_template/skipjack_station/start
	name = "\improper Skipjack"
	icon_state = "yellow"
	req_access = list(access_raider)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/map_template/syndicate_mothership/raider_base
	name = "\improper Raider Base"
	requires_power = 0
	dynamic_lighting = FALSE
	req_access = list(access_raider)

/obj/machinery/computer/shuttle_control/multi/raider
	name = "skipjack control console"
	initial_access = list(access_raider)
	shuttle_tag = "Skipjack"

/obj/structure/sign/warning/nosmoking_1/heist
	desc = "A warning sign which reads 'NO SMOKING'. Someone has scratched a variety of crude words in gutter across the entire sign."