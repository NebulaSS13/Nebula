/datum/unit_test/codex_string_uniqueness
	name = "CODEX - All Codex Associated Strings Shall Be Unique"

/datum/unit_test/codex_string_uniqueness/start_test()
	var/list/failures = list()
	var/list/seen_strings = list()
	for(var/datum/codex_entry/entry as anything in SScodex.all_entries)
		for(var/associated_string in entry.associated_strings)
			if(seen_strings[associated_string])
				failures |= "'[associated_string]' - \ref[entry]#[entry.name] - first seen: [seen_strings[associated_string]]"
			else
				seen_strings[associated_string] = "\ref[entry]#[entry.name]"

	if(length(failures))
		fail("Found [length(failures)] non-unique associated strings\s:\n[jointext(failures, "\n")].")
	else
		pass("No non-unique associated strings.")
	return TRUE

/datum/unit_test/codex_overlap
	name = "CODEX - No Codex String IDs Shall Overlap"

/datum/unit_test/codex_overlap/start_test()
	var/list/failures = list()
	for(var/check_string in SScodex.entries_by_string)
		var/clean_check_string = lowertext(check_string)
		for(var/other_string in SScodex.entries_by_string)
			var/clean_other_string = lowertext(other_string)
			if(clean_other_string == clean_check_string)
				continue
			if(SScodex.entries_by_string[other_string] != SScodex.entries_by_string[check_string])
				if(findtext(clean_check_string, clean_other_string))
					failures |= "[check_string], [other_string]"
				else if(findtext(clean_other_string, clean_check_string))
					failures |= "[other_string], [check_string]"
			CHECK_TICK // Otherwise we set off infinite loop checks.

	if(length(failures))
		fail("Found [length(failures)] overlapping string ID\s:\n[jointext(failures, "\n")].")
	else
		pass("No overlapping string IDs.")
	return TRUE

/datum/unit_test/codex_links
	name = "CODEX - All Codex Links Will Function"

/datum/unit_test/codex_links/start_test()
	var/list/failures = list()
	for(var/datum/codex_entry/entry in SScodex.all_entries)
		var/entry_body = jointext(entry.get_codex_body(), null)
		while(SScodex.linkRegex.Find(entry_body))
			var/regex_key = SScodex.linkRegex.group[4]
			if(SScodex.linkRegex.group[2])
				regex_key = SScodex.linkRegex.group[3]
			regex_key = codex_sanitize(regex_key)
			var/replacement = SScodex.linkRegex.group[4]
			var/datum/codex_entry/linked_entry = SScodex.get_entry_by_string(regex_key)
			if(!linked_entry)
				failures |= "[entry.name] - [replacement]"
	if(length(failures))
		fail("Codex had [length(failures)] broken link\s:\n[jointext(failures, "\n")]")
	else
		pass("All codex links were functional.")
	return 1

/datum/unit_test/codex_dump_test
	name = "CODEX - Codex Will Successfully Dump To Filesystem"

/datum/unit_test/codex_dump_test/start_test()
	var/dump_result
	try
		dump_result = SScodex.dump_to_filesystem()
	catch(var/exception/E)
		fail("Codex dump threw an exception: [EXCEPTION_TEXT(E)]")
		return 1
	if(dump_result)
		pass("Codex dumped successfully.")
	else
		fail("Codex dump did not return true.")
	return 1
