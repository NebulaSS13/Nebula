/mob/living/simple_animal/hostile/hivebot/ranged
	desc = "A junky looking robot with four spiky legs. It's equipped with some kind of small-bore gun."
	base_movement_delay = 2
	icon = 'icons/mob/simple_animal/hivebots/hivebot_white.dmi'
	projectiletype = /obj/item/projectile/bullet/pellet
	projectilesound = 'sound/weapons/gunshot/gunshot_pistol.ogg'

/mob/living/simple_animal/hostile/hivebot/ranged/has_ranged_attack()
	return TRUE

/mob/living/simple_animal/hostile/hivebot/ranged/rapid
	name = "rapid hivebot"
	desc = "A robot with a crude but deadly integrated rifle."
	attack_delay = 5 // Two attacks a second or so.
	burst_projectile = TRUE

/mob/living/simple_animal/hostile/hivebot/ranged/laser
	name = "laser hivebot"
	desc = "A robot with a photonic weapon integrated into itself."
	projectiletype = /obj/item/projectile/beam/blue
	projectilesound = 'sound/weapons/Laser.ogg'

/mob/living/simple_animal/hostile/hivebot/ranged/heat
	name = "ember hivebot"
	desc = "A robot that appears to utilize fire to cook their enemies."
	icon_state = "red"
	icon = 'icons/mob/simple_animal/hivebots/hivebot_red.dmi'
	projectiletype = /obj/item/projectile/fireball
	projectilesound = 'sound/effects/bamf.ogg'
