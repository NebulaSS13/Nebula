/mob/living/simple_animal/hostile/fallout/abomination
	name = "abomination"
	desc = "A disgusting almalgamation of human flesh and radioactive goo."
	icon = 'mods/content/fallout/mobs/icons/monster/abomination.dmi'
	speak_emote = list("moans")
	harm_intent_damage = 14
	current_health = 140
	max_health = 140

/mob/living/simple_animal/hostile/fallout/centaur
	name = "centaur"
	desc = "A disgusting almalgamation of human flesh and radioactive goo."
	icon = 'mods/content/fallout/mobs/icons/monster/centaur.dmi'
	speak_emote = list("groans")
	harm_intent_damage = 12
	current_health = 170
	max_health = 170

/datum/mob_controller/hostile/fallout/abomination
	expected_type = /mob/living/simple_animal/hostile/fallout/abomination
	emote_hear   = list("moans",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0

/datum/mob_controller/hostile/fallout/centaur
	expected_type = /mob/living/simple_animal/hostile/fallout/centaur
	emote_hear   = list("groans",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0