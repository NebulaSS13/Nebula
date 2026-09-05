/mob/living/simple_animal/passive/crab/sif
	var/crab_scale

/mob/living/simple_animal/passive/crab/sif/Initialize()
	. = ..()
	set_scale(crab_scale || set_scale(rand(5,12) / 10))

/mob/living/simple_animal/passive/crab/sif/hooligan
	name = "hooligan crab"
	desc = "A large, hard-shelled crustacean. This one is mostly grey. You probably shouldn't mess with it."
	icon = 'mods/content/polaris/icons/wildlife/hooligan_crab.dmi'
	crab_scale = 1.5
	max_health = 200
	base_movement_delay = 10
	mob_size = MOB_SIZE_LARGE

	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_MAJOR,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_SMALL,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR
	)
/*

	taser_kill = FALSE

	melee_damage_lower = 22
	melee_damage_upper = 35
	attack_armor_pen = 35
	attack_sharp = TRUE
	attack_edge = TRUE
	melee_attack_delay = 1 SECOND	attacktext = list("clawed", "pinched", "crushed")

	movement_cooldown = 10
	movement_sound = 'sound/weapons/heavysmash.ogg'
	movement_shake_radius = 5
*/