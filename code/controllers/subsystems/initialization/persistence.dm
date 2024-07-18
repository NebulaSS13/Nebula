SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE | SS_NEEDS_SHUTDOWN

	var/elevator_fall_path = "data/elevator_falls_tracking.txt"
	var/elevator_fall_shifts = -1 // This is snowflake, but oh well.
	var/list/tracking_values = list()

/datum/controller/subsystem/persistence/Initialize()
	. = ..()

	decls_repository.get_decls_of_subtype(/decl/persistence_handler) // Initialize()s persistence categories.

	// Begin snowflake.
	var/elevator_file = safe_file2text(elevator_fall_path, FALSE)
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
	if(fexists(elevator_fall_path))
		fdel(elevator_fall_path)
	text2file("[elevator_fall_shifts]", elevator_fall_path)

/datum/controller/subsystem/persistence/proc/track_value(var/atom/value, var/track_type)

	var/turf/T = get_turf(value)
	if(!T)
		return

	var/area/A = get_area(T)
	if(!A || (A.area_flags & AREA_FLAG_IS_NOT_PERSISTENT))
		return

	var/datum/level_data/level = SSmapping.levels_by_z[T.z]
	if(!istype(level) || !level.permit_persistence)
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
