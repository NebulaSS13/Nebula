/mob/living/slime/physically_destroyed()
	if(is_adult)
		var/datum/ai/slime/my_ai = ai
		var/decl/slime_colour/slime_data = GET_DECL(slime_type)
		var/list/babies = list()
		for(var/i in 1 to 2)
			var/mob/living/slime/baby = new slime_data.child_type(loc, slime_type)
			var/datum/ai/slime/baby_ai = baby.ai
			if(istype(my_ai) && istype(baby_ai))
				baby_ai.rabid = TRUE
				baby_ai.observed_friends = my_ai.observed_friends?.Copy()
			step_away(baby, src)
			babies += baby
		if(mind)
			mind.transfer_to(pick(babies))
		else if(key)
			var/mob/my_baby = pick(babies)
			my_baby.key = key
	qdel(src)

/mob/living/slime/death(gibbed, deathmessage, show_dead_message)
	if(stat != DEAD && !gibbed && is_adult)
		physically_destroyed()
		return TRUE
	. = ..(gibbed, deathmessage, show_dead_message)
	if(stat == DEAD)
		set_feeding_on()
		for(var/atom/movable/AM in contents)
			AM.dropInto(loc)
