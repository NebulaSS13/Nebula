/atom/proc/try_handle_interactions(var/mob/user, var/list/interactions, var/obj/item/prop, var/check_alt_interactions)

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
		if(!istype(choice) || QDELETED(user) || QDELETED(src))
			return TRUE
		// This is not ideal but I don't want to pass a callback through here as a param and call it. :(
		var/list/new_interactions = check_alt_interactions ? get_alt_interactions(user) : get_standard_interactions(user)
		if(!(choice.type in new_interactions))
			return TRUE
		if(!choice.is_possible(src, user, user.get_active_held_item()))
			return TRUE

	user.face_atom(src)
	choice.invoked(src, user, prop)
	if(choice.apply_click_cooldown)
		user.setClickCooldown(choice.apply_click_cooldown)
	return TRUE
