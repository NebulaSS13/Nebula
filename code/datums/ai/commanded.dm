/datum/mob_controller/aggressive/commanded
	stance = STANCE_COMMANDED_STOP
	var/list/command_buffer = list()
	var/list/known_commands = list("stay", "stop", "attack", "follow")
	/// undisputed master. Their commands hold ultimate sway and ultimate power.
	var/mob/master = null
	/// Lazylist of acceptable target weakrefs as designated by our master (or 'everyone').
	var/list/_allowed_targets
	/// whether or not they will attack us if we attack them like some kinda dick.
	var/retribution = TRUE

/datum/mob_controller/aggressive/commanded/do_process(time_elapsed)

	if(!(. = ..()) || body.stat)
		return

	while(command_buffer.len > 1)
		var/mob/speaker = command_buffer[1]
		var/message = command_buffer[2]
		var/filtered_name = lowertext(html_decode(body.name))
		if(dd_hasprefix(message,filtered_name) || dd_hasprefix(message,"everyone") || dd_hasprefix(message, "everybody")) //in case somebody wants to command 8 bears at once.
			var/substring = copytext(message,length(filtered_name)+1) //get rid of the name.
			listen(speaker,substring)
		command_buffer.Remove(command_buffer[1],command_buffer[2])

	switch(stance)
		if(STANCE_COMMANDED_FOLLOW)
			follow_target()
		if(STANCE_COMMANDED_STOP)
			commanded_stop()

/datum/mob_controller/aggressive/commanded/proc/listen(var/mob/speaker, var/message)
	for(var/command in known_commands)
		if(findtext(message, command))
			switch(command)
				if("stay")
					if(stay_command(speaker,message)) //find a valid command? Stop. Dont try and find more.
						break
				if("stop")
					if(stop_command(speaker,message))
						break
				if("attack")
					if(attack_command(speaker,message))
						break
				if("follow")
					if(follow_command(speaker,message))
						break
				else
					misc_command(speaker,message) //for specific commands
	return TRUE

/datum/mob_controller/aggressive/commanded/proc/attack_command(var/mob/speaker,var/message)
	set_target(null) //want me to attack something? Well I better forget my old target.
	set_stance(STANCE_IDLE)
	body.stop_automove()
	if(message == "attack" || findtext(message,"everyone") || findtext(message,"anybody") || findtext(message, "somebody") || findtext(message, "someone")) //if its just 'attack' then just attack anybody, same for if they say 'everyone', somebody, anybody. Assuming non-pickiness.
		_allowed_targets = list("everyone")//everyone? EVERYONE
		return 1
	var/list/targets = get_targets_by_name(message)
	if(length(targets))
		LAZYDISTINCTADD(_allowed_targets, targets)
	return targets.len != 0

/datum/mob_controller/aggressive/commanded/proc/stay_command(var/mob/speaker,var/message)
	set_target(null)
	set_stance(STANCE_COMMANDED_STOP)
	stop_wandering()
	body.stop_automove()
	return 1

/datum/mob_controller/aggressive/commanded/proc/stop_command(var/mob/speaker,var/message)
	LAZYCLEARLIST(_allowed_targets)
	body.stop_automove()
	set_target(null)
	set_stance(STANCE_IDLE)
	resume_wandering()
	return 1

/datum/mob_controller/aggressive/commanded/proc/follow_command(var/mob/speaker,var/message)
	//we can assume 'stop following' is handled by stop_command
	if(findtext(message,"me"))
		set_stance(STANCE_COMMANDED_FOLLOW)
		set_target(speaker) //this wont bite me in the ass later.
		return 1
	var/list/targets = get_targets_by_name(message)
	if(LAZYLEN(targets) != 1) //CONFUSED. WHO DO I FOLLOW?
		return 0
	var/weakref/target_ref = targets[1]
	set_target(target_ref.resolve()) //YEAH GOOD IDEA
	set_stance(STANCE_COMMANDED_FOLLOW) //GOT SOMEBODY. BETTER FOLLOW EM.
	return 1

/datum/mob_controller/aggressive/commanded/proc/misc_command(var/mob/speaker,var/message)
	return 0

/datum/mob_controller/aggressive/commanded/proc/follow_target()
	if(!body || body.stat)
		return
	stop_wandering()
	var/atom/target = get_target()
	if(istype(target) && (target in list_targets(10)))
		body.start_automove(target)

/datum/mob_controller/aggressive/commanded/proc/commanded_stop() //basically a proc that runs whenever we are asked to stay put. Probably going to remain unused.
	return

//returns a list of everybody we wanna do stuff with.
/datum/mob_controller/aggressive/commanded/proc/get_targets_by_name(var/message, var/filter_friendlies = 0)
	var/list/possible_targets = hearers(body, 10)
	for(var/mob/M in possible_targets)
		if((filter_friendlies && is_friend(M)) || M.faction == body.faction || M == master)
			continue
		var/found = 0
		if(findtext(message, "[M]"))
			found = 1
		else
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("[M]")),list("-"=" ", "."=" ", "," = " ", "'" = " ")), " ") //this big MESS is basically 'turn this into words, no punctuation, lowercase so we can check first name/last name/etc'
			for(var/a in parsed_name)
				if(a == "the" || length(a) < 2) //get rid of shit words.
					continue
				if(findtext(message,"[a]"))
					found = 1
					break
		if(found)
			LAZYADD(., weakref(M))

/datum/mob_controller/aggressive/commanded/find_target()
	if(!LAZYLEN(_allowed_targets))
		return null
	var/mode = "specific"
	if(LAZYACCESS(_allowed_targets, 1) == "everyone") //we have been given the golden gift of murdering everything. Except our master, of course. And our friends. So just mostly everyone.
		mode = "everyone"
	for(var/atom/A in list_targets(10))
		if(A == src)
			continue
		if(isliving(A))
			var/mob/M = A
			if(M.stat || M == master || is_friend(M))
				continue
		if(mode == "specific" && !(weakref(A) in _allowed_targets))
			continue
		set_stance(STANCE_ATTACK)
		return A

/datum/mob_controller/aggressive/commanded/retaliate(atom/source)
	//assume he wants to hurt us.
	if(isliving(source) && !retribution)
		return
	if((. = ..()) && isliving(source))
		LAZYDISTINCTADD(_allowed_targets, weakref(source))

/datum/mob_controller/aggressive/commanded/memorise(mob/speaker, message)
	if(is_friend(speaker) || speaker == master)
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
