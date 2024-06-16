/mob/living/deity/verb/jump_to_follower()
	set category = "Godhood"

	if(!minions)
		return

	var/list/could_follow = list()
	for(var/m in minions)
		var/datum/mind/M = m
		if(M.current && M.current.stat != DEAD)
			could_follow += M.current

	if(!could_follow.len)
		return

	var/choice = input(src, "Jump to follower", "Teleport") as null|anything in could_follow
	if(choice)
		follow_follower(choice)

/mob/living/deity/proc/follow_follower(var/mob/living/L)
	if(!L || L.stat == DEAD || !is_follower(L, silent=1))
		return
	if(following)
		stop_follow()
	eyeobj.setLoc(get_turf(L))
	to_chat(src, SPAN_NOTICE("You begin to follow \the [L]."))
	following = L
	events_repository.register(/decl/observ/moved, L, src, TYPE_PROC_REF(/mob/living/deity, keep_following))
	events_repository.register(/decl/observ/destroyed, L, src, TYPE_PROC_REF(/mob/living/deity, stop_follow))
	events_repository.register(/decl/observ/death, L, src, TYPE_PROC_REF(/mob/living/deity, stop_follow))

/mob/living/deity/proc/stop_follow()
	events_repository.unregister(/decl/observ/moved, following, src)
	events_repository.unregister(/decl/observ/destroyed, following, src)
	events_repository.unregister(/decl/observ/death, following,src)
	to_chat(src, SPAN_NOTICE("You stop following \the [following]."))
	following = null

/mob/living/deity/proc/keep_following(var/atom/movable/moving_instance, var/atom/old_loc, var/atom/new_loc)
	eyeobj.setLoc(new_loc)
