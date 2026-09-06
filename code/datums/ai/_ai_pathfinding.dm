/datum/mob_controller/proc/can_do_automated_move(variant_move_delay)
	return body && !body.client

/datum/mob_controller/proc/clear_paths()
	clear_path()

/datum/mob_controller/proc/clear_path()
	executing_path = null
	body?.stop_automove()

/datum/mob_controller/proc/get_automove_target(datum/automove_metadata/metadata)
	var/turf/move_target = (islist(executing_path) && length(executing_path)) ? executing_path[1] : null
	if(!istype(move_target) || QDELETED(move_target))
		clear_path()
		return null
	return move_target

/datum/mob_controller/proc/handle_post_automoved(atom/old_loc)
	if(!islist(executing_path) || length(executing_path) <= 0)
		return
	var/turf/body_turf = get_turf(body)
	if(!istype(body_turf))
		return
	if(executing_path[1] != body_turf)
		return
	if(length(executing_path) > 1)
		executing_path.Cut(1, 2)
	else
		clear_path()
