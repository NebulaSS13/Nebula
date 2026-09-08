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
	var/movement_shake_radius = 5

	natural_armor = list(
		(ARMOR_MELEE)  = ARMOR_MELEE_MAJOR,
		(ARMOR_BULLET) = ARMOR_BALLISTIC_SMALL,
		(ARMOR_LASER)  = ARMOR_LASER_MINOR
	)
	butchery_data = /decl/butchery_data/animal/arthropod/crab/giant
	natural_weapon = /obj/item/natural_weapon/crab_claws

/mob/living/simple_animal/passive/crab/sif/hooligan/SelfMove(turf/n, direct, movetime)
	. = ..()
	if(.)
		for(var/mob/living/viewer in range(movement_shake_radius, src))
			shake_camera(viewer, 1)

/mob/living/simple_animal/passive/crab/sif/hooligan/get_footstep_sound(turf/step_turf)
	return 'sound/weapons/heavysmash.ogg'

/obj/item/natural_weapon/crab_claws
	name = "giant claw"
	_base_attack_force = 25

	sharp = TRUE
	attack_verb = list("clawed", "pinched", "crushed")
	armor_penetration = 35
	attack_cooldown = 1 SECOND
