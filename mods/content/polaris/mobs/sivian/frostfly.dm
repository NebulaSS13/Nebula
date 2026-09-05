/mob/living/simple_animal/hostile/frostfly
	name = "frostfly"
	desc = "A large insect with glittering wings."
	icon = 'mods/content/polaris/icons/wildlife/frostfly.dmi'
	ai = /datum/mob_controller/aggressive/frostfly
	max_health = 65
	base_movement_delay = -1
	pass_flags = PASS_FLAG_TABLE
	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_KNIVES,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_MINOR,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_BOMB)   = ARMOR_BOMB_MINOR,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)
	//projectiletype = /obj/item/projectile/energy/blob/freezing // Splats the target with reagents
	// Special ability is making a smokescreen.
/*
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = list("nipped", "bit", "pinched")
	base_attack_cooldown = 1.5 SECONDS
*/

/datum/mob_controller/aggressive/frostfly
	emote_speech = list("Zzzz.", "Kss.", "Zzt?")
	emote_see    = list("flutters its wings","looks around", "rubs its mandibles")
	emote_hear   = list("chitters", "clicks", "chirps")
