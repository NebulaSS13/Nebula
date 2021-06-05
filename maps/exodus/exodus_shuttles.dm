#define ESCAPE_POD(NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/pod##NUMBER { \
	shuttle_area = /area/shuttle/escape_pod_##NUMBER; \
	name = "Escape Pod " + #NUMBER; \
	dock_target = "escape_pod_" + #NUMBER; \
	arming_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	waypoint_station = "escape_pod_"+ #NUMBER +"_start"; \
	landmark_transition = "escape_pod_"+ #NUMBER +"_transit"; \
	waypoint_offsite = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/start/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_start"; \
	docking_controller = "escape_pod_"+ #NUMBER +"_berth"; \
} \
/obj/effect/shuttle_landmark/escape_pod/transit/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_transit"; \
} \
/obj/effect/shuttle_landmark/escape_pod/out/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_out"; \
} \
/area/shuttle/escape_pod_##NUMBER { \
	name = "Escape Pod " + #NUMBER; \
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT; \
}

ESCAPE_POD(1)
ESCAPE_POD(2)
ESCAPE_POD(3)
ESCAPE_POD(4)

/obj/machinery/computer/shuttle_control/explore/research
	name = "research pod control console"
	shuttle_tag = "Research Pod"
/datum/shuttle/autodock/overmap/research
	name = "Research Pod"
	shuttle_area = /area/ship/exodus_pod_research
	dock_target = "research_shuttle"
	current_location = "nav_exodus_research_pod_dock"
/area/ship/exodus_pod_research
	name = "Research Pod"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
/obj/effect/overmap/visitable/ship/landable/pod/research
	name = "Exodus Research Pod"
	shuttle = "Research Pod"
/obj/effect/shuttle_landmark/research_pod_dock
	name = "Research Docking Port"
	landmark_tag = "nav_exodus_research_pod_dock"
	docking_controller = "research_dock_airlock"

/obj/machinery/computer/shuttle_control/explore/mining
	name = "mining pod control console"
	shuttle_tag = "Mining Pod"
/datum/shuttle/autodock/overmap/mining
	name = "Mining Pod"
	shuttle_area = /area/ship/exodus_pod_mining
	dock_target = "mining_shuttle"
	current_location = "nav_exodus_mining_pod_dock"
/area/ship/exodus_pod_mining
	name = "Mining Pod"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
/obj/effect/overmap/visitable/ship/landable/pod/mining
	name = "Exodus Mining Pod"
	shuttle = "Mining Pod"
/obj/effect/shuttle_landmark/mining_pod_dock
	name = "Mining Docking Port"
	landmark_tag = "nav_exodus_mining_pod_dock"
	docking_controller = "mining_dock_airlock"

/obj/machinery/computer/shuttle_control/explore/engineering
	name = "engineering pod control console"
	shuttle_tag = "Engineering Pod"
/datum/shuttle/autodock/overmap/engineering
	name = "Engineering Pod"
	shuttle_area = /area/ship/exodus_pod_engineering
	dock_target = "engineering_shuttle"
	current_location = "nav_exodus_engineering_pod_dock"
/area/ship/exodus_pod_engineering
	name = "Engineering Pod"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
/obj/effect/overmap/visitable/ship/landable/pod/engineering
	name = "Exodus Engineering Pod"
	shuttle = "Engineering Pod"
/obj/effect/shuttle_landmark/engineering_pod_dock
	name = "Engineering Docking Port"
	landmark_tag = "nav_exodus_engineering_pod_dock"
	docking_controller = "engineering_dock_airlock"

/datum/shuttle/autodock/ferry/emergency/escape_shuttle
	name = "Escape Shuttle"
	warmup_time = 10
	location = 1
	dock_target = "escape_shuttle"
	shuttle_area = /area/shuttle/escape_shuttle
	waypoint_offsite = "nav_escape_shuttle_start"
	waypoint_station = "nav_escape_shuttle_station"
	landmark_transition = "nav_escape_shuttle_transit"

/obj/effect/shuttle_landmark/escape_shuttle/start
	landmark_tag = "nav_escape_shuttle_start"
	docking_controller = "centcom_escape_dock"

/obj/effect/shuttle_landmark/escape_shuttle/transit
	landmark_tag = "nav_escape_shuttle_transit"

/obj/effect/shuttle_landmark/escape_shuttle/station
	landmark_tag = "nav_escape_shuttle_station"
	docking_controller = "escape_dock"

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

