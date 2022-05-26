/obj/get_alt_interactions(var/mob/user)
	. = ..() | /decl/interaction_handler/rotate
	if(config.expanded_alt_interactions)
		. += list(
			/decl/interaction_handler/look,
			/decl/interaction_handler/grab
		)

/obj/item/get_alt_interactions(var/mob/user)
	. = ..()
	if(config.expanded_alt_interactions)
		. += list(
			/decl/interaction_handler/pick_up,
			/decl/interaction_handler/drop,
			/decl/interaction_handler/use
		)
