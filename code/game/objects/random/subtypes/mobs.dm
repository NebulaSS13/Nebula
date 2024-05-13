/obj/random/mouse
	name = "Random Mouse"
	desc = "This is a random boring maus."
	icon = 'icons/mob/simple_animal/mouse_gray.dmi'
	icon_state = "world-resting"
	spawn_nothing_percentage = 15

/obj/random/mouse/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/passive/mouse/brown = 30,
		/mob/living/simple_animal/passive/mouse/gray  = 30,
		/mob/living/simple_animal/passive/mouse/white = 15
	)
	return spawnable_choices

/obj/random/hostile
	name = "Random Hostile Mob"
	desc = "This is a random hostile mob."
	icon = 'icons/mob/amorph.dmi'
	icon_state = "standing"
	spawn_nothing_percentage = 80

/obj/random/hostile/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/viscerator    = 20,
		/mob/living/simple_animal/hostile/carp          = 10,
		/mob/living/simple_animal/hostile/carp/pike     =  5,
		/mob/living/simple_animal/hostile/vagrant/swarm =  1
	)
	return spawnable_choices
