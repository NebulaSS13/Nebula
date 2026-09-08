/mob/living/simple_animal/hostile/giant_spider/tunneller
	icon = 'mods/mobs/spiders/icons/spider_tunneller.dmi'
	eye_color = "#ffd800"
	natural_weapon = /obj/item/natural_weapon/bite
	desc = "Sandy and brown, it makes you shudder to look at it. This one has glittering yellow eyes."
	max_health = 120
	poison_chance = 15
	poison_per_bite = 3
	ai = /datum/mob_controller/aggressive/giant_spider/tunneller
	available_maneuvers = list(/decl/maneuver/tunnel)
