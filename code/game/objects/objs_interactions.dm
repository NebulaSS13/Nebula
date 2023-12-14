/obj/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/rotate)

/**
	Interaction for rotating an object in the world.
 */
/decl/interaction_handler/rotate
	name = "Rotate"
	expected_target_type = /obj

/decl/interaction_handler/rotate/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		var/obj/O = target
		. = !!(O.obj_flags & OBJ_FLAG_ROTATABLE)

/decl/interaction_handler/rotate/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/O = target
	O.rotate(user)
