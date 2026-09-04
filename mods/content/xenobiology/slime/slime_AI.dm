/datum/mob_controller/slime
	expected_type = /mob/living/slime
	var/mood
	var/chase_target = 0
	var/weakref/leader
	var/weakref/current_target // Currently attacking this mob (separate from feeding)
	var/attacked = 0 // Determines if it's been attacked recently. Can be any number, is a cooloff-ish variable
	var/rabid = 0 // If set to 1, the slime will attack and eat anything it comes in contact with
	var/list/observed_friends // A list of refs to friends; they are not considered targets for feeding; passed down after splitting.
	var/list/friendship_cooldown // A list of refs to friends and the next time they can increase friendship.
	var/list/speech_buffer // Last phrase said near it and person who said it
	var/mob/living/slime/slime
	var/next_core_logic_run = 0
	var/holding_still = 0 // AI variable, cooloff-ish for how long it's going to stay in one place

/datum/mob_controller/slime/New()
	..()
	slime = body

/datum/mob_controller/slime/Destroy()
	observed_friends = null
	friendship_cooldown = null
	leader = null
	current_target = null
	speech_buffer = null
	slime = null
	. = ..()

/datum/mob_controller/slime/proc/assess_target(var/mob/living/target)
	if(!istype(target) || isslime(target) || (weakref(target) in observed_friends))
		return FALSE
	if(target.stat != DEAD && (rabid || attacked))
		return TRUE
	if(slime.check_valid_feed_target(target) == FEED_RESULT_VALID)
		return TRUE
	return FALSE

/datum/mob_controller/slime/proc/update_mood()
	if(!slime || !body)
		return
	body.set_intent(I_FLAG_HELP)
	var/new_mood
	if(HAS_STATUS(body, STAT_CONFUSE))
		new_mood = "pout"
	else if(rabid || attacked)
		new_mood = "angry"
		body.set_intent(I_FLAG_HARM)
	else if(current_target?.resolve())
		new_mood = "mischevous"

	if(!new_mood)
		if(prob(1))
			new_mood = pick("sad", ":3")
		else if(prob(75))
			new_mood = mood

	if(new_mood != mood)
		mood = new_mood
		body.update_icon()

/datum/mob_controller/slime/do_process(time_elapsed)

	if(!(. = ..()))
		return

	if(attacked > 0)
		attacked = clamp(attacked--, 0, 50)

	if(!slime || body.stat || HAS_STATUS(slime, STAT_CONFUSE))
		return

	// A hungry slime begins losing its friends.
	if(slime.nutrition < slime.get_starve_nutrition() && length(observed_friends) && prob(1))
		adjust_friendship(pick(observed_friends), -1)

	handle_targets()
	if(world.time >= next_core_logic_run)
		handle_core_logic()
	handle_speech_and_mood()

/datum/mob_controller/slime/proc/get_best_target(var/list/targets)
	if(!length(targets))
		return
	if(rabid || attacked)
		return pick(targets)
	targets = shuffle(targets)
	for(var/mob/living/M in targets)
		if(issmall(M))
			return M
	. = targets[1]

/datum/mob_controller/slime/proc/handle_targets()

	if(!slime || !body)
		return

	if(slime.feeding_on)
		current_target = null
		return

	var/mob/actual_target = current_target?.resolve()
	if(actual_target)
		chase_target--
		if(chase_target <= 0 || attacked || rabid) // Tired of chasing or attacking everything nearby
			chase_target = 0
			current_target = null
	else
		current_target = null

	var/hunger = slime.get_hunger_state()
	var/mob/leader_mob = leader?.resolve()
	actual_target = current_target?.resolve()
	if(!actual_target)
		var/feral = (attacked || rabid || hunger >= 2)
		if(feral || (!leader_mob && !holding_still) || (hunger && prob(10)))
			var/list/targets
			for(var/mob/living/prey in view(7, body))
				if(assess_target(prey))
					LAZYADD(targets, prey)
			if(length(targets))
				current_target = weakref(get_best_target(targets))
				chase_target = rand(5,7)
				if(slime.is_adult)
					chase_target += 3

	if(holding_still)
		holding_still = max(holding_still - 1 - hunger, 0)
	else if(isturf(body?.loc))
		if(leader_mob)
			step_to(body, get_dir(body, leader_mob))
		else if(prob(hunger ? 50 : 33))
			body.SelfMove(pick(global.cardinal))

