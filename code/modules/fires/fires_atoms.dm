/atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null

/atom/movable/proc/is_burnable()
	return FALSE

/atom/proc/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/atom/proc/extinguish(var/mob/user, var/no_message)
    return

/atom/proc/ignite()
    return

/atom/proc/is_on_fire()
	return
