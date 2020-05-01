/datum/controller/subsystem/mapping
	var/datum/persistence/world_handle/persistence = new()
	var/list/saved_levels = list()
	var/using_save = FALSE // Whether or not we're using a persistence save.

/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
	// Build the list of static persisted levels from our map.
	saved_levels = GLOB.using_map.saved_levels
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading saved map")
#else
	report_progress("Loading world save.")
	using_save = TRUE
	persistence.LoadWorld()
#endif

/datum/controller/subsystem/mapping/proc/Save()
	persistence.SaveWorld()

/datum/controller/subsystem/mapping/proc/RegisterSavedLevel(var/z)
	LAZYDISTINCTADD(saved_levels, z)