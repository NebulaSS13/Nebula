/mob/living/simple_animal/hostile/commanded
	abstract_type = /mob/living/simple_animal/hostile/commanded
	natural_weapon = /obj/item/natural_weapon
	density = FALSE
	ai = /datum/mob_controller/aggressive/commanded

/mob/living/simple_animal/hostile/commanded/hear_say(datum/speech/phrases, verb = "says", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol, stars = FALSE, atom/relayed_by)
	ai?.memorise(speaker, phrases.unformatted_message)
	return ..()

/mob/living/simple_animal/hostile/commanded/hear_radio(datum/speech/phrases, verb = "says", part_a, part_b, part_c, mob/speaker, hard_to_hear = FALSE, vname = "", vsource, scramble = FALSE)
	ai?.memorise(speaker, phrases.unformatted_message)
	return ..()
