/datum/build_mode/advanced
	name = "Advanced"
	icon_state = "buildmode2"
	click_interactions = list(
		/decl/build_mode_interaction/advanced/create_objects,
		/decl/build_mode_interaction/advanced/delete_objects,
		/decl/build_mode_interaction/advanced/capture_object_type,
		/decl/build_mode_interaction/advanced/capture_object_type/alt,
		/decl/build_mode_interaction/advanced/select_object_type
	)

/datum/build_mode/advanced/ShowAdditionalHelpText()
	to_chat(user, SPAN_NOTICE("Use the directional button in the upper left corner to"))
	to_chat(user, SPAN_NOTICE("change the direction of built objects."))

/datum/build_mode/advanced/Configurate()
	SetBuildType(select_subpath(build_type || /obj/structure/closet))

/decl/build_mode_interaction/advanced
	abstract_type = /decl/build_mode_interaction/advanced

/decl/build_mode_interaction/advanced/create_objects
	description    = "Create objects."
	trigger_params = list("left")

/decl/build_mode_interaction/advanced/create_objects/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	if(ispath(build_mode.build_type, /turf))
		var/turf/T = get_turf(A)
		T.ChangeTurf(build_mode.build_type)
		return TRUE
	if(ispath(build_mode.build_type))
		var/atom/new_atom = new build_mode.build_type(get_turf(A))
		new_atom.set_dir(build_mode.host.direction)
		build_mode.Log("Created - [log_info_line(new_atom)]")
		return TRUE
	to_chat(build_mode.user, SPAN_WARNING("Select a type to construct."))
	return FALSE

/decl/build_mode_interaction/advanced/delete_objects
	description = "Delete objects."
	trigger_params = list("right")

/decl/build_mode_interaction/advanced/delete_objects/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	build_mode.Log("Deleted - [log_info_line(A)]")
	qdel(A)
	return TRUE

/decl/build_mode_interaction/advanced/capture_object_type
	description = "Capture object type."
	trigger_params = list("left", "ctrl")

/decl/build_mode_interaction/advanced/capture_object_type/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	build_mode.SetBuildType(A.type)

/decl/build_mode_interaction/advanced/capture_object_type/alt
	description = "Capture object type."
	trigger_params = list("middle")

/decl/build_mode_interaction/advanced/select_object_type
	name        = "Right Click on Build Mode Button"
	description = "Select object type"
	dummy_interaction = TRUE
