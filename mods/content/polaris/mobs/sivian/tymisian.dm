/mob/living/simple_animal/hostile/tymisian
	name = "\improper Tymisian moth"
	desc = "A huge, fuzzy insect with a disorienting dust."
	icon = 'mods/content/polaris/icons/wildlife/tymisian.dmi'
	ai = /datum/mob_controller/aggressive/tymisian
	max_health = 80

	// Special attack is smokescreen.
	// projectiletype = /obj/item/projectile/energy/blob

/*
	melee_damage_lower = 5
	melee_damage_upper = 10
	base_attack_cooldown = 1.5 SECONDS
	attacktext = list("nipped", "bit", "pinched")
*/

/datum/mob_controller/aggressive/tymisian
	emote_speech = list("Zzzz.", "Rrr...", "Zzt?")
	emote_see    = list("grooms itself","sprinkles dust from its wings", "rubs its mandibles")
	emote_hear   = list("chitters", "clicks", "rattles")
