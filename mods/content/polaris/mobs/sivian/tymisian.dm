/mob/living/simple_animal/hostile/tymisian
	name = "\improper Tymisian moth"
	desc = "A huge, fuzzy insect with a disorienting dust."
	icon = 'mods/content/polaris/icons/wildlife/tymisian.dmi'
	ai = /datum/mob_controller/aggressive/tymisian
	max_health = 80

	ability_cooldown = 10 SECONDS
	ability_system = /datum/effect/effect/system/smoke_spread/spore
	_available_maneuvers = list(/decl/maneuver/smokescreen)
	projectiletype = /obj/item/projectile/energy/blob
	natural_weapon = /obj/item/natural_weapon/tymisian_pincers

/obj/item/natural_weapon/tymisian_pincers
	_base_attack_force = 8
	attack_cooldown = 1.5 SECONDS
	attack_verb = list("nipped", "bit", "pinched")

/datum/mob_controller/aggressive/tymisian
	emote_speech = list("Zzzz.", "Rrr...", "Zzt?")
	emote_see    = list("grooms itself","sprinkles dust from its wings", "rubs its mandibles")
	emote_hear   = list("chitters", "clicks", "rattles")
