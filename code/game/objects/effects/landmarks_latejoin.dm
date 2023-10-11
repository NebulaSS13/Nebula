/obj/abstract/landmark/latejoin
	delete_me = TRUE
	var/spawn_decl = /decl/spawnpoint/arrivals

/obj/abstract/landmark/latejoin/Initialize()
	if(spawn_decl)
		var/decl/spawnpoint/spawn_instance = GET_DECL(spawn_decl)
		LAZYDISTINCTADD(spawn_instance.spawn_turfs, get_turf(src))
	. = ..()
