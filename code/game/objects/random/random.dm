/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	abstract_type = /obj/random
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/spawn_method = /obj/random/proc/spawn_item

// creates a new object and deletes itself
/obj/random/Initialize()
	..()
	call(src, spawn_method)()
	return INITIALIZE_HINT_QDEL

/obj/random/proc/item_to_spawn()
	var/list/spawn_choices = spawn_choices()
	return length(spawn_choices) && pickweight(spawn_choices)

// creates the random item
/obj/random/proc/spawn_item()

	if(prob(spawn_nothing_percentage) || isnull(loc))
		return

	var/type_to_spawn = item_to_spawn()
	if(islist(type_to_spawn))
		for(var/spawn_type in type_to_spawn)
			LAZYADD(., create_instance(spawn_type, loc))
	else if(ispath(type_to_spawn))
		LAZYADD(., create_instance(type_to_spawn, loc))

	for(var/atom/A as anything in .)
		if(pixel_x || pixel_y)
			A.default_pixel_x = pixel_x
			A.default_pixel_y = pixel_y
			A.reset_offsets(0)

/obj/random/proc/create_instance(var/build_path, var/spawn_loc)
	return new build_path(spawn_loc)

// Returns an associative list in format path:weight
/obj/random/proc/spawn_choices()
	RETURN_TYPE(/list)
	return list()

/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start."
	icon_state = "x3"
	spawn_nothing_percentage = 50
	var/spawn_object = null

/obj/random/single/spawn_choices()
	return spawn_object && list(spawn_object)
