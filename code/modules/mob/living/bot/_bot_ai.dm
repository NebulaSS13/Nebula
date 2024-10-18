/datum/mob_controller/bot
	target_scan_distance = 5

/datum/mob_controller/bot/can_process()
	var/mob/living/bot/bot = body
	return ..() && istype(bot) && bot.on

// No discrimination here.
/datum/mob_controller/bot/list_targets()
	return get_raw_target_list()

// Bots can target a variety of things other than mobs,
// hence need to use view() instead of hearers().
/datum/mob_controller/bot/get_raw_target_list()
	if(target_scan_distance)
		return view(body, target_scan_distance)-body
	return null

/datum/mob_controller/bot/handle_ranged_target(atom/ranged_target)
	if(!body.can_act())
		return FALSE
	if(ranged_target)
		body.start_automove(ranged_target)
	else
		body.stop_automove()
	return TRUE

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
