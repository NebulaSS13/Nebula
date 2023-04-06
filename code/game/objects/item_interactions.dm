/obj/item/get_alt_interactions(var/mob/user)
	. = ..()
	if(config.expanded_alt_interactions)
		LAZYADD(., list(
			/decl/interaction_handler/pick_up,
			/decl/interaction_handler/drop,
			/decl/interaction_handler/use
		))

/decl/interaction_handler/use
	name = "Use"
	expected_target_type = /obj/item

/decl/interaction_handler/use/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/I = target
	I.attack_self(user)

/decl/interaction_handler/pick_up
	name = "Pick Up"
	expected_target_type = /obj/item

/decl/interaction_handler/pick_up/invoked(atom/target, mob/user, obj/item/prop)
	target.attack_hand_with_interaction_checks(user)

/decl/interaction_handler/drop
	name = "Drop"
	expected_target_type = /obj/item
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_INVENTORY

/decl/interaction_handler/drop/invoked(atom/target, mob/user, obj/item/prop)
	user.try_unequip(target, user.loc)
