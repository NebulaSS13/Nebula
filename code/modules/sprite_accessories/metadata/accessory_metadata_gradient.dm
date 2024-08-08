/decl/sprite_accessory_metadata/gradient
	name          = "Gradient"
	uid           = "sa_metadata_gradient"
	default_value = "none"
	var/icon      = 'icons/mob/hair_gradients.dmi'
	/// A list of text labels for states that need more than just capitalize() to be presentable.
	var/list/selectable_states_to_labels = list(
		"fadeup"                 = "Fade Up",
		"fadedown"               = "Fade Down",
		"vsplit"                 = "Vertical Split",
		"bottomflat"             = "Flat Bottom",
		"fadeup_low"             = "Fade Up (Low)",
		"fadedown_low"           = "Fade Down (Low)",
		"reflected_inverse"      = "Reflected (Inverse)",
		"reflected_high"         = "Reflected (High)",
		"reflected_inverse_high" = "Reflected (Inverse High)"
	)
	/// Inverse of the above, generated at runtime.
	var/list/selectable_labels_to_states = list()

/decl/sprite_accessory_metadata/gradient/Initialize()
	var/list/selectable = icon_states(icon)
	for(var/state in selectable)
		if(!selectable_states_to_labels[state])
			selectable_states_to_labels[state] = capitalize(state)
	for(var/state in selectable_states_to_labels)
		selectable_labels_to_states[selectable_states_to_labels[state]] = state
	return ..()

/decl/sprite_accessory_metadata/gradient/validate()
	. = ..()
	if(!length(selectable_states_to_labels))
		. += "no selectable gradient states"
	else
		if(!(default_value in selectable_states_to_labels))
			. += "default_value '[default_value]' not in selectable list"
		for(var/state in selectable_labels_to_states)
			if(!(selectable_labels_to_states[state] in selectable_states_to_labels))
				. += "label for non-existent state '[state]'"

/decl/sprite_accessory_metadata/gradient/validate_data(value)
	return istext(value) && (value in selectable_states_to_labels)

/decl/sprite_accessory_metadata/gradient/get_metadata_options_string(datum/preferences/pref, decl/sprite_accessory_category/accessory_category_decl, decl/sprite_accessory/accessory_decl, value)
	if(!value || !validate(value))
		value = default_value
	return "<a href='byond://?src=\ref[pref];acc_cat_decl=\ref[accessory_category_decl];acc_decl=\ref[accessory_decl];acc_metadata=\ref[src]'>[selectable_states_to_labels[value]]</a>"

/decl/sprite_accessory_metadata/gradient/get_new_value_for(mob/user, decl/sprite_accessory/accessory_decl, current_value)
	var/choice = input(user, "Choose a [lowertext(name)] for your [accessory_decl.name]: ", CHARACTER_PREFERENCE_INPUT_TITLE, current_value) as null|anything in selectable_labels_to_states
	return choice ? selectable_labels_to_states[choice] : null