/decl/interaction_handler
	abstract_type = /decl/interaction_handler
	var/name
	var/icon
	var/icon_state
	var/expected_target_type = /atom
	var/expected_user_type = /mob/living
	var/interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION
	var/incapacitation_flags

/decl/interaction_handler/proc/is_possible(var/atom/target, var/mob/user, var/obj/item/prop)

	SHOULD_CALL_PARENT(TRUE)

	if(QDELETED(target) || QDELETED(user))
		return FALSE

	if(expected_user_type && !istype(user, expected_user_type))
		return FALSE

	if(expected_target_type && !istype(target, expected_target_type))
		return FALSE

	if(isturf(target) || isturf(target.loc))
		if(interaction_flags & INTERACTION_NEEDS_INVENTORY)
			return FALSE
	else
		if(interaction_flags & INTERACTION_NEEDS_TURF)
			return FALSE

	// CanPhysicallyInteract() checks Adjacent() so doing it twice is redundant.
	if(interaction_flags & INTERACTION_NEEDS_PHYSICAL_INTERACTION)
		if(!CanPhysicallyInteractWith(user, target))
			return FALSE
	else if((interaction_flags & INTERACTION_NEEDS_ADJACENCY) && !user.Adjacent(target))
		return FALSE

	// CanPhysicallyInteract() also checks default incapacitation, so don't set
	// incapacitation_flags unless needed.
	if(incapacitation_flags && user.incapacitated(incapacitation_flags))
		return FALSE

	return TRUE

/decl/interaction_handler/proc/invoked(atom/target, mob/user, obj/item/prop)
	SHOULD_CALL_PARENT(FALSE)
	PRINT_STACK_TRACE("Alt interaction handler called with no invoked logic defined: [type]")
