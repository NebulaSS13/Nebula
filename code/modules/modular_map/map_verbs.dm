/client/proc/place_modular_map_current_z()
	set name = "Place Modular Map On Current Z"
	set category = "Admin"
	set src = usr

	if(!holder)
		to_chat(usr, SPAN_WARNING("Only administrators may use this command."))
		return

	var/turf/my_turf = get_turf(mob)
	if(!my_turf?.z)
		to_chat(usr, SPAN_WARNING("You must be on a turf to use this verb."))
		return

	var/decl/modular_map_generator/mapgen = input("Select a generator.") as null|anything in decls_repository.get_decls_of_subtype_unassociated(/decl/modular_map_generator)
	mapgen?.generate(my_turf.z)

/client/proc/place_modular_map_new_z()
	set name = "Place Modular Map On New Z"
	set category = "Admin"
	set src = usr

	if(!holder)
		to_chat(usr, SPAN_WARNING("Only administrators may use this command."))
		return

	var/decl/modular_map_generator/mapgen = input("Select a generator.") as null|anything in decls_repository.get_decls_of_subtype_unassociated(/decl/modular_map_generator)
	mapgen?.generate()
