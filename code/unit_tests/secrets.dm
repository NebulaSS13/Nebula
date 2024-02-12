/datum/unit_test/secrets_repo_will_have_valid_directories
	name = "SECRETS: Secrets repo will load from valid directories"

/datum/unit_test/secrets_repo_will_have_valid_directories/start_test()
	var/list/failed = list()
	for(var/directory in SSsecrets.load_directories)
		if(copytext(directory, -1) != "/")
			failed += "dir [directory] doesn't terminate with '/'."
		if(!fexists(directory))
			failed += "dir [directory] does not exist or is inaccessible."
	if(!length(failed))
		pass("All secret repo load dirs were valid.")
	else
		fail("[length(failed)] secret repo load dir\s [length(failed) == 1 ? "was" : "were"] invalid:\n[jointext(failed, "\n")]")
	return TRUE

/datum/unit_test/secrets_repo_will_load_example_secret
	name = "SECRETS: Secrets repo will load single example secret"
	var/test_path = /obj/item/paper/secret_note/example

/datum/unit_test/secrets_repo_will_load_example_secret/start_test()
	var/obj/item/paper/secret_note/example
	try
		example = new test_path
	catch(var/exception/e)
		fail("Got exception during example secret load/instantiation: [EXCEPTION_TEXT(e)]")
	if(!istype(example))
		fail("Example secret was not created successfully.")
	else
		pass("Example secret was created without errors.")
	return TRUE

/datum/unit_test/secrets_repo_will_load_example_secret/random
	name = "SECRETS: Secrets repo will load random example secret"
	test_path = /obj/item/paper/secret_note/random/example
