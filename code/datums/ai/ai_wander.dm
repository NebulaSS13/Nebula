/datum/mob_controller
	/// How many life ticks should pass before we wander?
	var/turns_per_wander = 2
	/// How many life ticks have passed since our last wander?
	var/turns_since_wander = 0
	/// Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/stop_wander = FALSE
	/// What directions can we wander in? Uses global.cardinal if unset.
	var/list/wander_directions

/datum/mob_controller/proc/stop_wandering()
	stop_wander = TRUE

/datum/mob_controller/proc/resume_wandering()
	stop_wander = FALSE

/datum/mob_controller/proc/get_wander_candidates(turf/centre)
	. = list()
	var/turf/wall/natural/ramp = centre
	var/ramp_dir = (istype(ramp) && ramp.ramp_slope_direction) ? global.reverse_dir[ramp.ramp_slope_direction] : 0
	for(var/dir in (wander_directions || global.cardinal))
		var/turf/neighbor = get_step(centre, dir)
		if(dir == ramp_dir)
			neighbor = GetAbove(neighbor)
		if(istype(neighbor) && !turf_contains_dense_objects(neighbor) && body.turf_is_safe(neighbor))
			. |= dir

// The mob will periodically sit up or step 1 tile in a random direction.
/datum/mob_controller/proc/try_wander()

	//Movement
	if(stop_wander || body.has_buckled_mob() || !(ai_flags & AI_FLAG_WANDERS) || body.anchored)
		return

	if(body.current_posture?.prone && !body.incapacitated())
		body.set_posture(/decl/posture/standing)
		return

	//This is so it only moves if it's not inside a closet, gentics machine, etc.
	if(!isturf(body.loc))
		return

	turns_since_wander++
	//Some animals don't move when pulled
	if(turns_since_wander < turns_per_wander || ((ai_flags & AI_FLAG_NO_PULLED_WANDER) && LAZYLEN(body.grabbed_by)))
		return

	turns_since_wander = 0
	var/alist/wander_candidates = get_wander_candidates(body.loc)
	if(length(wander_candidates))
		body.SelfMove(pick(wander_candidates))
