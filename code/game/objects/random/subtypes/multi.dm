/hook/roundstart/proc/roundstart_multi_spawn()
	generate_multi_spawn_items()
	return TRUE

/proc/generate_multi_spawn_items()
	for(var/id in multi_point_spawns)
		var/list/spawn_points = multi_point_spawns[id]
		var/obj/random_multi/rm = pickweight(spawn_points)
		rm.generate_items()
		QDEL_LIST(spawn_points)
	LAZYCLEARLIST(multi_point_spawns)

/obj/random_multi/single_item
	var/item_path  // Item type to spawn
	var/spawn_nothing_chance = 0 /// Chance to spawn nothing.

/obj/random_multi/single_item/generate_items()
	if(prob(spawn_nothing_chance))
		return
	new item_path(loc)

/obj/random_multi/single_item/captains_spare_id
	name = "Multi Point - Captain's Spare"
	id = "Captain's spare id"
	item_path = /obj/item/card/id/captains_spare

/obj/random_multi/single_item/hand_tele
	name = "Multi Point - Hand Teleporter"
	id = "Hand teleporter"
	item_path = /obj/prefab/hand_teleporter
