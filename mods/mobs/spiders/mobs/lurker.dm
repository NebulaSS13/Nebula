/obj/item/natural_weapon/bite/weak/lurker
	cloaked_bonus_damage = 30
	cloaked_weaken_amount = 3

/mob/living/simple_animal/hostile/giant_spider/lurker
	desc = "Translucent and white, it makes you shudder to look at it. This one has incandescent red eyes."
	icon = 'mods/mobs/spiders/icons/spider_lurker.dmi'
	eye_color = "#ff0000"
	max_health = 100
	poison_per_bite = 5
	base_movement_delay = -1
	ai = /datum/mob_controller/aggressive/giant_spider/ambush
	poison_chance = 30
	natural_weapon = /obj/item/natural_weapon/bite/weak/lurker
	poison_per_bite = 1
	poison_type = /decl/material/liquid/presyncopics
	can_use_cloak = TRUE
