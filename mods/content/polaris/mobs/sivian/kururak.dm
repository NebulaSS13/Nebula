/mob/living/simple_animal/passive/kururak
	name = "kururak"
	desc = "A large animal with sleek fur."
	icon = 'mods/content/polaris/icons/wildlife/kururak.dmi'
	default_pixel_x = -16
	max_health = 200
	base_movement_delay = 1
	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_RESISTANT,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_SMALL,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR,
		(ARMOR_BOMB)   = ARMOR_BOMB_MINOR,
		(ARMOR_BIO)    = ARMOR_BIO_SHIELDED,
		(ARMOR_RAD)    = ARMOR_RAD_SHIELDED
	)
	ai = /datum/mob_controller/passive/hunter/kururak

	// Special attack is a blinding flash.
/*
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_armor_pen = 40
	base_attack_cooldown = 2 SECONDS
	attacktext = list("gouged", "bit", "cut", "clawed", "whipped")
*/

/datum/mob_controller/passive/hunter/kururak
	emote_speech = list("Kurr?","|R|rrh..", "Ksss...")
	emote_see    = list("scratches its ear","flutters its tails", "flicks an ear", "shakes out its hair")
	emote_hear   = list("chirps", "clicks", "grumbles", "chitters")

/mob/living/simple_animal/passive/kururak/leader
	max_health = 250

/mob/living/simple_animal/passive/kururak/hibernate/Initialize()
	. = ..()
	set_posture(/decl/posture/lying)
