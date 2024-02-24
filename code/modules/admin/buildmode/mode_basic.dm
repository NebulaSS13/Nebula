/datum/build_mode/basic
	the_default = TRUE
	name = "Basic"
	icon_state = "buildmode1"
	click_interactions = list(
		/decl/build_mode_interaction/basic/construct,
		/decl/build_mode_interaction/basic/deconstruct,
		/decl/build_mode_interaction/basic/reinforced_window,
		/decl/build_mode_interaction/basic/airlock
	)

/datum/build_mode/basic/ShowAdditionalHelpText()
	to_chat(user, SPAN_NOTICE("Use the directional button in the upper left corner to"))
	to_chat(user, SPAN_NOTICE("change the direction of built objects."))

/decl/build_mode_interaction/basic
	abstract_type = /decl/build_mode_interaction/basic

/decl/build_mode_interaction/basic/construct
	description    = "Construct or upgrade."
	trigger_params = list("left")

/decl/build_mode_interaction/basic/construct/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	if(!isturf(A))
		return FALSE
	var/turf/click_turf = A
	var/change_to = click_turf.get_build_mode_upgrade()
	if(change_to && click_turf.type != change_to)
		click_turf = click_turf.ChangeTurf(change_to)
		build_mode.Log("Upgraded - [log_info_line(click_turf)]")
		return TRUE
	return FALSE

/decl/build_mode_interaction/basic/deconstruct
	description    = "Deconstruct, downgrade or delete."
	trigger_params = list("right")

/decl/build_mode_interaction/basic/deconstruct/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	if(isturf(A))
		var/turf/click_turf = A
		var/change_to = click_turf.get_build_mode_downgrade()
		if(change_to && click_turf.type != change_to)
			click_turf = click_turf.ChangeTurf(change_to)
			build_mode.Log("Downgraded - [log_info_line(click_turf)]")
			return TRUE
	else if(isobj(A))
		build_mode.Log("Deleted - [log_info_line(A)]")
		qdel(A)
		return TRUE
	return FALSE

/decl/build_mode_interaction/basic/reinforced_window
	description = "Place reinforced window."
	trigger_params = list("left", "ctrl")

/decl/build_mode_interaction/basic/reinforced_window/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/turf/click_turf = get_turf(A)
	if(istype(click_turf))
		var/obj/structure/window/reinforced/window = new(click_turf)
		window.set_dir(build_mode.host.direction)
		build_mode.Log("Created - [log_info_line(window)]")
		return TRUE
	return FALSE

/decl/build_mode_interaction/basic/airlock
	description = "Place airlock."
	trigger_params = list("right", "ctrl")

/decl/build_mode_interaction/basic/airlock/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/turf/click_turf = get_turf(A)
	if(istype(click_turf))
		build_mode.Log("Created - [log_info_line(new /obj/machinery/door/airlock(click_turf))]")
		return TRUE
	return FALSE
