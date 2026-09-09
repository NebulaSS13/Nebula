/datum/mob_controller/aggressive/giant_spider
	expected_type = /mob/living/simple_animal/hostile/giant_spider
	emote_hear = list("chitters")
	emote_see = list("rubs its forelegs together", "wipes its fangs", "stops suddenly")
	speak_chance = 1.25
	turns_per_wander = 10
	break_stuff_probability = 25
	alert_threatened_str = list(
		"$USER$ raises its forelegs at $TARGET$.",
		"$USER$ locks its eyes on $TARGET$."
	)
	var/hunt_chance = 1 //percentage chance the mob will run to a random nearby tile

/datum/mob_controller/aggressive/giant_spider/get_wander_candidates(turf/centre)
	if(prob(hunt_chance))
		return list(pick(orange(20, body)))
	. = ..()
