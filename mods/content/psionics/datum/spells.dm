/spell/cast_check(skipcharge = 0,mob/user = usr, var/list/targets) //checks if the spell can be cast based on its settings; skipcharge is used when an additional cast_check is called inside the spell
	var/spell_leech = user.disrupts_psionics()
	if(spell_leech)
		to_chat(user, SPAN_WARNING("You try to marshal your energy, but find it leeched away by \the [spell_leech]!"))
		return 0
	. = ..()
	