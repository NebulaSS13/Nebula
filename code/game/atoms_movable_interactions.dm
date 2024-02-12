/atom/movable/get_alt_interactions(var/mob/user)
	. = ..()
	if(config.expanded_alt_interactions)
		LAZYADD(., list(
			/decl/interaction_handler/look,
			/decl/interaction_handler/grab
		))

///////////////////////////////////////////////////////////////////////////
// Interaction Definitions
///////////////////////////////////////////////////////////////////////////

/decl/interaction_handler/look
	name = "Examine"
	expected_user_type = /mob
	interaction_flags = 0

/decl/interaction_handler/look/invoked(atom/target, mob/user, obj/item/prop)
	target.examine(user, get_dist(user, target))

/decl/interaction_handler/grab
	name = "Grab"
	expected_target_type = /atom/movable
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_TURF

/decl/interaction_handler/grab/is_possible(atom/movable/target, mob/user, obj/item/prop)
	return ..() && !target.anchored

/decl/interaction_handler/grab/invoked(atom/target, mob/user, obj/item/prop)
	var/atom/movable/AM = target
	AM.try_make_grab(user, defer_hand = TRUE)
