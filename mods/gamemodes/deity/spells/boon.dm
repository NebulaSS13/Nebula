/spell
	var/mob/living/deity/connected_god //Do we have this spell based off a boon from a god?

/spell/proc/set_connected_god(var/mob/living/deity/god)
	connected_god = god

// todo: godform check_charge to parallel take_charge. currently a boon always succeeds
/spell/take_charge(mob/user, skipcharge)
	if(connected_god)
		return connected_god.take_charge(user, max(1, charge_max/10))
	return ..()