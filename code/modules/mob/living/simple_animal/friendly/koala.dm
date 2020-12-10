//Koala
/mob/living/simple_animal/koala
	name = "koala"
	desc = "A little grey bear. How much he gonna sleep today?"
	icon = 'icons/mob/simple_animal/koala.dmi'
	icon_state = "koala"
	icon_living = "koala"
	icon_dead = "koala_dead"
	maxHealth = 45
	health = 45
	speed = 4
	speak = list("Rrr", "Wraarh...", "Pfrrr...")
	speak_emote = list("roar")
	emote_hear = list("grunting.","rustling.", "slowly yawns.")
	emote_see = list("slowly turns around his head.", "rises to his feet, and lays to the ground on all fours.")
	speak_chance = 1
	turns_per_move = 10 //lazy
	see_in_dark = 6
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	stop_automated_movement_when_pulled = 1
