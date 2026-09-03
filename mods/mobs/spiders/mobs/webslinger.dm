// Webslingers do what their name implies, shoot web at enemies to slow them down.
/mob/living/simple_animal/hostile/giant_spider/ranged/webslinger
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes, and a cloak of web."
	icon = 'mods/mobs/spiders/icons/spider_slinger.dmi'
	eye_color = "#77ff9e"
	ai = /datum/mob_controller/aggressive/giant_spider/cautious
	max_health = 90
	projectilesound = 'sound/weapons/thudswoosh.ogg'
	poison_per_bite = 2
	poison_type = /decl/material/liquid/psychoactives
	natural_weapon = /obj/item/natural_weapon/bite/weak
	projectiletype = /obj/item/projectile/webball
