//as core click exists at the mob level
/mob/proc/trigger_aiming(var/trigger_type)
	return

/mob/living/trigger_aiming(var/trigger_type)
	for(var/obj/abstract/aiming_overlay/AO as anything in aimed_at_by)
		if(AO.aiming_at == src)
			AO.update_aiming()
			if(AO.aiming_at == src)
				AO.trigger(trigger_type)
				AO.update_aiming_deferred()

/mob/living/proc/aim_at(var/atom/target, var/obj/item/with)
	if(!ismob(target) || !istype(with) || incapacitated())
		return FALSE
	face_atom(target)
	var/obj/abstract/aiming_overlay/aiming = get_aiming_overlay(create_if_missing = TRUE)
	aiming.aim_at(target, with)
	return TRUE

/obj/abstract/aiming_overlay/proc/trigger(var/perm)
	if(!owner || !aiming_with || !aiming_at || !locked)
		return FALSE
	if(perm && (target_permissions & perm))
		return FALSE
	if(!owner.canClick())
		return FALSE
	return aiming_with.handle_reflexive_fire(owner, aiming_at)
