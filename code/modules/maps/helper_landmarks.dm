//Load a random map template from the list. Maploader handles it to avoid order of init madness
/obj/abstract/landmark/map_load_mark
	name = "map loader landmark"
	var/list/map_template_names	//list of template names to pick from

/obj/abstract/landmark/map_load_mark/Initialize(var/mapload)
	. = ..()
	if(!mapload)
		return INITIALIZE_HINT_LATELOAD

/obj/abstract/landmark/map_load_mark/LateInitialize()
	load_subtemplate()

/obj/abstract/landmark/map_load_mark/proc/get_subtemplate()
	. = LAZYLEN(map_template_names) && pick(map_template_names)

/obj/abstract/landmark/map_load_mark/proc/load_subtemplate()
	// Commenting this out temporarily as DMMS breaks when asychronously
	// loading overlapping map templates. TODO: more robust queuing behavior
	//set waitfor = FALSE

	var/datum/map_template/template = get_subtemplate()
	var/turf/spawn_loc = get_turf(src)

	if(!QDELETED(src))
		qdel(src)

	if(istype(spawn_loc))
		if(istext(template))
			template = SSmapping.get_template(template)
		if(istype(template))
			template.load(spawn_loc, TRUE)

//Throw things in the area around randomly
/obj/abstract/landmark/carnage_mark
	name = "carnage landmark"
	var/movement_prob = 50	// a chance random unanchored item in the room will be moved randomly
	var/movement_range = 3  // how far would items get thrown

/obj/abstract/landmark/carnage_mark/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/landmark/carnage_mark/LateInitialize()
	do_throw()

/obj/abstract/landmark/carnage_mark/proc/do_throw()
	set waitfor = FALSE
	sleep(0)
	var/area/our_area = get_area(src)
	for(var/atom/movable/throw_candidate in our_area)
		if(!QDELETED(throw_candidate) && !throw_candidate.anchored && throw_candidate.simulated && prob(movement_prob))
			throw_candidate.throw_at_random(FALSE, movement_range, 1)
	qdel(src)

//Clears walls
/obj/abstract/landmark/clear
	name = "clear turf"
	icon_state = "clear"
	//Don't set deleteme to true, since we work inside lateinitialize

/obj/abstract/landmark/clear/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/landmark/clear/LateInitialize()
	. = ..()
	var/turf/simulated/wall/simulated_wall = get_turf(src)
	if(istype(simulated_wall))
		simulated_wall.dismantle_wall(TRUE, TRUE, TRUE)
	else if(istype(simulated_wall, /turf/exterior/wall))
		var/turf/exterior/wall/exterior_wall = simulated_wall
		exterior_wall.dismantle_wall(TRUE)
	qdel(src)

//Applies fire act to the turf
/obj/abstract/landmark/scorcher
	name = "fire"
	icon_state = "fire"
	var/temp = T0C + 4000

/obj/abstract/landmark/scorcher/Initialize()
	var/turf/T = get_turf(src)
	if(istype(T))
		T.fire_act(exposed_temperature = temp)
	. = ..()

//Delete specified things when a specified shuttle moves
/obj/abstract/landmark/delete_on_shuttle
	var/shuttle_name
	var/shuttle_datum
	var/list/typetodelete = list(/obj/machinery, /obj/item/gun, /mob/living/exosuit, /obj/item/transfer_valve)

/obj/abstract/landmark/delete_on_shuttle/Initialize()
	. = ..()
	events_repository.register_global(/decl/observ/shuttle_added, src, .proc/check_shuttle)

/obj/abstract/landmark/delete_on_shuttle/proc/check_shuttle(var/shuttle)
	if(SSshuttle.shuttles[shuttle_name] == shuttle)
		events_repository.register(/decl/observ/shuttle_moved, shuttle, src, .proc/delete_everything)
		shuttle_datum = shuttle

/obj/abstract/landmark/delete_on_shuttle/proc/delete_everything()
	for(var/O in loc)
		if(is_type_in_list(O,typetodelete))
			qdel(O)
	qdel(src)

/obj/abstract/landmark/delete_on_shuttle/Destroy()
	events_repository.unregister_global(/decl/observ/shuttle_added, src, .proc/check_shuttle)
	if(shuttle_datum)
		events_repository.unregister(/decl/observ/shuttle_moved, shuttle_datum, src, .proc/delete_everything)
	. = ..()

// Has a percent chance on spawn to set the specified variable on the specified type to the specified value.

/obj/abstract/landmark/variable_setter
	is_spawnable_type = FALSE
	var/type_to_find
	var/variable_to_set
	var/value_to_set
	var/probability = 100

/obj/abstract/landmark/variable_setter/Initialize()
	. = ..()
	if(!prob(probability))
		return // Do nothing.
	for(var/atom/candidate_atom in get_turf(src))
		if(!istype(candidate_atom, type_to_find))
			continue
		if(try_set_variable(candidate_atom))
			break
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/variable_setter/proc/try_set_variable(atom/atom_to_modify)
	// We don't have that variable! Give our own runtime to be more informative than the default one.
	if(!(variable_to_set in atom_to_modify.vars))
		CRASH("Unable to find variable [variable_to_set] to modify on type [atom_to_modify.type].")
	// Already modified, if we're stacked we shouldn't modify the same one twice.
	if(atom_to_modify.vars[variable_to_set] == value_to_set)
		return FALSE
	atom_to_modify.vars[variable_to_set] = value_to_set
	return TRUE

/obj/abstract/landmark/variable_setter/closet_opener
	type_to_find = /obj/structure/closet
	variable_to_set = "opened"
	value_to_set = TRUE

// Has a percent chance on spawn to call the specified proc on the specified type with the specified arguments.
/obj/abstract/landmark/proc_caller
	is_spawnable_type = FALSE
	var/type_to_find
	var/proc_to_call
	var/arguments_to_pass
	var/probability = 100

/obj/abstract/landmark/proc_caller/Initialize()
	. = ..()
	if(!prob(probability))
		return // Do nothing.
	// we don't use locate in case try_call_proc returns false on our first attempt
	for(var/atom/candidate_atom in get_turf(src))
		if(!istype(candidate_atom, type_to_find))
			continue
		if(try_call_proc(candidate_atom))
			break
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/proc_caller/proc/try_call_proc(atom/atom_to_modify)
	// We don't have that proc! Give our own runtime to be more informative than the default one.
	if(!hascall(atom_to_modify, proc_to_call))
		CRASH("Unable to find proc [proc_to_call] to call on type [atom_to_modify.type].")
	if(length(arguments_to_pass))
		call(atom_to_modify, proc_to_call)(arglist(arguments_to_pass))
	else
		call(atom_to_modify, proc_to_call)()
	return TRUE

/obj/abstract/landmark/proc_caller/floor_burner
	type_to_find = /turf/simulated/floor
	proc_to_call = /turf/simulated/floor/proc/burn_tile
	arguments_to_pass = null

/// Used to tell pipe leak unit tests that a leak is intentional. Placed over the pipe that leaks, not the tile missing a pipe.
/obj/abstract/landmark/allowed_leak
#ifndef UNIT_TEST
	delete_me = TRUE
#endif
