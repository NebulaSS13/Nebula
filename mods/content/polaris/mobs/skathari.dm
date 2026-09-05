/datum/mob_controller/aggressive/skathari

/mob/living/simple_animal/hostile/skathari
	name = "skathari worker"
	desc = "Terrible insects from beyond this galaxy!"
	icon = 'mods/content/polaris/icons/skathari/skathari_worker.dmi'
	ai = /datum/mob_controller/aggressive/skathari
	max_health = 80
	faction = "skathari"
	// Special ability is teleportation.
	var/teleport_distance = 5 /// How far away to be when we teleport.
/*
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	projectiletype = /obj/item/projectile/energy/skathari
	attacktext = list("slashed")
*/

/mob/living/simple_animal/hostile/skathari/soldier
	name = "skathari soldier"
	icon = 'mods/content/polaris/icons/skathari/skathari_soldier.dmi'
	max_health = 120
	teleport_distance = 1
/*
	melee_damage_lower = 25
	melee_damage_upper = 35
*/

/mob/living/simple_animal/hostile/skathari/queen
	name = "skathari tyrant"
	desc = "Sweet mother of bugs!"
	max_health = 600
	base_movement_delay = 10
	default_pixel_x = -32
	default_pixel_y = -16
	teleport_distance = 3 // Will encourage mix of ranged and melee attacks.
/*
	melee_damage_lower = 15
	melee_damage_upper = 25
*/