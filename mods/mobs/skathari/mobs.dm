/obj/item/natural_weapon/skathari_claws
	_base_attack_force = 15
	armor_penetration = 15
	sharp = TRUE
	attack_verb = list("slashed")
	hitsound = 'sound/weapons/bladeslice.ogg'

/mob/living/simple_animal/hostile/skathari
	name = "skathari worker"
	desc = "Terrible insects from beyond this galaxy!"
	icon = 'mods/mobs/skathari/icons/skathari_worker.dmi'
	ai = /datum/mob_controller/aggressive/skathari
	max_health = 80
	faction = "skathari"
	natural_weapon = /obj/item/natural_weapon/skathari_claws
	projectiletype = /obj/item/projectile/energy/skathari
	_available_maneuvers = list(/decl/maneuver/teleport/skathari)
	ability_cooldown = 7 SECONDS

/mob/living/simple_animal/hostile/skathari/get_turn_sound()
	return pick('mods/mobs/skathari/sound/skath_chitter1.ogg', 'mods/mobs/skathari/sound/skath_chitter2.ogg')

/mob/living/simple_animal/hostile/skathari/has_ranged_attack(atom/target)
	. = ..() && get_dist(src, target) > 1

/mob/living/simple_animal/hostile/skathari/soldier
	name = "skathari soldier"
	icon = 'mods/mobs/skathari/icons/skathari_soldier.dmi'
	max_health = 120
	_available_maneuvers = list(/decl/maneuver/teleport/skathari/soldier)
	natural_weapon = /obj/item/natural_weapon/skathari_claws/soldier

/obj/item/natural_weapon/skathari_claws/soldier
	_base_attack_force = 30

/mob/living/simple_animal/hostile/skathari/queen
	name = "skathari tyrant"
	desc = "Sweet mother of bugs!"
	max_health = 600
	base_movement_delay = 10
	default_pixel_x = -32
	default_pixel_y = -16
	_available_maneuvers = list(/decl/maneuver/teleport/skathari/tyrant)
	natural_weapon = /obj/item/natural_weapon/skathari_claws/tyrant
	icon = 'mods/mobs/skathari/icons/skathari_tyrant.dmi'

/obj/item/natural_weapon/skathari_claws/tyrant
	_base_attack_force = 20
