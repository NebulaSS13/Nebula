/datum/unit_test/saved_vars_exist
	name = "PERSISTENCE: All variables exist on saved vars."

/datum/unit_test/saved_vars_exist/start_test()
	SSpersistence.in_loaded_world = TRUE
	try
		var/failed = FALSE
		for(var/path in GLOB.saved_vars)
			CHECK_TICK
			if(ispath(path, /datum/extension))
				continue // Skip extensions
			if(!ispath(path))
				fail("'[path]' does not exist.")
				continue
			try
				var/datum/D = new path
				if(!istype(D))
					fail("Attempted to create '[path]' but was not able to create of datum.")
					continue
				for(var/V in GLOB.saved_vars[path])
					if(V in D.vars)
						continue
					fail("Expecting '[V]' in type [path], but variable was not defined.")
					failed = TRUE
				try
					qdel(D, TRUE)
				catch
					// Eat the errors idc.
			catch(var/exception/e)
				fail("'[path]' new() error: could not create new instance. Caught exception on line [e.line] at [e.file] with msg '[e]'.")
		if(!failed)
			pass("All variables declared were found in their types.")
	catch(var/exception/e)
		fail("Saved_vars.json has bad configuration. Caught exception on line [e.line] at [e.file] with msg '[e]'.")
	SSpersistence.in_loaded_world = FALSE
	return 1