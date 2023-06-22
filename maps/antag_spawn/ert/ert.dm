/datum/map_template/ruin/antag_spawn/ert
	name = "ERT Base"
	suffixes = list("ert/ert_base.dmm")
	modify_tag_vars = FALSE
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/rescue)
	apc_test_exempt_areas = list(
		/area/map_template/rescue_base = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/machinery/network/telecomms_hub/ert
	req_access = list(access_cent_specops)
	initial_network_id = "responsenet"
	channels = list(
		COMMON_FREQUENCY_DATA,
		list(
			"name" = "Response",
			"key" = "t",
			"frequency" = 1345,
			"color" = COMMS_COLOR_CENTCOMM,
			"span_class" = ".centradio",
			"secured" = access_cent_specops
		)
	)

/datum/shuttle/autodock/multi/antag/rescue
	name = "Rescue"
	warmup_time = 0
	defer_initialisation = TRUE
	destination_tags = list(
		"nav_ert_start"
		)
	shuttle_area = /area/map_template/rescue_base/start
	dock_target = "ert_rescue_shuttle"
	current_location = "nav_ert_start"
	home_waypoint = "nav_ert_start"
	announcer = "Proximity Sensor Array"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."

/obj/effect/shuttle_landmark/ert/start
	name = "Response Team Base"
	landmark_tag = "nav_ert_start"
	docking_controller = "ert_rescue_base"

// Areas

/area/map_template/rescue_base
	name = "\improper Response Team Base"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = TRUE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/map_template/rescue_base/base
	name = "\improper Barracks"
	icon_state = "yellow"
	dynamic_lighting = FALSE

/area/map_template/rescue_base/start
	name = "\improper Response Team Base"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/rescue_base