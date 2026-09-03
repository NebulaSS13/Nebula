
/obj/random/sif
	name = "Random Sif Animal"
	desc = "This is a random cold weather animal."
	icon_state = "animal"

	//mob_returns_home = 1
	//mob_wander_distance = 10

/obj/random/sif/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/hostile/beast/diyaab       = 25,
		/mob/living/simple_animal/passive/rabbit/ice               = 20,
		//mob/living/simple_animal/fowl/duck/crystal                   = 15,
		/mob/living/simple_animal/passive/glitterfly             = 10,
		/mob/living/simple_animal/passive/sakimm                 = 10,
		/mob/living/simple_animal/hostile/beast/shantak      = 10,
		/mob/living/simple_animal/passive/savik                  = 5,
		/mob/living/simple_animal/passive/mouse              = 5,
		/mob/living/simple_animal/passive/crab/hooligan          = 5,
		/mob/living/simple_animal/hostile/giant_spider/frost = 2,
		/mob/living/simple_animal/passive/glitterfly/rare        = 1
	)
	return spawn_choices

/obj/random/sif/aquatic
	name = "Random Aquatic Sif Animal"
	desc = "This is a random aquatic animal that can be found on Sivian shores."
	icon_state = "animal"

/obj/random/sif/aquatic/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/crab/sif             = 30,
		//mob/living/simple_animal/fowl/duck/crystal             = 25,
		/mob/living/simple_animal/hostile/beast/diyaab = 15,
		/mob/living/simple_animal/passive/crab/hooligan    = 5,
		/mob/living/simple_animal/passive/karik        = 1
	)
	return spawn_choices

/obj/random/sif/peaceful
	name = "Random Peaceful Sif Animal"
	desc = "This is a random peaceful cold weather animal."
	icon_state = "animal_passive"

/obj/random/sif/peaceful/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/hostile/beast/diyaab            = 30,
		/mob/living/simple_animal/passive/rabbit/ice                    = 20,
		/mob/living/simple_animal/passive/glitterfly                  = 10,
		/mob/living/simple_animal/hostile/beast/shantak/retaliate = 10,
		/mob/living/simple_animal/passive/sakimm                      = 10,
		/mob/living/simple_animal/passive/mouse                   = 5,
		/mob/living/simple_animal/passive/glitterfly/rare             = 1
	)
	return spawn_choices

/obj/random/sif/kururak
	name = "Random Kururak"
	desc = "This is a random kururak, either waking or hibernating. Will be hostile if more than one are waking."
	icon_state = "frost"

/obj/random/sif/kururak/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/passive/kururak/hibernate = 1,
		/mob/living/simple_animal/passive/kururak           = 10
	)
	return spawn_choices

/obj/random/sif/grafadreka
	name = "Random Grafadreka"
	desc = "This is a random grafadreka, either waking or hibernating."
	icon_state = "frost"

/obj/random/sif/grafadreka/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/human/grafadreka/hatchling = 3,
		/mob/living/human/grafadreka           = 12
	)
	return spawn_choices

/obj/random/sif/hostile
	name = "Random Hostile Sif Animal"
	desc = "This is a random hostile cold weather animal."
	icon_state = "animal_hostile"

/obj/random/sif/hostile/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/simple_animal/passive/savik                  = 22,
		/mob/living/simple_animal/hostile/giant_spider/frost = 33,
		/mob/living/simple_animal/passive/frostfly               = 20,
		/mob/living/simple_animal/passive/tymisian               = 10,
		/mob/living/simple_animal/hostile/beast/shantak      = 25
	)
	return spawn_choices
