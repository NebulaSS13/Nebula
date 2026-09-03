/obj/random/spider
	name = "Random Spider" //Spiders should patrol where they spawn.
	desc = "This is a random boring spider."
	icon = /mob/living/simple_animal/hostile/giant_spider::icon
	icon_state = /mob/living/simple_animal/hostile/giant_spider::icon_state
//	mob_returns_home = 1
//	mob_wander_distance = 4

/obj/random/spider/spawn_choices()
	var/static/list/spooders = list(
		/mob/living/simple_animal/hostile/giant_spider/nurse  = 22,
		/mob/living/simple_animal/hostile/giant_spider/hunter = 33,
		/mob/living/simple_animal/hostile/giant_spider        = 45
	)
	return spooders

/obj/random/spider_nurse
	name = "Random Nurse Spider"
	desc = "This is a random nurse spider."
	icon = /mob/living/simple_animal/hostile/giant_spider/nurse::icon
	icon_state = /mob/living/simple_animal/hostile/giant_spider/nurse::icon_state
//	mob_returns_home = 1
//	mob_wander_distance = 4

// Overrides the vampiric item spawner.
/obj/random/evil_manifestation/Initialize()
	spawn_types = list(/obj/effect/spider/eggcluster)
	. = ..()

/obj/random/spider_nurse/spawn_choices()
	var/static/list/spooders = list(
		/mob/living/simple_animal/hostile/giant_spider/nurse
	)
	return spooders

/obj/machinery/auto_cloner/get_hostile_mob_types()
	. = ..() | /mob/living/simple_animal/hostile/giant_spider/nurse
