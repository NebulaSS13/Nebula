/decl/mouse_pointer
	abstract_type = /decl/mouse_pointer
	/// Icon to set on the client for this cursor.
	var/list/icons

/decl/mouse_pointer/Initialize()
	. = ..()
	if(icons && !islist(icons))
		icons = list(icons)

/decl/mouse_pointer/validate()
	. = ..()
	if(length(icons))
		var/static/list/check_states = list(
			"",
			"over",
			"drag",
			"drop",
			"all"
		)
		for(var/icon in icons)
			for(var/check_state in check_states)
				if(!check_state_in_icon(check_state, icon))
					. += "missing state '[check_state]' from icon '[icon]'"
	else
		. += "null or empty icon list"

// Subtypes for use in add_mouse_pointer() below.
/decl/mouse_pointer/examine
	uid  = "pointer_examine"
	icons = 'icons/effects/mouse_pointers/examine_pointer.dmi'
