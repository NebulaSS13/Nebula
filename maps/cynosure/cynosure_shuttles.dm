#define ESCAPE_POD(NAME, ID) \
/datum/shuttle/autodock/ferry/escape_pod/pod_##ID { \
	shuttle_area = /area/shuttle/escape_pod_##ID; \
	name = "Escape Pod " + #NAME; \
	dock_target = "escape_pod_" + #ID; \
	arming_controller = "escape_pod_"+ #ID +"_berth"; \
	waypoint_station = "escape_pod_"+ #ID +"_start"; \
	landmark_transition = "escape_pod_"+ #ID +"_transit"; \
	waypoint_offsite = "escape_pod_"+ #ID +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/start/pod_##ID { \
	landmark_tag = "escape_pod_"+ #ID +"_start"; \
	docking_controller = "escape_pod_"+ #ID +"_berth"; \
} \
/obj/effect/shuttle_landmark/escape_pod/transit/pod_##ID { \
	landmark_tag = "escape_pod_"+ #ID +"_transit"; \
} \
/obj/effect/shuttle_landmark/escape_pod/out/pod_##ID { \
	landmark_tag = "escape_pod_"+ #ID +"_out"; \
} \
/area/shuttle/escape_pod_##ID { \
	name = "Escape Pod " + #NAME; \
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED | AREA_FLAG_NO_LEGACY_PERSISTENCE; \
}

ESCAPE_POD("A", cynosure_a)
ESCAPE_POD("B", cynosure_b)

/obj/effect/shuttle_landmark/cynosure
	abstract_type = /obj/effect/shuttle_landmark/cynosure

// Cynosure Shuttles
// Supply shuttle
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	location = 1
	warmup_time = 10
	move_time = 120
	shuttle_area = /area/shuttle/cynosure/supply_shuttle
	dock_target = "supply_shuttle"
	waypoint_offsite = "supply_offsite"
	waypoint_station = "supply_station"
	//landmark_transition
	ceiling_type = /turf/floor/reinforced
	flags = SHUTTLE_FLAGS_PROCESS | SHUTTLE_FLAGS_SUPPLY | SHUTTLE_FLAGS_NO_CODE

/obj/effect/shuttle_landmark/cynosure/supply_offsite
	name = "Centcom Supply Depot"
	landmark_tag = "supply_offsite"
	base_area = /area/centcom/command
	base_turf = /turf/floor

/obj/effect/shuttle_landmark/cynosure/supply_station
	name = "Station"
	landmark_tag = "supply_station"
	docking_controller = "cargo_bay"
	base_area = /area/surface/outside/plains/station
	base_turf = /turf/floor/tiled/steel_grid


// Emergency shuttle
/datum/shuttle/autodock/ferry/emergency/escape_shuttle
	name = "Escape Shuttle"
	warmup_time = 10
	location = 1
	dock_target = "escape_shuttle"
	shuttle_area = /area/shuttle/cynosure/escape_shuttle
	waypoint_offsite = "escape_shuttle_start"
	waypoint_station = "escape_shuttle_station"
	landmark_transition = "escape_shuttle_transit"
	flags = SHUTTLE_FLAGS_PROCESS | SHUTTLE_FLAGS_NO_CODE

/obj/effect/shuttle_landmark/cynosure/escape_shuttle/start
	landmark_tag = "escape_shuttle_start"
	docking_controller = "centcom_escape_dock"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/cynosure/escape_shuttle/transit
	landmark_tag = "escape_shuttle_transit"

/obj/effect/shuttle_landmark/cynosure/escape_shuttle/station
	landmark_tag = "escape_shuttle_station"
	docking_controller = "cynosure_escape_shuttle"
	base_area = /area/surface/outside/plains/station
	base_turf = /turf/floor/concrete

//Cynosure Station Docks
/obj/effect/shuttle_landmark/cynosure/pads
	abstract_type = /obj/effect/shuttle_landmark/cynosure/pads
	base_turf = /turf/floor/concrete

/obj/effect/shuttle_landmark/cynosure/pads/pad3
	name = "Shuttle Pad Three"
	landmark_tag = "nav_pad3_cynosure"
	docking_controller = "pad3"
	base_area = /area/surface/outside/station/shuttle/pad3

/obj/effect/shuttle_landmark/cynosure/pads/pad4
	name = "Shuttle Pad Four"
	landmark_tag = "nav_pad4_cynosure"
	docking_controller = "pad4"
	base_area = /area/surface/outside/station/shuttle/pad4

/obj/effect/shuttle_landmark/cynosure/pads/perimeter
	name = "Cynosure Perimeter"
	landmark_tag = "nav_perimeter_cynosure"
	docking_controller = "pad4"
	base_area = /area/surface/outside/plains/station
	base_turf = /turf/floor/dirt

//Wilderness
/obj/effect/shuttle_landmark/cynosure/wilderness
	name = "Wilderness"
	landmark_tag = "nav_wilderness"
	base_area = /area/surface/outside/wilderness/deep
	base_turf = /turf/floor/dirt