/datum/mob_controller/slime/proc/handle_core_logic()

	if(!slime || !body)
		return

	var/added_delay = 0
	var/mob/actual_target = current_target?.resolve()
	if(slime.amount_grown >= SLIME_EVOLUTION_THRESHOLD && !actual_target)
		if(slime.is_adult)
			slime.slime_split()
		else
			slime.slime_mature()
		added_delay = 10
	else
		if(!assess_target(actual_target) || actual_target == slime.feeding_on || !(actual_target in view(7, body)))
			current_target = null

		if(!actual_target)
			if(prob(1))
				for(var/mob/living/slime/frenemy in range(1, body))
					if(frenemy != body && body.Adjacent(frenemy))
						body.set_intent((frenemy.slime_type == slime.slime_type) ? I_FLAG_HELP : I_FLAG_HARM)
						body.UnarmedAttack(frenemy, TRUE)
						added_delay = 10
		else if(slime.Adjacent(actual_target))
			var/do_attack = FALSE
			if(issilicon(actual_target))
				body.set_intent(I_FLAG_HARM)
				do_attack = TRUE
			else if(actual_target.client && !actual_target.current_posture.prone && prob(60 + slime.powerlevel * 4))
				body.set_intent(I_FLAG_DISARM)
				do_attack = TRUE
			else if(slime.check_valid_feed_target(actual_target) == FEED_RESULT_VALID)
				body.set_intent(I_FLAG_GRAB)
				do_attack = TRUE
			if(do_attack)
				body.UnarmedAttack(actual_target, TRUE)
				added_delay = 10
			else
				current_target = null
		else
			step_to(body, actual_target)

	next_core_logic_run = world.time + max(body?.get_movement_delay(), 5) + added_delay

/datum/mob_controller/slime/proc/handle_speech_and_mood()

	if(!slime || !body)
		return

	update_mood()

	if(length(speech_buffer))

		var/speaker = speech_buffer[1]       // Who said it?
		var/spoken =  speech_buffer[speaker] // What did they say?
		speech_buffer = null

		if(findtext(spoken, num2text(slime.number)) || findtext(spoken, "slimes"))
			var/list/all_slime_commands = decls_repository.get_decls_of_subtype(/decl/slime_command)
			for(var/command_type in all_slime_commands)
				var/decl/slime_command/command = all_slime_commands[command_type]
				var/response = command.resolve(speaker, spoken, src)
				if(response)
					body.say(response)
					return

	if(prob(1))
		if(prob(50))
			body.emote(pick(/decl/emote/visible/bounce, /decl/emote/visible/sway, /decl/emote/visible/lightup, /decl/emote/visible/vibrate, /decl/emote/visible/jiggle))
		else
			var/list/possible_comments
			var/list/all_slime_comments = decls_repository.get_decls_of_subtype(/decl/slime_comment)
			for(var/comment_type in all_slime_comments)
				var/decl/slime_comment/comment = all_slime_comments[comment_type]
				var/comment_text = comment.get_comment(src)
				if(comment_text)
					LAZYADD(possible_comments, comment_text)
			if(length(possible_comments))
				body.say(pick(possible_comments))

/datum/mob_controller/slime/proc/adjust_friendship(var/atom/user, var/amount)
	if(ismob(user))
		if(QDELING(user))
			return FALSE
		user = weakref(user)
	else if(istype(user, /weakref)) // verify the ref is still valid
		var/weakref/user_ref = user
		var/mob/resolved_user = user_ref.resolve()
		if(!ismob(resolved_user) || QDELING(resolved_user))
			return FALSE
	else
		return FALSE

	if(amount > 0)
		if(world.time < LAZYACCESS(friendship_cooldown, user))
			return FALSE
		LAZYSET(friendship_cooldown, user, world.time + (1 MINUTE))
	LAZYINITLIST(observed_friends)
	observed_friends[user] = observed_friends[user] + amount
	if(observed_friends[user] <= 0)
		LAZYREMOVE(observed_friends, user)
	return TRUE
