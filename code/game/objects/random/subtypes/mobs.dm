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

/obj/random/fish
	name = "Random Fish"
	desc = "This is a random fish. Glub glub."
	icon = 'icons/mob/simple_animal/fish_salmon.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/fish/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/aquatic/fish               = 10,
		/mob/living/simple_animal/aquatic/fish/grump         = 10,
		/obj/item/mollusc                                    = 5,
		/obj/item/mollusc/barnacle/fished                    = 5,
		/mob/living/simple_animal/aquatic/fish/large         = 5,
		/mob/living/simple_animal/aquatic/fish/large/bass    = 5,
		/mob/living/simple_animal/aquatic/fish/large/salmon  = 5,
		/mob/living/simple_animal/aquatic/fish/large/trout   = 5,
		/mob/living/simple_animal/aquatic/fish/large/pike    = 3,
		/mob/living/simple_animal/aquatic/fish/large/javelin = 3,
		/obj/item/mollusc/clam/fished/pearl                  = 3,
		/obj/item/trash/mollusc_shell/clam                   = 2,
		/obj/item/trash/mollusc_shell/barnacle               = 2,
		/obj/item/trash/mollusc_shell                        = 1,
		/mob/living/simple_animal/aquatic/fish/large/koi     = 1
	)
	return spawnable_choices

/obj/random/drone
	name = "Random Drone"
	desc = "This is a random combat drone. Beep boop."
	icon = 'icons/mob/simple_animal/drones/combat.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/drone/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/malf_drone/lesser = 10,
		/mob/living/simple_animal/hostile/malf_drone        = 6,
		/mob/living/simple_animal/hostile/malf_drone/mining = 3
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

/obj/random/hostile/dungeon
	name = "Random Hostile Dungeon Mob"
	spawn_nothing_percentage = 5

/obj/random/hostile/dungeon/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/revenant
	)
	return spawnable_choices

/obj/random/hostile/cave
	name = "Random Hostile Cave Mob"
	spawn_nothing_percentage = 5

/obj/random/hostile/cave/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/giant_spider/guard/cave = 1,
		/mob/living/simple_animal/hostile/scarybat/cave = 4
	)
	return spawnable_choices

/obj/random/hostile/hivebot
	name = "Random Hivebot"
	icon = /mob/living/simple_animal/hostile/hivebot::icon
	icon_state = /mob/living/simple_animal/hostile/hivebot::icon_state

/obj/random/hostile/hivebot/spawn_choices()
	var/static/list/spawnable_choices = typesof(/mob/living/simple_animal/hostile/hivebot)
	return spawnable_choices

/obj/random/hostile/hivebot/melee
	name = "Random Melee Hivebot"

/obj/random/hostile/hivebot/melee/spawn_choices()
	var/static/list/spawnable_choices = typesof(/mob/living/simple_animal/hostile/hivebot/melee)
	return spawnable_choices

/obj/random/hostile/hivebot/ranged
	name = "Random Ranged Hivebot"

/obj/random/hostile/hivebot/ranged/spawn_choices()
	var/static/list/spawnable_choices = typesof(/mob/living/simple_animal/hostile/hivebot/ranged)
	return spawnable_choices
