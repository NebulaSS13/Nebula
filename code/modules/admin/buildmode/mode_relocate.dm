/datum/build_mode/relocate
	name = "Relocate Atom"
	icon_state = "buildmode7"
	click_interactions = list(
		/decl/build_mode_interaction/move_into/select,
		/decl/build_mode_interaction/move_into/move,
		/decl/build_mode_interaction/move_into/select_subject,
		/decl/build_mode_interaction/move_into/move_subject
	)
	var/atom/destination
	var/atom/movable/to_relocate

/datum/build_mode/relocate/Destroy()
	ClearDestination()
	ClearRelocator()
	. = ..()

/datum/build_mode/relocate/proc/SetDestination(var/atom/A)
	if(A == destination)
		return
	ClearDestination()
	destination = A
	events_repository.register(/decl/observ/destroyed, destination, src, TYPE_PROC_REF(/datum/build_mode/relocate, ClearDestination))
	to_chat(user, SPAN_NOTICE("Will now move targets into \the [destination]."))

/datum/build_mode/relocate/proc/ClearDestination(var/feedback)
	if(!destination)
		return
	events_repository.unregister(/decl/observ/destroyed, destination, src, TYPE_PROC_REF(/datum/build_mode/relocate, ClearDestination))
	destination = null
	if(feedback)
		Warn("The selected destination was deleted.")

/datum/build_mode/relocate/proc/SetRelocator(var/new_relocator)
	if(to_relocate == new_relocator)
		return
	ClearRelocator()
	to_relocate = new_relocator
	events_repository.register(/decl/observ/destroyed, to_relocate, src, TYPE_PROC_REF(/datum/build_mode/relocate, ClearRelocator))
	to_chat(user, SPAN_NOTICE("Will now be relocating \the [to_relocate]."))

/datum/build_mode/relocate/proc/ClearRelocator(var/feedback)
	if(!to_relocate)
		return
	events_repository.unregister(/decl/observ/destroyed, to_relocate, src, TYPE_PROC_REF(/datum/build_mode/relocate, ClearRelocator))
	to_relocate = null
	if(feedback)
		Warn("The selected relocation object was deleted.")

/decl/build_mode_interaction/move_into
	abstract_type = /decl/build_mode_interaction/move_into

/decl/build_mode_interaction/move_into/select
	description = "Select a target destination."
	trigger_params = list("left")

/decl/build_mode_interaction/move_into/select/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/relocate/move_mode = build_mode
	if(istype(move_mode) && istype(A))
		move_mode.SetDestination(A)
		return TRUE
	return FALSE

/decl/build_mode_interaction/move_into/move
	name        = "Right Click on Movable Atom"
	description = "Move an atom into the target destination."
	trigger_params = list("right")

/decl/build_mode_interaction/move_into/move/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/relocate/move_mode = build_mode
	if(!istype(move_mode))
		return FALSE
	if(!move_mode.destination)
		to_chat(build_mode.user, SPAN_WARNING("No target destination set."))
		return FALSE
	if(!ismovable(A))
		to_chat(build_mode.user, SPAN_WARNING("\The [A] must be of type /atom/movable."))
		return FALSE
	to_chat(build_mode.user, SPAN_NOTICE("Moved \the [A] into \the [move_mode.destination]."))
	build_mode.Log("Moved '[log_info_line(A)]' into '[log_info_line(move_mode.destination)]'.")
	var/atom/movable/AM = A
	AM.forceMove(move_mode.destination)
	return TRUE

/decl/build_mode_interaction/move_into/select_subject
	name        = "Left Click and Ctrl on Movable Atom"
	description = "Select a movable atom to move into destination."
	trigger_params = list("left", "ctrl")

/decl/build_mode_interaction/move_into/select_subject/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/relocate/move_mode = build_mode
	if(istype(move_mode) && ismovable(A))
		move_mode.SetRelocator(A)
		return TRUE
	return FALSE

/decl/build_mode_interaction/move_into/move_subject
	name        = "Right Click and Ctrl on Destination"
	description = "Move selected atom into the target."
	trigger_params = list("right", "ctrl")

/decl/build_mode_interaction/move_into/move_subject/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/relocate/move_mode = build_mode
	if(!istype(move_mode))
		return FALSE
	if(!move_mode.to_relocate)
		to_chat(build_mode.user, SPAN_WARNING("You have nothing selected to relocate."))
		return FALSE
	var/destination_turf = get_turf(A)
	if(!destination_turf)
		to_chat(build_mode.user, SPAN_WARNING("Unable to locate destination turf."))
		return FALSE
	move_mode.to_relocate.forceMove(destination_turf)
	build_mode.Log("Relocated '[log_info_line(move_mode.to_relocate)]' to '[log_info_line(destination_turf)]'")
	return TRUE
