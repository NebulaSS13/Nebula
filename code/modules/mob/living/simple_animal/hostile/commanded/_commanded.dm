/mob/living/simple_animal/hostile/commanded
	abstract_type = /mob/living/simple_animal/hostile/commanded
	natural_weapon = /obj/item/natural_weapon
	density = FALSE
	ai = /datum/mob_controller/commanded

/mob/living/simple_animal/hostile/commanded/hear_say(datum/speech/phrases, verb = "says", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol, stars = FALSE, atom/relayed_by)
	ai?.memorise(speaker, phrases.unformatted_message)
	return ..()

/mob/living/simple_animal/hostile/commanded/hear_radio(datum/speech/phrases, verb = "says", part_a, part_b, part_c, mob/speaker, hard_to_hear = FALSE, vname = "", vsource, scramble = FALSE)
	ai?.memorise(speaker, phrases.unformatted_message)
	return ..()

/datum/mob_controller/commanded
	known_commands = list(
		/decl/mob_command/stay,
		/decl/mob_command/stop,
		/decl/mob_command/attack,
		/decl/mob_command/follow
	)
	target_scan_distance    = 10
	ai_flags                = AI_FLAG_WANDERS | AI_FLAG_AGGRESSIVE | AI_FLAG_ALERTS | AI_FLAG_CAUTIOUS | AI_FLAG_COMMANDED
	break_stuff_probability = 10
