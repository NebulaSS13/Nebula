/mob/living/simple_animal/hostile/commanded
	abstract_type = /mob/living/simple_animal/hostile/commanded
	natural_weapon = /obj/item/natural_weapon
	density = FALSE
	ai = /datum/mob_controller/aggressive/commanded

/mob/living/simple_animal/hostile/commanded/hear_say(var/message, var/verb = "says", var/decl/language/language = null, var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	ai?.memorise(speaker, message)
	return ..()

/mob/living/simple_animal/hostile/commanded/hear_radio(var/message, var/verb="says", var/decl/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="", var/vsource)
	ai?.memorise(speaker, message)
	return ..()
