/datum/unit_test/surgery_steps_shall_have_descriptions
	name = "SURGERY: Surgery steps shall have descriptions"

/datum/unit_test/surgery_steps_shall_have_descriptions/start_test()
	var/list/failed = list()
	var/list/all_surgery = decls_repository.get_decls_of_subtype(/decl/surgery_step)
	for(var/stype in all_surgery)
		var/decl/surgery_step/step = all_surgery[stype]
		if(step.surgery_step_category != stype && !istext(step.description))
			failed += stype
	if(length(failed))
		fail("Some surgery steps have no description:\n[jointext(failed, "\n")]")
	else
		pass("All surgery steps have a description.")
	return 1
