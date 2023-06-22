/*****************
* Template Setup *
*****************/
/datum/unit_test/proximity
	template = /datum/unit_test/proximity
	var/turf/simulated/wall/wall
	var/obj/proximity_listener/proximity_listener

/datum/unit_test/proximity/New()
	name = "PROXIMITY: " + name

/datum/unit_test/proximity/setup_test()
	..()
	proximity_listener = new(get_turf(locate(/obj/abstract/landmark/proximity_spawner)))
	wall = get_turf(locate(/obj/abstract/landmark/proximity_wall))

/datum/unit_test/proximity/teardown_test()
	QDEL_NULL(proximity_listener)
	wall = null
	..()

/datum/unit_test/proximity/proc/SetWallOpacity(opacity)
	for(var/turf/simulated/wall/wall in range(7, proximity_listener))
		wall.set_opacity(opacity)

/datum/unit_test/proximity/visibility
	template = /datum/unit_test/proximity/visibility
	var/list/expected_number_of_turfs_by_trigger_type

/datum/unit_test/proximity/visibility/start_test()
	if(PROXIMITY_EXCLUDE_HOLDER_TURF != 1)
		CRASH("PROXIMITY_EXCLUDE_HOLDER_TURF no longer defined as 1")

	var/list/failures = list()
	for(var/trigger_type in subtypesof(/datum/proximity_trigger))
		var/expected_number_of_turfs = expected_number_of_turfs_by_trigger_type[trigger_type]
		if(expected_number_of_turfs <= 0)
			failures += "[trigger_type]: Did not have a valid expected number of turfs"
		else
			for(var/proximity_flag = 0 to 1) // Only valid for as long as PROXIMITY_EXCLUDE_HOLDER_TURF = 1
				var/modified_expected_number_of_turfs = expected_number_of_turfs - proximity_flag
				BeforeSetTrigger()
				proximity_listener.SetTrigger(trigger_type, proximity_flag)
				AfterSetTrigger()
				var/actual_number_of_turfs = length(proximity_listener.turfs_in_view)
				if(modified_expected_number_of_turfs != actual_number_of_turfs)
					failures += "[trigger_type] ([proximity_flag]): Expected [modified_expected_number_of_turfs] turfs in view, was [actual_number_of_turfs]"
				AfterTestRun()

	if(length(failures))
		fail("Following proximity triggers did not have the number of expected turfs:\n" + jointext(failures, "\n"))
	else
		pass("All proximity triggers had the number of expected turfs")
	return TRUE

/datum/unit_test/proximity/visibility/proc/BeforeSetTrigger()
	return

/datum/unit_test/proximity/visibility/proc/AfterSetTrigger()
	return

/datum/unit_test/proximity/visibility/proc/AfterTestRun()
	return

/*************
* Unit Tests *
*************/
/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_on_init
	name = "Shall see the number of expected turfs on init"
	expected_number_of_turfs_by_trigger_type = list(
		/datum/proximity_trigger/line = 3,
		/datum/proximity_trigger/square = 5*5,
		/datum/proximity_trigger/angle = 5*3
	)


/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_opacity_change
	name = "Shall see the number of expected turfs after opacity change"
	expected_number_of_turfs_by_trigger_type = list(
		/datum/proximity_trigger/line = 5,
		/datum/proximity_trigger/square = (5*5)+6,
		/datum/proximity_trigger/angle = (5*3)+6
	)

/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_opacity_change/AfterSetTrigger()
	var/turf/T = get_turf(locate(/obj/abstract/landmark/proximity_wall))
	T.set_opacity(FALSE)

/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_opacity_change/AfterTestRun()
	var/turf/T = get_turf(locate(/obj/abstract/landmark/proximity_wall))
	T.set_opacity(TRUE)


/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_opacity_changes
	name = "Shall see the number of expected turfs after opacity changes"
	expected_number_of_turfs_by_trigger_type = list(
		/datum/proximity_trigger/line = 5,
		/datum/proximity_trigger/square = 9*9,
		/datum/proximity_trigger/angle = 9*5
	)

/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_opacity_changes/AfterSetTrigger()
	SetWallOpacity(FALSE)

/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_opacity_changes/AfterTestRun()
	SetWallOpacity(TRUE)


/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_multiple_opacity_changes
	name = "Shall see the number of expected turfs after multiple opacity changes"
	expected_number_of_turfs_by_trigger_type = list(
		/datum/proximity_trigger/line = 3,
		/datum/proximity_trigger/square = 5*5,
		/datum/proximity_trigger/angle = 5*3
	)

/datum/unit_test/proximity/visibility/shall_see_the_number_of_expected_turfs_after_multiple_opacity_changes/AfterSetTrigger()
	SetWallOpacity(FALSE)
	SetWallOpacity(TRUE)

/**************************
* Proximity Test Listener *
**************************/
/obj/proximity_listener
	dir = SOUTH
	var/datum/proximity_trigger/trigger
	var/list/turfs_in_view

/obj/proximity_listener/Destroy()
	QDEL_NULL(trigger)
	turfs_in_view = null
	return ..()

/obj/proximity_listener/proc/SetTrigger(trigger_type, listener_flags)
	QDEL_NULL(trigger)
	trigger = new trigger_type(src, /obj/proximity_listener/proc/OnTurfEntered, /obj/proximity_listener/proc/OnTurfsChanged, 7, listener_flags, null, 90, 270)
	trigger.register_turfs()

/obj/proximity_listener/Destroy()
	QDEL_NULL(trigger)
	return ..()

/obj/proximity_listener/proc/OnTurfEntered()

/obj/proximity_listener/proc/OnTurfsChanged(var/old_turfs, var/new_turfs)
	turfs_in_view = new_turfs

/************
* Map Types *
************/
/area/test_area/proximity
	icon_state = "green"

/obj/abstract/landmark/proximity_spawner

/obj/abstract/landmark/proximity_wall