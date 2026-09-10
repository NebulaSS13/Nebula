/decl/mob_controller_stance/idle
	name = "idle"

/decl/mob_controller_stance/idle/on_body_life(mob/living/body, datum/mob_controller/controller)

	if(!(. = ..()))
		return

	// If we are aggressive, look for a target.
	if((controller.ai_flags & AI_FLAG_AGGRESSIVE) && controller.do_target_scan())
		controller.set_target(controller.find_valid_target())
		if(controller.get_target())
			if(controller.ai_flags & AI_FLAG_ALERTS)
				controller.set_stance(/decl/mob_controller_stance/alert)
			else
				controller.set_stance(/decl/mob_controller_stance/attack)
			return TRUE

	// Handle sleeping.
	if((controller.ai_flags & AI_FLAG_RESTS) && prob(controller.rest_chance))
		if(prob(50) && body.stat == CONSCIOUS)
			body.set_stat(UNCONSCIOUS)
			controller.stop_wandering()
			controller.speak_chance = 0
		else if(body.stat == UNCONSCIOUS)
			body.set_stat(CONSCIOUS)
			controller.resume_wandering()
			controller.speak_chance = initial(controller.speak_chance)
		body.update_posture()
	else if(!body.current_posture.prone && body.stat == CONSCIOUS)
		controller.try_wander()
		controller.try_bark()

	if(body.stat != CONSCIOUS)
		return FALSE

	if((controller.ai_flags & AI_FLAG_FRIENDLY) && LAZYLEN(controller._friends))

		var/mob/living/closest_friend
		var/last_closest_distance = INFINITY
		for(var/weakref/friend in controller._friends)
			var/mob/living/friend_mob = friend.resolve()
			if(!istype(friend_mob))
				continue
			var/friend_dist = get_dist(body, friend_mob)
			if(!closest_friend || friend_dist < last_closest_distance)
				last_closest_distance = friend_dist
				closest_friend = friend_mob

		if(!closest_friend)
			return

		var/friend_is_hurt = closest_friend.get_health_percent() < 0.5
		var/follow_dist = 4
		if (closest_friend.stat >= DEAD || closest_friend.is_asystole()) //danger
			follow_dist = 1
		else if (closest_friend.stat || friend_is_hurt) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		if(last_closest_distance > near_dist)
			controller.stop_wandering()
			body.start_automove(closest_friend)
			return
		controller.resume_wandering()
		body.stop_automove()
		controller.handle_friendly_proximity(closest_friend, friend_is_hurt)

/decl/mob_controller_stance/idle/on_stance_set(mob/living/body, datum/mob_controller/controller)
	if(body)
		body.stop_automove()
		body.set_moving_slowly()
	if(controller)
		controller.resume_wandering()
		controller.set_flee_target(null)
		controller.set_target(null)
