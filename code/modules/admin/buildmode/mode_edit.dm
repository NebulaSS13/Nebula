/datum/build_mode/edit
	name = "Edit"
	icon_state = "buildmode3"
	click_interactions = list(
		/decl/build_mode_interaction/edit/select_var_and_value,
		/decl/build_mode_interaction/edit/set_var_value,
		/decl/build_mode_interaction/edit/set_var_value/reset
	)
	var/var_to_edit = "name"
	var/value_to_set = "val"

/datum/build_mode/edit/Destroy()
	ClearValue()
	. = ..()

/datum/build_mode/edit/Configurate()
	var/var_name = input("Enter variable name:", "Name", var_to_edit) as text|null
	if(!var_name)
		return

	var/thetype = input("Select variable type:", "Type") as null|anything in list("text","number","mob-reference","obj-reference","turf-reference")
	if(!thetype) return

	var/new_value
	switch(thetype)
		if("text")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as text|null
		if("number")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as num|null
		if("mob-reference")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as null|mob in SSmobs.mob_list
		if("obj-reference")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as null|obj in world
		if("turf-reference")
			new_value = input(usr,"Enter variable value:" ,"Value", value_to_set) as null|turf in world

	if(var_name && new_value)
		var_to_edit = var_name
		SetValue(new_value)

/datum/build_mode/edit/proc/SetValue(var/new_value)
	if(value_to_set == new_value)
		return
	ClearValue()
	value_to_set = new_value
	if(istype(value_to_set, /datum))
		events_repository.register(/decl/observ/destroyed, value_to_set, src, TYPE_PROC_REF(/datum/build_mode/edit, ClearValue))

/datum/build_mode/edit/proc/ClearValue(var/feedback)
	if(!istype(value_to_set, /datum))
		return

	events_repository.unregister(/decl/observ/destroyed, value_to_set, src, TYPE_PROC_REF(/datum/build_mode/edit, ClearValue))
	value_to_set = initial(value_to_set)
	if(feedback)
		Warn("The selected reference value was deleted. Default value restored.")

/decl/build_mode_interaction/edit
	abstract_type = /decl/build_mode_interaction/edit

/decl/build_mode_interaction/edit/select_var_and_value
	name        = "Right Click on Build Mode Button"
	description = "Select variable and value."
	dummy_interaction = TRUE

/decl/build_mode_interaction/edit/set_var_value
	description    = "Set the target's variable to the selected value."
	trigger_params = list("left")

/decl/build_mode_interaction/edit/set_var_value/proc/get_new_val(datum/build_mode/edit/edit_mode, atom/A)
	return	edit_mode.value_to_set

/decl/build_mode_interaction/edit/set_var_value/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)

	var/datum/build_mode/edit/edit_mode = build_mode
	if(!istype(A) || !istype(edit_mode) || !A.may_edit_var(build_mode.user, edit_mode.var_to_edit))
		return FALSE

	var/old_value = A.vars[edit_mode.var_to_edit]
	var/new_value = get_new_val(edit_mode, A)

	if(old_value == new_value)
		return FALSE

	A.vars[edit_mode.var_to_edit] = new_value
	to_chat(build_mode.user, SPAN_NOTICE("Changed the value of [edit_mode.var_to_edit] from '[old_value]' to '[new_value]'."))
	build_mode.Log("[log_info_line(A)] - [edit_mode.var_to_edit] - [old_value] -> [new_value]")
	return TRUE

/decl/build_mode_interaction/edit/set_var_value/reset
	description    = "Reset the target's variable to default value."
	trigger_params = list("right")

/decl/build_mode_interaction/edit/set_var_value/reset/get_new_val(datum/build_mode/edit/edit_mode, atom/A)
	return initial(A.vars[edit_mode.var_to_edit])
