// Overrides some aspects of mob movement for the purposes of automove.
/datum/automove_metadata
	var/move_delay
	var/acceptable_distance
	var/avoid_target

/datum/automove_metadata/New(_move_delay, _acceptable_distance, _avoid_target)
	move_delay          = _move_delay
	acceptable_distance = _acceptable_distance
	avoid_target        = _avoid_target
