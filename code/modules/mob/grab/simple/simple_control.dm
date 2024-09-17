/decl/grab/simple/control
	name         = "controlling grab"
	shift        = 0
	adjust_plane = FALSE
	adjust_layer = FALSE

/decl/grab/simple/control/on_hit_help(var/obj/item/grab/grab, var/atom/A, var/proximity)
	if(A == grab.assailant)
		A = grab.affecting
	if(isliving(grab.affecting))
		var/mob/living/living_mob = grab.affecting
		return living_mob.handle_rider_help_order(grab.assailant, A, proximity)
	return FALSE

/decl/grab/simple/control/on_hit_disarm(var/obj/item/grab/grab, var/atom/A, var/proximity)
	if(A == grab.assailant)
		A = grab.affecting
	if(isliving(grab.affecting))
		var/mob/living/living_mob = grab.affecting
		return living_mob.handle_rider_disarm_order(grab.assailant, A, proximity)
	return FALSE

/decl/grab/simple/control/on_hit_grab(var/obj/item/grab/grab, var/atom/A, var/proximity)
	if(A == grab.assailant)
		A = grab.affecting
	if(isliving(grab.affecting))
		var/mob/living/living_mob = grab.affecting
		return living_mob.handle_rider_grab_order(grab.assailant, A, proximity)
	return FALSE

/decl/grab/simple/control/on_hit_harm(var/obj/item/grab/grab, var/atom/A, var/proximity)
	if(A == grab.assailant)
		A = grab.affecting
	if(isliving(grab.affecting))
		var/mob/living/living_mob = grab.affecting
		return living_mob.handle_rider_harm_order(grab.assailant, A, proximity)
	return FALSE

// Override these for mobs that will respond to instructions from a rider.
/mob/living/proc/handle_rider_harm_order(mob/user, atom/target, proximity)
	return FALSE

/mob/living/proc/handle_rider_grab_order(mob/user, atom/target, proximity)
	return FALSE

/mob/living/proc/handle_rider_disarm_order(mob/user, atom/target, proximity)
	return FALSE

/mob/living/proc/handle_rider_help_order(mob/user, atom/target, proximity)
	return FALSE
