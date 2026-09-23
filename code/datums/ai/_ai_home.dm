/datum/mob_controller
	var/atom/home
	var/home_wander_distance

/datum/mob_controller/proc/set_home(atom/_home, dist)
	home = _home
	if(istype(home))
		home_wander_distance = dist
	else
		home_wander_distance = 0
		home = null
