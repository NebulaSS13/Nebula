// Woodland areas.
/area/shaded_hills/caves/river/woods
	name = "Northern Silent River"

/area/shaded_hills/outside/river/lake
	name = "Woodland Lake"
	forced_ambience = list('sound/ambience/shore.ogg')

/area/shaded_hills/outside/river/lake/get_additional_fishing_results()
	var/static/list/additional_fishing_results = list(
		/mob/living/simple_animal/aquatic/fish/large/bass    = 5,
		/mob/living/simple_animal/aquatic/fish/large/trout   = 5,
		/mob/living/simple_animal/aquatic/fish/large/javelin = 5,
		/mob/living/simple_animal/hostile/aquatic/carp       = 3,
		/mob/living/simple_animal/aquatic/fish/large/koi     = 1
	)
	return additional_fishing_results

/area/shaded_hills/outside/woods
	name = "Woodlands"
	sound_env = FOREST

/area/shaded_hills/outside/woods/poi
	name = "Deep Woodlands"

/area/shaded_hills/outside/river/woods
	name = "Woodland River"

/area/shaded_hills/caves/woods
	name = "Northern Deep Tunnels"

/area/shaded_hills/caves/unexplored/woods
	name = "Trackless Deeps - Far North"

/area/shaded_hills/forester_hut
	name = "\improper Foresters' Hut"
	sound_env = STANDARD_STATION
	fishing_failure_prob = 100
	fishing_results = list()
