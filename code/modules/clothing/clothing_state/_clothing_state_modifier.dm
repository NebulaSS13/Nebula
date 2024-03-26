/decl/clothing_state_modifier
	abstract_type = /decl/clothing_state_modifier
	var/name
	var/icon_state_modifier
	var/applies_icon_state_modifier = TRUE
	var/toggle_verb
	var/hides_id = FALSE
	var/alt_interaction_type

/decl/clothing_state_modifier/validate()
	. = ..()
	if(!istext(name))
		. += "null or invalid name '[name || "NULL"]'"
	if(applies_icon_state_modifier)
		if(istext(icon_state_modifier))
			var/list/all_modifiers = decls_repository.get_decls_of_subtype(/decl/clothing_state_modifier)
			for(var/modifier_type in all_modifiers)
				if(modifier_type == type)
					continue
				var/decl/clothing_state_modifier/modifier = all_modifiers[modifier_type]
				if(!modifier.applies_icon_state_modifier)
					continue
				if(findtext(icon_state_modifier, modifier.icon_state_modifier) || findtext(modifier.icon_state_modifier, icon_state_modifier))
					. += "icon state modifier '[icon_state_modifier]' overlaps with [modifier_type] state modifiers '[modifier.icon_state_modifier]'"
		else
			. += "null or invalid icon_state_modifier '[icon_state_modifier || "NULL"]'"
	if(!toggle_verb)
		. += "null toggle verb"
	if(!ispath(alt_interaction_type, /decl/interaction_handler))
		. += "null or invalid alt_interaction_type '[alt_interaction_type || "NULL"]'"
