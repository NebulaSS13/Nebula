/decl/interaction_handler/storage_open
	name = "Open Storage"
	expected_target_type = /obj/item/storage
	incapacitation_flags = INCAPACITATION_DISRUPTED

/decl/interaction_handler/storage_open/is_possible(atom/target, mob/user)
	. = ..() && (ishuman(user) || isrobot(user) || issmall(user))
	if(.)
		var/obj/item/storage/S = target
		. = S.canremove

/decl/interaction_handler/storage_open/invoked(atom/target, mob/user)
	var/obj/item/storage/S = target
	S.open(user)
