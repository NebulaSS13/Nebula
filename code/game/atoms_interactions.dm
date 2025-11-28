// List of interactions used in procs below.
var/global/list/_reagent_interactions = list(
	/decl/interaction_handler/wash_hands,
	/decl/interaction_handler/drink,
	/decl/interaction_handler/dip_item,
	/decl/interaction_handler/fill_from,
	/decl/interaction_handler/empty_into
)

/**
	Get a list of standard interactions (attack_hand and attackby) for a user from this atom.
	At time of writing, these are really easy to have interfere with or be interfered with by
	attack_hand() and attackby() overrides. Putting them on items us a bad idea due to pickup code.

	- `user`: The mob that these interactions are for
	- Return: A list containing the interactions
*/
/atom/proc/get_standard_interactions(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)
	return null

/**
	Get a default interaction for a user from this atom.

	- `user`: The mob that this interaction is for
	- Return: A default interaction decl, or null.
*/
/atom/proc/get_quick_interaction_handler(mob/user)
	return

/**
	Get a list of alt interactions (alt-click) for a user from this atom.

	- `user`: The mob that these alt interactions are for
	- Return: A list containing the alt interactions
*/
/atom/proc/get_alt_interactions(var/mob/user)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)
	if(storage)
		LAZYADD(., /decl/interaction_handler/storage_open)
	if(REAGENT_MAXIMUM_VOLUME(reagents))
		LAZYADD(., global._reagent_interactions)
