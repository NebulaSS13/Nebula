// This is primarily to ensure firemodes init properly.
/datum/unit_test/gun_init_test
	name = "GUNS: All Guns Shall Initialize Cleanly"
	var/list/exceptions = list()

	// Notes on types below because the indent check fails me if I comment on each line:
	// - Mounted secure eguns expect to be spawned inside a robot mob.
	var/list/except_all_subtypes = list(
		/obj/item/gun/energy/gun/secure/mounted
	)

/datum/unit_test/gun_init_test/start_test()

	var/successful_init = 0
	var/list/failures = list()

	for(var/gun_type in except_all_subtypes)
		exceptions |= typesof(gun_type)

	for(var/gun_type in subtypesof(/obj/item/gun) - exceptions)
		try

			var/failed = FALSE
			var/obj/item/gun/gun_instance = new gun_type

			if(!(gun_instance.atom_flags & ATOM_FLAG_INITIALIZED))
				failures |= "[gun_type] - did not fully initialize"
				failed = TRUE

			if(gun_type in SSatoms.BadInitializeCalls)
				failures |= "[gun_type] - initialized improperly ([SSatoms.BadInitializeCalls[gun_type]])"
				failed = TRUE

			if(!failed)
				successful_init++

		catch(var/exception/E)
			failures |= "[gun_type] - runtime on creation - [E]"

	if(length(failures))
		fail("[length(failures)] gun type\s did not initialize cleanly:\n[jointext(failures, "\n")]")
	else
		pass("[successful_init] gun type\s initialized cleanly.")

	return TRUE
