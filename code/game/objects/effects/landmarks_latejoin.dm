/obj/abstract/landmark/latejoin
	delete_me = TRUE
	var/spawn_decl = /decl/spawnpoint/arrivals

/obj/abstract/landmark/latejoin/Initialize()
	if(spawn_decl)
		var/decl/spawnpoint/spawn_instance = GET_DECL(spawn_decl)
		spawn_instance.add_spawn_turf(get_turf(src))
	. = ..()
