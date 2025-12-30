//If we intercept it return true else return false
/atom/proc/RelayMouseDrag(atom/src_object, atom/over_object, src_location, over_location, src_control, over_control, params, mob/user)
	return FALSE

/atom/proc/RelayMouseDown(atom/object, location, control, params, mob/user)
	return FALSE

/atom/proc/RelayMouseUp(atom/object, location, control, params, mob/user)
	return FALSE

/mob/proc/OnMouseDrag(atom/src_object, atom/over_object, src_location, over_location, src_control, over_control, params)
	if(loc)
		var/atom/A = loc
		if(A.RelayMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params, src))
			return

	var/obj/item/gun/gun = get_active_held_item()
	if(check_intent(I_FLAG_HARM) && istype(over_object) && (isturf(over_object) || isturf(over_object.loc)) && !incapacitated() && istype(gun))
		gun.set_autofire(over_object, src)

/mob/proc/OnMouseDown(atom/object, location, control, params)
	if(loc)
		var/atom/A = loc
		if(A.RelayMouseDown(object, location, control, params, src))
			return

	var/obj/item/gun/gun = get_active_held_item()
	if(check_intent(I_FLAG_HARM) && istype(object) && (isturf(object) || isturf(object.loc)) && !incapacitated() && istype(gun))
		gun.set_autofire(object, src)

/mob/proc/OnMouseUp(atom/object, location, control, params)
	if(loc)
		var/atom/A = loc
		if(A.RelayMouseUp(object, location, control, params, src))
			return

	var/obj/item/gun/gun = get_active_held_item()
	if(istype(gun))
		gun.clear_autofire()
