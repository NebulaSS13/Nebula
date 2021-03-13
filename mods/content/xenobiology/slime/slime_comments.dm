/decl/slime_comment/proc/get_comment(var/datum/ai/slime/holder)
	return

/decl/slime_comment/general/get_comment(var/datum/ai/slime/holder)
	. = list("Rawr...", "Blop...", "Blorble...")
	if(holder.mood == ":3")
		. += "Purr..."
	else if(holder.mood == "sad")
		. += "Bored..."
	if(holder.attacked)
		. += "Grrr..."
	if(holder.body.getToxLoss() > 30)
		. += "Cold..."
	if(holder.body.getToxLoss() > 60)
		. += list("So... cold...", "Very... cold...")
	if(holder.body.getToxLoss() > 90)
		. += "C... c..."
	if(holder.slime.feeding_on)
		. += list("Nom...", "Tasty...")
	return pick(.)

/decl/slime_comment/hungry/get_comment(var/datum/ai/slime/holder)
	if(prob(2))
		. = list()
		var/tension = 10
		if(holder.slime.nutrition < holder.slime.get_hunger_nutrition()) 
			. += list("Hungry...", "Where is the food?", "I want to eat...")
			tension += 10
		if(holder.slime.nutrition < holder.slime.get_starve_nutrition())
			. += list("So... hungry...", "Very... hungry...", "Need... food...", "Must... eat...")
			tension += 10
		if(holder.current_target)
			. += "\The [holder.current_target]... looks tasty..."
		if(length(.) && prob(tension))
			return pick(.)

/decl/slime_comment/zap/get_comment(var/datum/ai/slime/holder)
	if(holder.slime.powerlevel > 3)
		. = list("Bzzz...")
		if(holder.slime.powerlevel > 5) 
			. += "Zap..."
		if(holder.slime.powerlevel > 8)
			. += "Zap... Bzz..."
		return pick(.)

/decl/slime_comment/rabid/get_comment(var/datum/ai/slime/holder)
	if (holder.rabid || holder.attacked)
		return pick("Hrr...", "Nhuu...", "Unn...")

/decl/slime_comment/friends/get_comment(var/datum/ai/slime/holder)
	var/slimes_near = 0
	var/dead_slimes = 0
	var/friends_near = list()
	for(var/mob/living/M in view(7, holder.body))
		if(M == holder.body)
			continue
		if(isslime(M))
			slimes_near++
			if(M.stat == DEAD)
				dead_slimes++
		if(weakref(M) in holder.observed_friends)
			friends_near += M
	. = list()
	if(slimes_near == 1)
		. += "Brother..."
	else if(slimes_near > 1)
		. += "Brothers..."
	else
		. += "Lonely..."
	if(dead_slimes)
		. += "What happened?"
	for(var/friend in friends_near)
		. += "\The [friend]... friend..."
		if(holder.slime.nutrition < holder.slime.get_hunger_nutrition())
			. += "\The [friend]... feed me..."
	if(length(.))
		return pick(.)
