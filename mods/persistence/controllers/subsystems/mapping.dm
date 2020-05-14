/datum/controller/subsystem/mapping
	var/using_save = FALSE // Whether or not we're using a persistence save.


/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
	// Build the list of static persisted levels from our map.
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading saved map")
#else
	report_progress("Loading world save.")
	using_save = TRUE
	SSpersistence.LoadWorld()
#endif

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()