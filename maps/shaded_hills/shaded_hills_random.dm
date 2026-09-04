
/obj/random/hostile/cave
	name = "Random Hostile Cave Mob"
	spawn_nothing_percentage = 5

/obj/random/hostile/cave/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/giant_spider/guard/cave = 1,
		/mob/living/simple_animal/hostile/scarybat/cave = 4
	)
	return spawnable_choices

/obj/random/hostile/dungeon
	name = "Random Hostile Dungeon Mob"
	spawn_nothing_percentage = 5

/obj/random/hostile/dungeon/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/revenant
	)
	return spawnable_choices
