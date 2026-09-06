/datum/mob_controller/proc/get_target()
	if(isnull(target_ref))
		return null
	var/atom/target = target_ref?.resolve()
	if(!istype(target) || QDELETED(target))
		set_target(null)
		return null
	return target

/datum/mob_controller/proc/set_target(atom/new_target)
	var/weakref/new_target_ref = weakref(new_target)
	if(target_ref != new_target_ref)
		target_ref = new_target_ref
		return TRUE
	return FALSE

/datum/mob_controller/proc/find_target()
	SHOULD_CALL_PARENT(TRUE)
	next_target_scan_time = world.time + target_scan_delay

/datum/mob_controller/proc/valid_target(var/atom/A)
	if(!istype(A))
		return FALSE
	if(!A.simulated)
		return FALSE
	if(A == body)
		return FALSE
	if(A.invisibility > body.see_invisible)
		return FALSE
	if(LAZYLEN(_friends) && ismob(A) && (weakref(A) in _friends))
		return FALSE
	if(!A.loc)
		return FALSE
	return TRUE

/datum/mob_controller/proc/lose_target()
	path_frustration = 0
	path_obstacles = null
	set_target(null)
	lost_target()

/datum/mob_controller/proc/lost_target()
	set_stance(STANCE_IDLE)
	body.stop_automove()

/datum/mob_controller/proc/list_targets()
	// By default, we only target designated enemies.
	var/list/enemies = get_enemies()
	if(!LAZYLEN(enemies))
		return
	var/list/possible_targets = get_raw_target_list()
	if(!length(possible_targets))
		return
	for(var/weakref/enemy in enemies) // Remove all entries that aren't in enemies
		var/M = enemy.resolve()
		if(M in possible_targets)
			LAZYDISTINCTADD(., M)

/datum/mob_controller/proc/do_target_scan()
	. = target_scan_distance > 0 && world.time >= next_target_scan_time

/datum/mob_controller/proc/move_to_target(var/move_only = FALSE)
	return

/datum/mob_controller/proc/get_raw_target_list()
	if(target_scan_distance)
		return hearers(body, target_scan_distance)-body
	return null

/datum/mob_controller/proc/get_valid_targets()
	. = list()
	for(var/target in list_targets(target_scan_distance))
		if(valid_target(target))
			. += target

/datum/mob_controller/proc/handle_ranged_target(atom/ranged_target)
	return FALSE
