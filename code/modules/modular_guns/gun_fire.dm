/obj/item/gun/attack(atom/A, mob/living/user, def_zone)
	if(A == user && user.zone_sel.selecting == BP_MOUTH && !mouthshoot)
		handle_suicide(user)
		return TRUE
	if(user.a_intent == I_HURT)
		Fire(A, user, pointblank=1)
		return TRUE
	if(user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A, user)
		return TRUE
	. = ..()

/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent)
		return
	if(!user.aiming)
		user.aiming = new(user)
	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params)
	else
		Fire(A,user,params)
	return TRUE
