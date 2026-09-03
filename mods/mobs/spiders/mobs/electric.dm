// Electric spiders fire taser-like beams at their enemies.
/mob/living/simple_animal/hostile/giant_spider/ranged/electric
	desc = "Spined and yellow, it makes you shudder to look at it. This one has flickering gold eyes."
	icon = 'mods/mobs/spiders/icons/spider_electric.dmi'
	eye_color = "#ffd800"
	max_health = 210
	ai = /datum/mob_controller/aggressive/giant_spider/cautious
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/beam/stun/weak
	poison_chance = 15
	poison_per_bite = 3
	poison_type = /decl/material/liquid/accumulated/stimulants
