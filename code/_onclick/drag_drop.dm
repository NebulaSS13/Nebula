/*
	The below procs are called on the atom you're dragging.  In a lot of circumstances we want to use the
	recieving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/

/atom/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_mouse_drop(over_object, usr, params = params) || !handle_mouse_drop(over_object, usr, params))
		. = ..()

/atom/proc/handle_mouse_drop(atom/over, mob/user, params)
	if(storage && !(. = storage?.handle_mouse_drop(user, over, params)))
		storage_removed(user)
		return
	. = over?.receive_mouse_drop(src, user, params)

// Can the user drop something onto this atom?
/atom/proc/user_can_mousedrop_onto(mob/user, atom/being_dropped, incapacitation_flags, params)
	return !user.incapacitated(incapacitation_flags) && check_mousedrop_interactivity(user, params) && user.check_dexterity(DEXTERITY_EQUIP_ITEM, silent = TRUE)

/atom/proc/check_mousedrop_interactivity(mob/user, params)
	return CanPhysicallyInteract(user)

// This proc checks if an atom can be mousedropped onto the target by the user.
/atom/proc/can_mouse_drop(var/atom/over, var/mob/user = usr, var/incapacitation_flags = INCAPACITATION_DEFAULT, var/params)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(user) || !istype(over) ||QDELETED(user) || QDELETED(over) || QDELETED(src))
		return FALSE
	if(!over.user_can_mousedrop_onto(user, src, incapacitation_flags, params))
		return FALSE
	if(!check_mousedrop_adjacency(over, user, params))
		return FALSE
	return TRUE

/atom/proc/check_mousedrop_adjacency(atom/over, mob/user, params)
	. = (Adjacent(user) && ((over in user?.client?.screen) || over.Adjacent(user)))

// Receive a mouse drop.
// Returns false if the atom is valid for dropping further up the chain, true if the drop has been handled.
/atom/proc/receive_mouse_drop(atom/dropping, mob/user, params)
	if(isliving(user) && !user.anchored && can_climb(user) && dropping == user)
		do_climb(dropping)
		return TRUE
	return FALSE
