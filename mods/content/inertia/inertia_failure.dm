// TODO: This should either be removed, or reworked to announce to specifically only the affected ship or its associated map.
/datum/event/inertial_damper
	announceWhen = 5
	check_proc = /proc/inertial_dampener_event_can_fire

/datum/event_container/moderate/New()
	..()
	available_events += new /datum/event_meta(
		EVENT_LEVEL_MODERATE,
		"Inertial Damper Recalibration",
		/datum/event/inertial_damper,
		75,
		list(ASSIGNMENT_ENGINEER = 25)
	)

/datum/event/inertial_damper/setup()
	endWhen = rand(45, 120)

/proc/inertial_dampener_event_can_fire() // Check if we have any ships that require dampers for this event to affect
	for(var/obj/effect/overmap/visitable/ship/ship in SSshuttle.ships)
		if(ship.needs_dampers)
			return TRUE
	return FALSE

/datum/event/inertial_damper/announce()
	command_announcement.Announce("Inertial damper calibration error. Please restrict thruster use. Recalibration cycle initiated...", "[location_name()] Inertial Damper Subsystem", zlevels = affecting_z)

/datum/event/inertial_damper/start()
	for(var/obj/machinery/inertial_damper/damper_machine in SSmachines.machinery)
		damper_machine.damping_modifier += -5 //Gm/h
		damper_machine.was_reset = FALSE

/datum/event/inertial_damper/end()
	var/display_announcement = FALSE
	for(var/obj/machinery/inertial_damper/damper_machine in SSmachines.machinery)
		damper_machine.damping_modifier = initial(damper_machine.damping_modifier)
		if(!damper_machine.was_reset)
			display_announcement = TRUE
			break

	if(display_announcement)
		command_announcement.Announce("Inertial dampers are again functioning within normal parameters. Sorry for any inconvenience.", "[location_name()] Inertial Damper Subsystem", zlevels = affecting_z)
