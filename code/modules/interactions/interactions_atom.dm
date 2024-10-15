/atom/proc/try_handle_interactions(var/mob/user, var/list/interactions, var/obj/item/prop)

	if(!length(interactions))
		return FALSE

	var/list/possibilities
	for(var/interaction_type in interactions)
		var/decl/interaction_handler/interaction = GET_DECL(interaction_type)
		if(interaction.is_possible(src, user, prop))
			var/image/label = image(interaction.icon, interaction.icon_state)
			label.name = interaction.name
			LAZYSET(possibilities, interaction, label)

	if(!length(possibilities))
		return FALSE

	var/decl/interaction_handler/choice = possibilities[1]
	if(length(possibilities) > 1 || (choice.interaction_flags & INTERACTION_NEVER_AUTOMATIC))
		choice = null
		choice = show_radial_menu(user, src, possibilities, use_labels = RADIAL_LABELS_CENTERED)
		if(!istype(choice) || QDELETED(user) || !(choice.type in get_alt_interactions(user)) || !choice.is_possible(src, user, prop))
			return TRUE

	user.face_atom(src)
	choice.invoked(src, user, prop)
	return TRUE
