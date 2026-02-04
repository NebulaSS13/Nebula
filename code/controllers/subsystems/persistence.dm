/datum/admins/proc/force_persistence_save_verb()
	set name = "Force Early Level Save"
	set category = "Admin"
	set desc = "Forces an early level save run by SSpersistence."
	if(!SSpersistence)
		return
	if(UNLINT(SSpersistence._persistent_save_running))
		to_chat(usr, SPAN_WARNING("There is already a level save running. Please wait for it to finish."))
		return
	log_admin("[key_name(usr)] has started an early level save.")
	message_admins("[key_name(usr)] has started an early level save.")
	SSpersistence.start_persistent_level_save()

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = SS_INIT_SERDE
	flags = SS_NEEDS_SHUTDOWN
	wait = 60 MINUTES

	VAR_PRIVATE/const/ELEVATOR_FALL_PATH = "data/elevator_falls_tracking.txt"
	var/elevator_fall_shifts = -1 // This is snowflake, but oh well.
	var/list/tracking_values = list()
	VAR_PRIVATE/_persistent_save_running = FALSE
	var/const/save_warning_period = 30 SECONDS // How long to warn about an upcoming world save so people can get to safety, etc
	var/initial_save_skip_period // Set in Initialize()
	var/showing_warning = FALSE

/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	initial_save_skip_period = max(0, (wait - 10 MINUTES)) // Skip initial fire(), typically there's no need to save immediately after roundstart
	decls_repository.get_decls_of_subtype(/decl/persistence_handler) // Initialize()s persistence categories.

	// Begin snowflake.
	var/elevator_file = safe_file2text(ELEVATOR_FALL_PATH, FALSE)
	if(elevator_file)
		elevator_fall_shifts = text2num(elevator_file)
	else
		elevator_fall_shifts = initial(elevator_fall_shifts)
	if(isnull(elevator_fall_shifts))
		elevator_fall_shifts = initial(elevator_fall_shifts)
	elevator_fall_shifts++
	// End snowflake.

/datum/controller/subsystem/persistence/Shutdown()
	var/list/all_persistence_datums = decls_repository.get_decls_of_subtype(/decl/persistence_handler)
	for(var/thing in all_persistence_datums)
		var/decl/persistence_handler/P = all_persistence_datums[thing]
		P.Shutdown()

	// Refer to snowflake above.
	if(fexists(ELEVATOR_FALL_PATH))
		fdel(ELEVATOR_FALL_PATH)
	text2file("[elevator_fall_shifts]", ELEVATOR_FALL_PATH)

	// Handle level data shutdown.
	start_persistent_level_save()
	while(_persistent_save_running)
		sleep(1)

/datum/controller/subsystem/persistence/fire(resumed)
	if(world.time <= initial_save_skip_period)
		return
	do_save_with_warning()

/datum/controller/subsystem/persistence/proc/do_save_with_warning()
	set waitfor = FALSE
	if(showing_warning)
		return // debounce
	showing_warning = TRUE
	if(save_warning_period > 0)
		var/remaining_delay = save_warning_period
		while(remaining_delay > 10 SECONDS)
			to_world(SPAN_DANGER("World save will begin in [round(remaining_delay/10)] second\s! Prepare for a server freeze!"))
			remaining_delay -= 10 SECONDS
			sleep(10 SECONDS)
		if(remaining_delay > 0)
			to_world(SPAN_DANGER("World save will begin in [round(remaining_delay/10)] second\s! Prepare for a server freeze!"))
			sleep(remaining_delay)

	to_world(SPAN_DANGER("Starting world save!"))
	sleep(1 SECOND)
	showing_warning = FALSE
	start_persistent_level_save()
	to_world(SPAN_DANGER("Saved the world! Thank you for your patience, please go about your business."))

/datum/controller/subsystem/persistence/proc/start_persistent_level_save()
	if(_persistent_save_running)
		return // debounce
	_persistent_save_running = TRUE // used to avoid shutting down mid-write

	var/started_run = REALTIMEOFDAY
	report_progress("Starting persistent level save.")
	// TODO: suspend all subsystems while the save is running
	// TODO: prevent player input somehow?
	try
		for(var/z = 1 to length(SSmapping.levels_by_z))
			var/datum/level_data/level = SSmapping.levels_by_z[z]
			level.save_persistent_data()
	catch(var/exception/E)
		error("Exception when running persistent level save: [EXCEPTION_TEXT(E)]")
	// TODO: re-enable all subsystems
	report_progress("Persistent level save finished in [(REALTIMEOFDAY-started_run)/10] second\s.")
	_persistent_save_running = FALSE

/datum/controller/subsystem/persistence/proc/track_value(var/atom/value, var/track_type)

	var/decl/persistence_handler/handler = RESOLVE_TO_DECL(track_type)
	if(!istype(handler))
		return FALSE

	var/turf/T = get_turf(value)
	if(!T)
		return

	var/area/A = get_area(T)
	if(handler.area_restricted && (!A || (A.area_flags & AREA_FLAG_NO_LEGACY_PERSISTENCE)))
		return

	if(handler.station_restricted && (!T || !(T.z in SSmapping.station_levels) ))
		return FALSE

	var/datum/level_data/level = SSmapping.levels_by_z[T.z]
	if(!istype(level) || !level.permit_legacy_persistence)
		return

	if(!tracking_values[track_type])
		tracking_values[track_type] = list()
	tracking_values[track_type] |= value

/datum/controller/subsystem/persistence/proc/is_tracking(var/atom/value, var/track_type)
	. = (value in tracking_values[track_type])

/datum/controller/subsystem/persistence/proc/forget_value(var/atom/value, var/track_type)
	if(tracking_values[track_type])
		tracking_values[track_type] -= value

/datum/controller/subsystem/persistence/proc/show_info(var/mob/user)

	if(!check_rights(R_INVESTIGATE, C = user))
		return

	var/list/dat = list("<table width = '100%'>")
	var/can_modify = check_rights(R_ADMIN, 0, user)
	var/list/all_persistence_datums = decls_repository.get_decls_of_subtype(/decl/persistence_handler)
	for(var/thing in all_persistence_datums)
		var/decl/persistence_handler/P = all_persistence_datums[thing]
		if(P.has_admin_data)
			dat += P.GetAdminSummary(user, can_modify)
	dat += "</table>"

	var/datum/browser/popup = new(user, "admin_persistence", "Persistence Data")
	popup.set_content(jointext(dat, null))
	popup.open()
