
/obj/random/sif
	name = "Random Sif Animal"
	desc = "This is a random cold weather animal."
	icon = /mob/living/simple_animal/hostile/siffet::icon
	icon_state = /mob/living/simple_animal/hostile/siffet::icon_state

/obj/random/sif/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/hostile/beast/diyaab       = 25,
		/mob/living/simple_animal/passive/rabbit/ice         = 20,
		/mob/living/simple_animal/fowl/duck/crystal          = 15,
		/mob/living/simple_animal/passive/glitterfly         = 10,
		/mob/living/simple_animal/passive/sakimm             = 10,
		/mob/living/simple_animal/hostile/beast/shantak      = 10,
		/mob/living/simple_animal/hostile/savik              = 5,
		/mob/living/simple_animal/passive/mouse              = 5,
		/mob/living/simple_animal/passive/crab/sif/hooligan  = 5,
		/mob/living/simple_animal/passive/glitterfly/rare    = 1
	)
	return spawn_choices

/obj/random/sif/aquatic
	name = "Random Aquatic Sif Animal"
	desc = "This is a random aquatic animal that can be found on Sivian shores."
	icon = /mob/living/simple_animal/passive/crab/sif::icon
	icon_state = /mob/living/simple_animal/passive/crab/sif::icon_state

/obj/random/sif/aquatic/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/passive/crab/sif          = 30,
		/mob/living/simple_animal/fowl/duck/crystal         = 25,
		/mob/living/simple_animal/hostile/beast/diyaab      = 15,
		/mob/living/simple_animal/passive/crab/sif/hooligan = 5,
		/mob/living/simple_animal/passive/karik             = 1
	)
	return spawn_choices

/obj/random/sif/peaceful
	name = "Random Peaceful Sif Animal"
	desc = "This is a random peaceful cold weather animal."
	icon = /mob/living/simple_animal/passive/glitterfly::icon
	icon_state = /mob/living/simple_animal/passive/glitterfly::icon_state

/obj/random/sif/peaceful/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/hostile/beast/diyaab    = 30,
		/mob/living/simple_animal/passive/rabbit/ice      = 20,
		/mob/living/simple_animal/passive/glitterfly      = 10,
		/mob/living/simple_animal/hostile/beast/shantak   = 10,
		/mob/living/simple_animal/passive/sakimm          = 10,
		/mob/living/simple_animal/passive/mouse           = 5,
		/mob/living/simple_animal/passive/glitterfly/rare = 1
	)
	return spawn_choices

/obj/random/sif/kururak
	name = "Random Kururak"
	desc = "This is a random kururak, either waking or hibernating. Will be hostile if more than one are waking."
	icon = /mob/living/simple_animal/passive/kururak::icon
	icon_state = /mob/living/simple_animal/passive/kururak::icon_state

/obj/random/sif/kururak/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/passive/kururak/hibernate = 1,
		/mob/living/simple_animal/passive/kururak           = 10
	)
	return spawn_choices

/obj/random/sif/hostile
	name = "Random Hostile Sif Animal"
	desc = "This is a random hostile cold weather animal."
	icon = /mob/living/simple_animal/hostile/savik::icon
	icon_state = /mob/living/simple_animal/hostile/savik::icon_state

/obj/random/sif/hostile/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/hostile/savik         = 22,
		/mob/living/simple_animal/hostile/frostfly      = 20,
		/mob/living/simple_animal/hostile/tymisian      = 10,
		/mob/living/simple_animal/hostile/beast/shantak = 25
	)
	return spawn_choices
