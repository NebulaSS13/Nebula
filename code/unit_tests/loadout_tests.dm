/datum/unit_test/loadout_test_shall_have_valid_icon_states
	name = "LOADOUT: Entries shall have valid icon states"

/datum/unit_test/loadout_test_shall_have_valid_icon_states/start_test()

	var/list/failed = list()
	for(var/decl/loadout_option/G in decls_repository.get_decls_unassociated(/decl/loadout_option))
		var/list/path_tweaks = list()
		for(var/datum/gear_tweak/path/p in G.gear_tweaks)
			path_tweaks += p

		if(path_tweaks.len)
			for(var/datum/gear_tweak/path/p in path_tweaks)
				for(var/path_name in p.valid_paths)
					var/path_type = p.valid_paths[path_name]
					if(!type_has_valid_icon_state(path_type))
						var/atom/A = path_type
						failed += "[G] - [path_type] ('[path_name]'): Did not find a gear_tweak's icon_state '[initial(A.icon_state)]' in the icon '[initial(A.icon)]'."
		else
			if(!type_has_valid_icon_state(G.path))
				var/obj/O = G.path
				if(ispath(G.path, /obj))
					O = new G.path()
					if(!is_string_in_list(O.icon_state, icon_states(O.icon)))
						failed += "[G] - [G.path]: Did not find the icon state '[O.icon_state]' in the icon '[O.icon]'."
					qdel(O)
				else
					failed += "[G] - [G.path]: Did not find the icon state '[initial(O.icon_state)]' in the icon '[initial(O.icon)]'."

	if(length(failed))
		fail("[length(failed)] /decl/loadout definition\s had paths with invalid icon states:\n[jointext(failed, "\n")]")
	else
		pass("All /decl/loadout_option definitions had correct icon states.")
	return  1

/datum/unit_test/loadout_test_gear_path_tweaks_shall_be_of_gear_path
	name = "LOADOUT: Gear path tweaks shall be of gear path."

/datum/unit_test/loadout_test_gear_path_tweaks_shall_be_of_gear_path/start_test()
	var/list/failed = list()
	for(var/decl/loadout_option/G in decls_repository.get_decls_unassociated(/decl/loadout_option))
		for(var/datum/gear_tweak/path/p in G.gear_tweaks)
			for(var/path_name in p.valid_paths)
				var/path_type = p.valid_paths[path_name]
				if(!ispath(path_type, G.path))
					failed += "[G] - [path_type] ('[path_name]'): Was not a path of [G.path]."

	if(length(failed))
		fail("[length(failed)] /datum/gear_tweak/path definition\s had invalid paths:\n[jointext(failed, "\n")]")
	else
		pass("All /datum/gear_tweak/paths had valid paths.")
	return  1

/datum/unit_test/loadout_test_gear_path_tweaks_shall_have_unique_keys
	name = "LOADOUT: Gear path tweaks shall have unique keys"

/datum/unit_test/loadout_test_gear_path_tweaks_shall_have_unique_keys/start_test()
	var/path_entries_by_gear_path_and_name = list()
	for(var/decl/loadout_option/G in decls_repository.get_decls_unassociated(/decl/loadout_option))
		for(var/datum/gear_tweak/path/p in G.gear_tweaks)
			for(var/path_name in p.valid_paths)
				group_by(path_entries_by_gear_path_and_name, "[G] - [p] - [path_name]", path_name)

	var/number_of_issues = number_of_issues(path_entries_by_gear_path_and_name, "Path Tweak Names")
	if(number_of_issues)
		fail("[number_of_issues] /datum/gear_tweak/path definition\s found.")
	else
		pass("All /datum/gear_tweak/path definitions had unique names.")
	return  1

/proc/type_has_valid_icon_state(var/atom/type)
	var/atom/A = type
	return (initial(A.icon_state) in icon_states(initial(A.icon)))


/datum/unit_test/loadout_custom_setup_tweaks_shall_have_valid_procs
	name = "LOADOUT: Custom setup tweaks shall have valid procs"

/datum/unit_test/loadout_custom_setup_tweaks_shall_have_valid_procs/start_test()

	var/list/failures = list()
	for(var/decl/loadout_option/G in decls_repository.get_decls_unassociated(/decl/loadout_option))
		var/datum/instance
		var/mob/user
		for(var/datum/gear_tweak/custom_setup/cs in G.gear_tweaks)
			instance = instance || new G.path()
			user = user || new()
			var/res = cs.tweak_item(user, instance)
			if(res != GEAR_TWEAK_SUCCESS && res != GEAR_TWEAK_SKIPPED)
				failures += "[G.type] - [cs.type]"

		QDEL_NULL(instance)
		QDEL_NULL(user)

	if(length(failures))
		fail("Some gear tweaks failed to return a value:\n[jointext(failures, "\n")]")
	else
		pass("Succesfully called all custom setup procs without runtimes")
	return  1

/datum/unit_test/loadout_custom_setup_tweak_shall_be_applied_as_expected
	name = "LOADOUT: Custom setup tweak shall be applied as expected"

/datum/unit_test/loadout_custom_setup_tweak_shall_be_applied_as_expected/start_test()
	var/decl/loadout_option/G = GET_DECL(/decl/loadout_option/loadout_test)
	var/obj/unit_test/loadout/instance = new G.path()
	var/mob/user = new()
	for(var/datum/gear_tweak/custom_setup/cs in G.gear_tweaks)
		cs.tweak_item(user, instance)

	if(instance.loadout_mob == user && instance.loadout_var == G.custom_setup_proc_arguments[1])
		pass("Succesfully applied custom tweak")
	else
		fail("Failed to apply custom tweak")
	QDEL_NULL(instance)
	QDEL_NULL(user)
	return TRUE

/decl/loadout_option/loadout_test
	name = "loadout test"
	path = /obj/unit_test/loadout
	custom_setup_proc = /obj/unit_test/loadout/proc/loadout_proc
	custom_setup_proc_arguments = list(5)
	uid = "gear_debug"

/obj/unit_test/loadout
	var/loadout_mob
	var/loadout_var

/obj/unit_test/loadout/Destroy()
	loadout_mob = null
	loadout_var = null
	return ..()

/obj/unit_test/loadout/proc/loadout_proc(user, arg)
	loadout_mob = user
	loadout_var = arg
