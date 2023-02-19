/datum/unit_test/all_zlevels_will_have_a_non_filler_data_object
	name = "ZLEVELS: All Z-Levels Will Have A Valid Data Object"

/datum/unit_test/all_zlevels_will_have_a_non_filler_data_object/start_test()
	var/list/failures = list()
	for(var/z = 1 to world.maxz)
		var/datum/level_data/level_data = SSmapping.levels_by_z[z]
		if(!level_data)
			failures += "z[z] has no level data object"
	if(length(failures))
		fail("Some z-levels had invalid level data objects:\n[jointext(failures, "\n")]")
	else
		pass("All z-levels had valid level data objects.")
	return 1
