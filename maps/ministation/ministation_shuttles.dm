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
	name = "Escape Pod ##NUMBER"; \
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT; \
}

ESCAPE_POD(1)

//supply
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	warmup_time = 10
	location = 1
	dock_target = "supply_shuttle"
	shuttle_area = /area/supply
	waypoint_offsite = "nav_cargo_start"
	waypoint_station = "nav_cargo_station"

/obj/effect/shuttle_landmark/supply/start
	landmark_tag ="nav_cargo_start"

/obj/effect/shuttle_landmark/supply/station
	landmark_tag = "nav_cargo_station"
	docking_controller = "cargo_bay"
	base_area = /area/ministation/supply_dock
	base_turf = /turf/space