/datum/mob_controller
	/// What are we fleeing from?
	var/weakref/flee_target
	/// How many turns has it been since we last did a broad flee scan?
	var/turns_since_flee_scan
	/// What % of health do we need to be below before we flee?
	var/flee_threshold = 0.2

/datum/mob_controller/proc/get_flee_target()
	return flee_target?.resolve()

/datum/mob_controller/proc/set_flee_target(atom/flee_target)
	flee_target = weakref(flee_target)
