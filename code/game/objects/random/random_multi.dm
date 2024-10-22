/*
	Selects one spawn point out of a group of points with the same ID and asks it to generate its items
*/
/obj/random_multi
	name = "random object spawn point"
	desc = "This item type is used to spawn random objects at round-start. Only one spawn point for a given group id is selected."
	icon = 'icons/misc/mark.dmi'
	icon_state = "x3"
	invisibility = INVISIBILITY_ABSTRACT
	var/id     // Group id
	var/weight // Probability weight for this spawn point

/obj/random_multi/modify_mapped_vars(map_hash)
	. = ..()
	ADJUST_TAG_VAR(id, map_hash)

/obj/random_multi/Initialize()
	. = ..()
	weight = max(1, round(weight))

	if(!multi_point_spawns)
		multi_point_spawns = list()
	var/list/spawnpoints = multi_point_spawns[id]
	if(!spawnpoints)
		spawnpoints = list()
		multi_point_spawns[id] = spawnpoints
	spawnpoints[src] = weight

/obj/random_multi/Destroy()
	var/list/spawnpoints = multi_point_spawns[id]
	spawnpoints -= src
	if(!spawnpoints.len)
		multi_point_spawns -= id
	. = ..()

/obj/random_multi/proc/generate_items()
	return
