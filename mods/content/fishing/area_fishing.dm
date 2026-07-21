/area
	var/fishing_failure_prob = 95
	// Hardcoding the contents of /obj/random/junk to avoid hacks for getting results from /obj/random.
	var/list/fishing_results = list(
		/obj/item/remains/mouse     = 1,
		/obj/item/remains/robot     = 1,
		/obj/item/paper/crumpled    = 1,
		/obj/item/inflatable/torn   = 1,
		/obj/item/shard             = 1,
		/obj/item/hand/missing_card = 1
	)

/area/Initialize()
	var/list/additional_fishing_results = get_additional_fishing_results()
	if(LAZYLEN(additional_fishing_results))
		LAZYINITLIST(fishing_results)
		for(var/fish in additional_fishing_results)
			fishing_results[fish] = additional_fishing_results[fish]
	. = ..()

/area/proc/get_additional_fishing_results()
	return

/area/proc/get_fishing_result(turf/origin, obj/item/food/bait)
	if(!length(fishing_results) || prob(fishing_failure_prob))
		return null
	return pickweight(fishing_results)

// overrides down here

// Let's make a token effort at making the fish somewhat alien I guess.
/area/exoplanet/get_fishing_result(turf/origin, obj/item/food/bait)
	. = ..()
	if(ismob(.))
		var/mob/M = .
		M.SetName("xeno-[M.name]")
		M.set_color(get_random_colour(simple = TRUE))

//Fishing results for the grass exoplanet surface
/area/exoplanet/grass
	fishing_failure_prob = 10
	// TODO: waterweed?
	// Hardcoding the contents of /obj/random/natural_debris to avoid hacks to get results out of /obj/random.
	fishing_results = list(
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
		/obj/item/remains/mouse                              = 2,
		/obj/item/remains/lizard                             = 2,
		/obj/item/stick                                      = 1,
		/obj/item/trash/mollusc_shell                        = 1,
		/mob/living/simple_animal/aquatic/fish/large/koi     = 1
	)