/datum/unit_test/shall_have_valid_alarm_appearance
	name = "SECURITY STATES: Shall Have Valid Alarm Appearance Datum Types"

/datum/unit_test/shall_have_valid_alarm_appearance/start_test()
	var/list/security_levels = decls_repository.get_decls_of_subtype(/decl/security_level)
	var/list/failures
	var/list/blacklist = list(/decl/security_level/default)
	for(var/sec_key in security_levels)
		var/decl/security_level/level = security_levels[sec_key]
		if(level.type in blacklist)
			continue
		if(!istype(level.alarm_appearance, /datum/alarm_appearance))
			LAZYADD(failures, "[level.type]")
	if(LAZYLEN(failures))
		fail("One or more security levels did not have their alarm_appearance_type var set: [english_list(failures)]")
	else
		pass("All security levels have their alarm_appearance_type set.")
	return 1