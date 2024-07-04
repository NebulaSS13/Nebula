//Koala
/mob/living/simple_animal/koala
	name = "koala"
	desc = "A little grey bear. How long is he gonna sleep today?"
	icon = 'icons/mob/simple_animal/koala.dmi'
	max_health = 45
	speak_emote  = list("roar")
	see_in_dark = 6
	ai = /datum/mob_controller/koala

/datum/mob_controller/koala
	emote_speech = list("Rrr", "Wraarh...", "Pfrrr...")
	emote_hear   = list("grunting.","rustling.", "slowly yawns.")
	emote_see    = list("slowly turns around his head.", "rises to his feet, and lays to the ground on all fours.")
	speak_chance = 0.25
	turns_per_wander = 20
	stop_wander_when_pulled = TRUE
