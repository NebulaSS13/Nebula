/datum/unit_test/proximity
	template = /datum/unit_test/proximity
	var/obj/proximity_listener/proximity_listener

/datum/unit_test/proximity/New()
	name = "PROXIMITY: " + name
	proximity_listener = new(get_turf(locate(/obj/effect/landmark/proximity_spawner)))

/datum/unit_test/proximity/conclude_test()
	QDEL_NULL(proximity_listener)

/datum/unit_test/proximity/shall_acquire_the_number_of_expected_turfs
	name = "Shall acquire the number of expected turfs"
	var/list/expected_number_of_turfs_by_trigger_type = list(
		/datum/proximity_trigger/line = 3,
		/datum/proximity_trigger/square = 25
	)

/datum/unit_test/proximity/shall_acquire_the_number_of_expected_turfs/start_test()
	var/list/failures = list()
	for(var/trigger_type in subtypesof(/datum/proximity_trigger))
		var/expected_number_of_turfs = expected_number_of_turfs_by_trigger_type[trigger_type]
		if(expected_number_of_turfs <= 0)
			failures += "[trigger_type]: Did not have a valid expected number of turfs"
		else
			for(var/proximity_flag = 0 to 1) // Only valid for as long as PROXIMITY_EXCLUDE_HOLDER_TURF = 1
				var/modified_expected_number_of_turfs = expected_number_of_turfs - proximity_flag
				proximity_listener.SetTrigger(trigger_type, proximity_flag)
				var/actual_number_of_turfs = length(proximity_listener.turfs_in_view)
				if(modified_expected_number_of_turfs != actual_number_of_turfs)
					failures += "[trigger_type] ([proximity_flag]): Expected [modified_expected_number_of_turfs] turfs in view, was [actual_number_of_turfs]"

	if(length(failures))
		fail("Following proximity triggers did not have the number of expected turfs:\n" + jointext(failures, "\n"))
	else
		pass("All proximity triggers had the number of expected turfs")
	return TRUE

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
	trigger = new trigger_type(src, /obj/proximity_listener/proc/OnTurfEntered, /obj/proximity_listener/proc/OnTurfsChanged, 7, listener_flags)
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

/obj/effect/landmark/proximity_spawner
