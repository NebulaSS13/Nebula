/datum/extension/eye/blueprints
	expected_type = /obj/item/blueprints
	eye_type = /mob/observer/eye/blueprints

	action_type = /datum/action/eye/blueprints

/datum/action/eye/blueprints
	eye_type = /mob/observer/eye/blueprints

/datum/action/eye/blueprints/mark_new_area
	name = "Mark new area"
	procname = TYPE_PROC_REF(/mob/observer/eye/blueprints, create_area)
	button_icon_state = "pencil"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/remove_selection
	name = "Remove selection"
	procname = TYPE_PROC_REF(/mob/observer/eye/blueprints, remove_selection)
	button_icon_state = "eraser"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/edit_area
	name = "Edit area"
	procname = TYPE_PROC_REF(/mob/observer/eye/blueprints, edit_area)
	button_icon_state = "edit_area"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/remove_area
	name = "Remove area"
	procname = TYPE_PROC_REF(/mob/observer/eye/blueprints, remove_area)
	button_icon_state = "remove_area"
	target_type = EYE_TARGET

// Shuttle blueprints subtype (handles shuttle.shuttle_area)
/datum/extension/eye/blueprints/shuttle
	expected_type = /obj/item/blueprints/shuttle
	eye_type = /mob/observer/eye/blueprints/shuttle