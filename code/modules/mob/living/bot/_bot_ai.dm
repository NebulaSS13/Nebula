// TODO:
// - A* pathing for automove
// - Frustration for automove

/datum/mob_controller/bot
	var/atom/target
	var/list/patrol_path
	var/list/target_path
	var/turf/obstacle = null
	var/frustration = 0
	var/max_frustration = 0

/datum/mob_controller/bot/clear_paths()
	..()
	LAZYCLEARLIST(patrol_path)
	LAZYCLEARLIST(target_path)

/datum/mob_controller/bot/can_process()
	var/mob/living/bot/bot = body
	return ..() && istype(bot) && !bot.key && bot.on && !bot.busy

/datum/mob_controller/bot/get_target()
	return target

/datum/mob_controller/bot/set_target(atom/new_target)
	target = new_target

/datum/mob_controller/bot/lose_target()
	target = null
	var/mob/living/bot/bot = body
	if(istype(bot))
		target_path = list()
		frustration = 0
		obstacle = null

/datum/mob_controller/bot/list_targets(dist = 7)
	for(var/atom/thing in view(dist, body))
		if(thing.simulated && valid_target(thing))
			LAZYADD(., thing)

/datum/mob_controller/bot/valid_target(atom/A)
	if(A.invisibility >= INVISIBILITY_LEVEL_ONE)
		return FALSE
	if(A in _friends)
		return FALSE
	if(!A.loc)
		return FALSE
	return TRUE

/datum/mob_controller/bot/handle_ranged_target(atom/ranged_target)
	if(!body.can_act())
		return FALSE
	if(ranged_target)
		body.start_automove(ranged_target)
	else
		body.stop_automove()
	return TRUE

/datum/mob_controller/bot/proc/handle_bot_adjacent_target()
	body.stop_automove()

/datum/mob_controller/bot/proc/handle_bot_patrol()
/*
	if(bot.will_patrol && !LAZYLEN(body.grabbed_by) && !target)
		if(LAZYLEN(patrol_path))
			for(var/i = 1 to patrol_speed)
				sleep(20 / (patrol_speed + 1))
				bot.handlePatrol()
			if( * patrol_speed)
				bot.handleFrustrated(0)
		else
			bot.startPatrol()
	else
		bot.handleIdle()
*/
	return

/datum/mob_controller/bot/proc/handle_bot_idle()
	return

/datum/mob_controller/bot/do_process()
	SHOULD_CALL_PARENT(FALSE)
	var/mob/living/bot/bot = body
	if(!istype(bot) || QDELETED(bot))
		return FALSE

	if(LAZYLEN(_friends))
		for(var/atom/friend in _friends)
			if(QDELETED(friend) || !friend.loc || prob(1))
				remove_friend(friend)

	// Automove frustration:
	// if(max_frustration && frustration >= max_frustration)
	//     handle_frustrated()
	handle_general_bot_ai(bot)

	if(target && !valid_target(target))
		lose_target()
		return

	if(!target)
		target = find_target()

	if(target)
		if(body.Adjacent(target))
			handle_bot_adjacent_target(target)
		else
			handle_ranged_target(target)
		return

	if(bot.will_patrol)
		handle_bot_patrol()
	else
		handle_bot_idle()
	return TRUE

/datum/mob_controller/bot/proc/handle_general_bot_ai(mob/living/bot/bot)
	return

/datum/mob_controller/bot/proc/handle_frustrated()
	obstacle = get_target() ? LAZYACCESS(target_path, 1) : LAZYACCESS(patrol_path, 1)
	LAZYCLEARLIST(target_path)
	LAZYCLEARLIST(patrol_path)

// Code remaining to convert.
/mob/living/bot
	var/busy = 0
	var/will_patrol = 0 // If set to 1, will patrol, duh
	var/patrol_speed = 1 // How many times per tick we move when patrolling
	var/target_speed = 2 // Ditto for chasing the target
	var/min_target_dist = 1 // How close we try to get to the target
	var/max_target_dist = 50 // How far we are willing to go
	var/max_patrol_dist = 250

/mob/living/bot/proc/stepToTarget()
	var/datum/mob_controller/bot/botai = ai
	if(!istype(botai))
		return
	var/atom/target = botai.get_target()
	if(!target || !target.loc)
		return
	if(get_dist(src, target) > min_target_dist)
		if(!LAZYLEN(botai.target_path) || get_turf(target) != botai.target_path[LAZYLEN(botai.target_path)])
			calcTargetPath()
		if(makeStep(botai.target_path))
			botai.frustration = 0
		else if(botai.max_frustration)
			botai.frustration++

/mob/living/bot/proc/handlePatrol()
	var/datum/mob_controller/bot/botai = ai
	if(istype(botai))
		makeStep(botai.patrol_path)

/mob/living/bot/proc/startPatrol()
	var/datum/mob_controller/bot/botai = ai
	if(!istype(botai))
		return
	var/turf/T = getPatrolTurf()
	if(!T)
		return
	botai.patrol_path = AStar(get_turf(loc), T, TYPE_PROC_REF(/turf, CardinalTurfsWithAccess), TYPE_PROC_REF(/turf, Distance), 0, max_patrol_dist, id = botcard, exclude = botai.obstacle)
	botai.obstacle = null

/mob/living/bot/proc/getPatrolTurf()
	var/minDist = INFINITY
	var/obj/machinery/navbeacon/targ = locate() in get_turf(src)
	if(!targ)
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(!N.codes["patrol"])
				continue
			if(get_dist(src, N) < minDist)
				minDist = get_dist(src, N)
				targ = N
	if(targ && targ.codes["next_patrol"])
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(N.location == targ.codes["next_patrol"])
				targ = N
				break
	if(targ)
		return get_turf(targ)
	return null

/mob/living/bot/proc/calcTargetPath()
	var/datum/mob_controller/bot/botai = ai
	if(!istype(botai))
		return
	var/atom/target = botai.get_target()
	if(!istype(target))
		return
	botai.target_path = AStar(get_turf(loc), get_turf(target), TYPE_PROC_REF(/turf, CardinalTurfsWithAccess), TYPE_PROC_REF(/turf, Distance), 0, max_target_dist, id = botcard, exclude = botai.obstacle)
	if(!LAZYLEN(botai.target_path))
		if(target?.loc)
			ai.add_friend(target)
		ai.lose_target()
		botai.obstacle = null
	return

/mob/living/bot/proc/makeStep(var/list/path)
	if(!path.len)
		return 0
	var/turf/T = path[1]
	if(get_turf(src) == T)
		path -= T
		return makeStep(path)
	return step_towards(src, T)
