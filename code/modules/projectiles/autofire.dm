/obj/item/gun
	var/autofire_enabled = FALSE
	var/autofire_delay = 0.1 SECOND
	var/next_autofire

/obj/item/gun/proc/gun_can_autofire()
	return (autofire_enabled && world.time >= next_fire_time)

/obj/item/gun/proc/autofire_check(mob/user, atom/target)
	if(!gun_can_autofire())
		return FALSE
	if(!istype(user))
		return FALSE
	if(!user.check_intent(I_FLAG_HARM))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!user.mob_can_autofire(src, target))
		return FALSE
	if(!istype(target) || (!isturf(target) && !isturf(target.loc)))
		return FALSE
	return TRUE

/obj/item/gun/wielder_mouse_drag_down(mob/user, object, location, control, params)
	if(autofire_check(user, object))
		return TRUE
	return FALSE

/obj/item/gun/wielder_mouse_drag_held(mob/user, atom/target)
	next_fire_time = world.time // Reset so we aren't held to a timer.
	if(!autofire_check(user, target))
		return FALSE
	if(world.time < next_autofire)
		return TRUE
	next_autofire = world.time + autofire_delay
	Fire(target, user, null, (get_dist(target, user) <= 1), FALSE, FALSE)
	return TRUE