// Explorer Shuttle
/datum/shuttle/autodock/overmap/explorer_shuttle
	name = "NTC Calvera"
	warmup_time = 0
	current_location = "nav_pad4_cynosure"
	dock_target = "expshuttle_docker"
	shuttle_area = list(/area/shuttle/exploration/general, /area/shuttle/exploration/cockpit, /area/shuttle/exploration/cargo)
	fuel_consumption = 3
	ceiling_type = /turf/floor/reinforced

/obj/effect/overmap/visitable/ship/landable/explorer_shuttle
	name = "NTC Calvera"
	desc = "The exploration team's shuttle."
	desc = "A Wulf Vagabond-class short-range expedition shuttle. It is broadcasting NanoTrasen identification codes: VIR-472-320377 - NTC Calvera."
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "NTC Calvera"
	icon_state = "calvera"
	moving_state = "calvera_moving"

/obj/machinery/computer/shuttle_control/explore/explorer_shuttle
	name = "takeoff and landing console"
	shuttle_tag = "NTC Calvera"
	req_access = list(access_explorer)

/datum/shuttle/autodock/ferry/arrivals
	name = "Arrivals"
	warmup_time = 10
	location = 1
	shuttle_area = /area/shuttle/cynosure/arrival
	waypoint_offsite = "arrivals_offsite"
	waypoint_station = "arrivals_station"
	dock_target = "cynosure_arrivals_shuttle"
	ceiling_type = /turf/floor/reinforced
	always_process = TRUE
	flags = SHUTTLE_FLAGS_PROCESS | SHUTTLE_FLAGS_NO_CODE

	var/launch_delay = 3
	var/started_launch_time
	var/launch_warning_stage

/obj/machinery/computer/shuttle_control/arrivals
	name = "shuttle control console"
	req_access = list(access_cent_general)
	shuttle_tag = "Arrivals"

// This proc checks if a player is on the shuttle.
/datum/shuttle/autodock/ferry/arrivals/proc/check_for_passengers()
	for(var/client/C)
		if(!isliving(C.mob) || C.mob.stat == DEAD)
			continue
		var/area/mob_area = get_area(C.mob)
		if(!istype(mob_area))
			continue
		// I don't know how much of this is actually needed.
		if(ispath(shuttle_area) && istype(mob_area, shuttle_area))
			return TRUE
		else if(istype(shuttle_area, /area) && mob_area == shuttle_area)
			return TRUE
		else if(islist(shuttle_area) && ((mob_area in shuttle_area) || (mob_area.type in shuttle_area)))
			return TRUE
	return FALSE

// This is to stop the shuttle if someone tries to stow away when its leaving.
/datum/shuttle/autodock/ferry/arrivals/post_warmup_checks()
	return (location || !check_for_passengers())

/datum/shuttle/autodock/ferry/arrivals/Process()

	if(process_state != IDLE_STATE)
		return ..()

	if(location)
		if(isnull(launch_warning_stage))
			if(check_for_passengers()) // No point arriving with an empty shuttle.
				warmup_time = initial(warmup_time)
				started_launch_time = world.time
				launch_warning_stage = 0
		else
			var/progress_time = world.time - started_launch_time
			if(progress_time > 0)
				switch(launch_warning_stage)
					if(0)
						message_passengers(SPAN_NOTICE("Arriving at [using_map.station_name] in thirty seconds..."))
						launch_warning_stage = 1
					if(1)
						if(progress_time >= 10 SECONDS)
							message_passengers(SPAN_NOTICE("Arriving at [using_map.station_name] in twenty seconds."))
							launch_warning_stage = 2
					if(2)
						if(progress_time >= 20 SECONDS)
							message_passengers(SPAN_NOTICE("Arriving at [using_map.station_name] in ten seconds. Please buckle up!"))
							launch_warning_stage = 3
					else
						if(progress_time >= 30 SECONDS)
							if(!can_launch())
								message_passengers(SPAN_NOTICE("Shuttle arrival has been delayed. Please wait for this shuttle to re-route."))
							else
								launch()
							launch_warning_stage = null
		return..()

	// We are at the station.
	if(check_for_passengers()) // Don't leave with anyone.
		return ..()

	if(launch_delay) // Give some time to get on the docks so people don't get trapped inbetween the dock airlocks.
		launch_delay--
	else
		launch_delay = initial(launch_delay)
		warmup_time = 0 // Gotta go fast.
		launch()

	return ..() // Do everything else

/obj/effect/shuttle_landmark/cynosure/arrivals_offsite
	name = "Transit to Station"
	landmark_tag = "arrivals_offsite"
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/cynosure/arrivals_station
	name = "Cynosure Arrivals Pad"
	landmark_tag = "arrivals_station"
	docking_controller = "cynosure_arrivals_shuttle_dock"
	base_area = /area/surface/outside/station/shuttle/pad2
	base_turf = /turf/floor/concrete
