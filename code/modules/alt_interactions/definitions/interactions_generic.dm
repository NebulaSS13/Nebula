/decl/interaction_handler/look
	name = "Examine"
	expected_user_type = /mob
	interaction_flags = 0

/decl/interaction_handler/look/invoked(atom/target, mob/user)
	target.examine(user, get_dist(user, target))

/decl/interaction_handler/grab
	name = "Grab"
	expected_target_type = /atom/movable
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_TURF

/decl/interaction_handler/grab/invoked(atom/target, mob/user)
	var/atom/movable/AM = target
	AM.try_make_grab(user, defer_hand = TRUE)

/decl/interaction_handler/use
	name = "Use"
	expected_target_type = /obj/item

/decl/interaction_handler/use/invoked(atom/target, mob/user)
	var/obj/item/I = target
	I.attack_self(user)

/decl/interaction_handler/pick_up
	name = "Pick Up"
	expected_target_type = /obj/item

/decl/interaction_handler/pick_up/invoked(atom/target, mob/user)
	target.attack_hand(user)

/decl/interaction_handler/drop
	name = "Drop"
	expected_target_type = /obj/item
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_INVENTORY

/decl/interaction_handler/drop/invoked(atom/target, mob/user)
	user.unEquip(target, user.loc)

/decl/interaction_handler/rotate
	name = "Rotate"
	expected_target_type = /obj

/decl/interaction_handler/rotate/is_possible(atom/target, mob/user)
	. = ..()
	if(.)
		var/obj/O = target
		. = !!(O.obj_flags & OBJ_FLAG_ROTATABLE)

/decl/interaction_handler/rotate/invoked(atom/target, mob/user)
	var/obj/O = target
	O.rotate(user)
