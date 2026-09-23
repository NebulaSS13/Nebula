/obj/random/turf_lava
	name = "random Lava spawn"
	desc = "This is a random lava spawn."

/obj/random/turf_lava/spawn_choices()
	var/static/list/spawnable_choices = list(
		/turf/floor/lava          = 5,
		/turf/floor/rock/basalt   = 3,
		/turf/wall/natural/basalt = 1
	)
	return spawnable_choices
