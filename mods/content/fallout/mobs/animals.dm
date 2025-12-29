/mob/living/simple_animal/hostile/fallout
	natural_weapon = /obj/item/natural_weapon/bite
	natural_armor = list()
	mob_size = MOB_SIZE_MEDIUM
	faction = "hostile"
	bleed_colour = COLOR_RED

/mob/living/simple_animal/hostile/fallout/molerat
	name = "molerat"
	desc = "A tiny rat."
	icon = 'mods/content/fallout/mobs/icons/animal/molerat.dmi'
	speak_emote = list("squeaks")
	harm_intent_damage = 5
	current_health = 40
	max_health = 40

/datum/mob_controller/hostile/fallout/molerat
	expected_type = /mob/living/simple_animal/hostile/fallout/molerat
	emote_hear   = list("squeaks",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0

/mob/living/simple_animal/hostile/fallout/feral_dog
	name = "feral dog"
	desc = "A dog, maybe infected by rabies."
	icon = 'mods/content/fallout/mobs/icons/animal/dog.dmi'
	speak_emote = list("barks")
	harm_intent_damage = 7
	current_health = 52
	max_health = 52

/datum/mob_controller/hostile/fallout/feral_dog
	expected_type = /mob/living/simple_animal/hostile/fallout/feral_dog
	emote_hear   = list("barks",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0

/mob/living/simple_animal/hostile/fallout/mirelurk
	name = "mirelurk"
	desc = "A crablike creature."
	icon = 'mods/content/fallout/mobs/icons/animal/mirelurk.dmi'
	speak_emote = list("chitters")
	harm_intent_damage = 7
	current_health = 70
	max_health = 70

/datum/mob_controller/hostile/fallout/mirelurk
	expected_type = /mob/living/simple_animal/hostile/fallout/mirelurk
	emote_hear   = list("chitters",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0

/mob/living/simple_animal/hostile/fallout/gecko
	name = "gecko"
	desc = "A mutated gecko."
	icon = 'mods/content/fallout/mobs/icons/animal/gecko.dmi'
	speak_emote = list("chirps")
	harm_intent_damage = 6
	current_health = 50
	max_health = 50

/datum/mob_controller/hostile/fallout/gecko
	expected_type = /mob/living/simple_animal/hostile/fallout/gecko
	emote_hear   = list("chirps",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0

/mob/living/simple_animal/hostile/fallout/radscorp
	name = "radscorpion"
	desc = "A scorpion."
	icon = 'mods/content/fallout/mobs/icons/animal/radscorp.dmi'
	speak_emote = list("chitters")
	harm_intent_damage = 12
	current_health = 40
	max_health = 40

/datum/mob_controller/hostile/fallout/radscorp
	expected_type = /mob/living/simple_animal/hostile/fallout/radscorp
	emote_hear   = list("chitters",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0

/mob/living/simple_animal/hostile/fallout/roach
	name = "radroach"
	desc = "A scorpion."
	icon = 'mods/content/fallout/mobs/icons/animal/roach.dmi'
	speak_emote = list("chitters")
	harm_intent_damage = 4
	current_health = 40
	max_health = 40

/datum/mob_controller/hostile/fallout/roach
	expected_type = /mob/living/simple_animal/hostile/fallout/roach
	emote_hear   = list("chitters",)
	speak_chance = 0.25
	turns_per_wander = 10
	stop_wander_when_pulled = 0
	can_escape_buckles = TRUE
	var/stance_step = 0