/decl/slime_command
	var/list/triggers

/decl/slime_command/proc/resolve(var/speaker, var/spoken, var/datum/ai/slime/holder)
	for(var/trigger in triggers)
		if(findtext(spoken, trigger))
			return get_response(speaker, spoken, holder)

/decl/slime_command/proc/get_response(var/speaker, var/spoken, var/datum/ai/slime/holder)
	return

/decl/slime_command/hello
	triggers = list("hello", "hi")

/decl/slime_command/hello/get_response(var/speaker, var/spoken, var/datum/ai/slime/holder)
	holder.adjust_friendship(speaker, rand(1,2))
	return pick("Hello...", "Hi...")

/decl/slime_command/follow
	triggers = list("follow")

/decl/slime_command/follow/get_response(var/speaker, var/spoken, var/datum/ai/slime/holder)
	if(holder.leader)
		if(holder.leader == speaker)
			return pick("Yes...", "Lead...", "Following...")
		if(LAZYACCESS(holder.observed_friends, weakref(speaker)) > LAZYACCESS(holder.observed_friends, weakref(holder.leader)))
			holder.leader = speaker
			return "Yes... I follow [speaker]..."
		return "No... I follow [holder.leader]..."
	if(LAZYACCESS(holder.observed_friends, weakref(speaker)) > 2)
		holder.leader = speaker
		return "I follow..."
	return pick("No...", "I won't follow...")

/decl/slime_command/stop
	triggers = list("stop")

/decl/slime_command/stop/get_response(var/speaker, var/spoken, var/datum/ai/slime/holder)
	var/friendship = LAZYACCESS(holder.observed_friends, weakref(speaker))
	if(holder.slime.feeding_on)
		if(friendship > 4)
			holder.slime.set_feeding_on()
			holder.current_target = null
			if(friendship < 7)
				holder.adjust_friendship(speaker, -1)
				return "Grrr..."
			return "Fine..."
	if(holder.current_target)
		if(friendship > 3)
			holder.current_target = null
			if(friendship < 6)
				holder.adjust_friendship(speaker, -1)
				return "Grrr..."
			return "Fine..."
	if(holder.leader)
		if(holder.leader == speaker)
			holder.leader = null
			return "Yes... I'll stop..."
		if(friendship > LAZYACCESS(holder.observed_friends, weakref(holder.leader)))
			holder.leader = null
			return "Yes... I'll stop..."
		return "No... I'll keep following..."

/decl/slime_command/stay
	triggers = list("stay")

/decl/slime_command/stay/get_response(var/speaker, var/spoken, var/datum/ai/slime/holder)
	var/friendship = LAZYACCESS(holder.observed_friends, weakref(speaker))
	if(holder.leader)
		if(holder.leader == speaker)
			holder.holding_still = friendship * 10
			return "Yes... Staying..."
		var/leader_friendship = LAZYACCESS(holder.observed_friends, weakref(holder.leader))
		if(friendship > leader_friendship)
			holder.holding_still = (friendship - leader_friendship) * 10
			return "Yes... Staying..."
		return "No... I'll keep following..."
	if(friendship > 2)
		holder.holding_still = friendship * 10
		return "Yes... Staying..."
	return "No... I won't stay..."
