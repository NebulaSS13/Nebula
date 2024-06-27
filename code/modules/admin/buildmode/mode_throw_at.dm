/datum/build_mode/throw_at
	name = "Throw At"
	icon_state = "buildmode4"
	click_interactions = list(
		/decl/build_mode_interaction/throwing/select,
		/decl/build_mode_interaction/throwing/throw_at
	)
	var/atom/movable/to_throw

/datum/build_mode/throw_at/Destroy()
	ClearThrowable()
	. = ..()

/datum/build_mode/throw_at/proc/SetThrowable(var/new_throwable)
	if(to_throw == new_throwable)
		return
	ClearThrowable()

	to_throw = new_throwable
	events_repository.register(/decl/observ/destroyed, to_throw, src, TYPE_PROC_REF(/datum/build_mode/throw_at, ClearThrowable))
	to_chat(user, SPAN_NOTICE("Will now be throwing \the [to_throw]."))

/datum/build_mode/throw_at/proc/ClearThrowable(var/feedback)
	if(!to_throw)
		return

	events_repository.unregister(/decl/observ/destroyed, to_throw, src, TYPE_PROC_REF(/datum/build_mode/throw_at, ClearThrowable))
	to_throw = null
	if(feedback)
		Warn("The selected throwing object was deleted.")

/decl/build_mode_interaction/throwing
	abstract_type = /decl/build_mode_interaction/throwing

/decl/build_mode_interaction/throwing/select
	name        = "Left Click on Movable Atom"
	description = "Select object to be thrown."
	trigger_params = list("left")

/decl/build_mode_interaction/throwing/select/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/throw_at/throw_mode = build_mode
	if(ismovable(A) && istype(throw_mode))
		throw_mode.SetThrowable(A)
		return TRUE
	return FALSE

/decl/build_mode_interaction/throwing/throw_at
	description = "Throw selected atom at the target."
	trigger_params = list("right")

/decl/build_mode_interaction/throwing/throw_at/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/throw_at/throw_mode = build_mode
	if(!istype(throw_mode) || !throw_mode.to_throw)
		to_chat(build_mode.user, SPAN_WARNING("You have nothing selected to throw."))
		return FALSE
	if(!isturf(throw_mode.to_throw.loc))
		to_chat(build_mode.user, SPAN_WARNING("\The [throw_mode.to_throw] is currently not on a turf and cannot be thrown."))
		return FALSE
	throw_mode.to_throw.throw_at(A, 10, 1)
	build_mode.Log("Threw '[log_info_line(throw_mode.to_throw)]' at '[log_info_line(A)]'")
	return TRUE
