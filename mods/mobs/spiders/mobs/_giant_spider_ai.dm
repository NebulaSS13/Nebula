/datum/mob_controller/aggressive/giant_spider
	expected_type = /mob/living/simple_animal/hostile/giant_spider
	emote_hear = list("chitters")
	emote_see = list("rubs its forelegs together", "wipes its fangs", "stops suddenly")
	speak_chance = 1.25
	turns_per_wander = 10
	break_stuff_probability = 25
	var/hunt_chance = 1 //percentage chance the mob will run to a random nearby tile

/datum/mob_controller/aggressive/giant_spider/find_target()
	. = ..()
	if(.)
		if(!body.has_ranged_attack()) //ranged mobs find target after each shot, dont need this spammed quite so much
			body.custom_emote(VISIBLE_MESSAGE, "raises its forelegs at [.]")
		else if(prob(15))
			body.custom_emote(VISIBLE_MESSAGE, "locks its eyes on [.]")

/datum/mob_controller/aggressive/giant_spider/do_process()
	if(!(. = ..()) || body.stat || !istype(body, /mob/living/simple_animal/hostile/giant_spider))
		return
	if(get_stance() == STANCE_IDLE)
		//chance to skitter madly away
		if(get_activity() == AI_ACTIVITY_IDLE && prob(hunt_chance))
			stop_wandering()
			body.start_automove(pick(orange(20, body)))
			addtimer(CALLBACK(body, TYPE_PROC_REF(/mob/living/simple_animal/hostile/giant_spider, disable_stop_automated_movement)), 5 SECONDS)
