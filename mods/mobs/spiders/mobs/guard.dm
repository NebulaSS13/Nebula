/mob/living/simple_animal/hostile/giant_spider/guard
	desc = "A monstrously huge brown spider with shimmering eyes."
	butchery_data = /decl/butchery_data/animal/arthropod/giant_spider/guard
	max_health = 200
	natural_weapon = /obj/item/natural_weapon/bite/strong
	poison_per_bite = 5
	base_movement_delay = 2
	ai = /datum/mob_controller/aggressive/giant_spider/guard

/mob/living/simple_animal/hostile/giant_spider/guard/get_door_pry_time()
	return 6 SECONDS

/mob/living/simple_animal/hostile/giant_spider/guard/cave
	name = "giant cave spider"
	faction = "undead"
