/atom/proc/get_alt_interactions(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	. = list()

/atom/proc/try_handle_alt_interactions(var/mob/user)

	var/list/interactions = get_alt_interactions(user)
	if(!length(interactions))
		return FALSE
	
	var/list/possibilities
	for(var/interaction_type in interactions)
		var/decl/interaction_handler/interaction = GET_DECL(interaction_type)
		if(interaction.is_possible(src, user))
			LAZYADD(possibilities, interaction)

	if(!length(possibilities))
		return FALSE

	var/decl/interaction_handler/choice
	if(length(possibilities) == 1)
		choice = possibilities[1]
	else
		// TODO: nicer system for this - radials would be ideal but they center on the user.
		choice = input(user, "What do you want to do with \the [src]?", "Select Interaction") as null|anything in possibilities
		if(!istype(choice) || !(choice.type in get_alt_interactions()) || !choice.is_possible(src, user))
			return FALSE

	user.face_atom(src)
	choice.invoked(src, user)
	return TRUE
