/atom/proc/try_handle_alt_interactions(var/mob/user)

	var/list/interactions = get_alt_interactions(user)
	if(!length(interactions))
		return FALSE
	
	var/list/possibilities
	for(var/interaction_type in interactions)
		var/decl/interaction_handler/interaction = GET_DECL(interaction_type)
		if(interaction.is_possible(src, user))
			var/image/label = image(interaction.icon, interaction.icon_state)
			label.name = interaction.name
			LAZYSET(possibilities, interaction, label)

	if(!length(possibilities))
		return FALSE

	var/decl/interaction_handler/choice
	if(length(possibilities) == 1)
		choice = possibilities[1]
	else
		choice = show_radial_menu(user, src, possibilities, use_labels = TRUE)
		if(!istype(choice) || !(choice.type in get_alt_interactions()) || !choice.is_possible(src, user))
			return FALSE

	user.face_atom(src)
	choice.invoked(src, user)
	return TRUE
