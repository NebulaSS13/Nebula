/mob/living/simple_animal/hostile/hivebot/melee
	natural_weapon = /obj/item/natural_weapon/drone_slicer/prod
	projectiletype = null // To force the AI to melee.
	base_movement_delay = 10

/obj/item/natural_weapon/drone_slicer/prod
	name = "hivebot prod"
	attack_verb = list("prodded")
	hitsound = 'sound/weapons/Egloves.ogg'

/mob/living/simple_animal/hostile/hivebot/melee/has_ranged_attack()
	return FALSE

// This one is tanky by having a massive amount of health.
/mob/living/simple_animal/hostile/hivebot/melee/meatshield
	name = "bulky hivebot"
	desc = "A large robot."
	max_health = 300
	icon_scale_x = 1.1
	icon_scale_y = 1.1
