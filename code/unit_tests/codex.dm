/datum/unit_test/codex_string_uniqueness
	name = "CODEX - All Codex Associated Strings Shall Be Unique"

/datum/unit_test/codex_string_uniqueness/start_test()
	var/list/failures = list()
	var/list/seen_strings = list()
	for(var/datum/codex_entry/entry AS_ANYTHING in SScodex.all_entries)
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
			if(clean_other_string != clean_check_string || SScodex.entries_by_string[other_string] != SScodex.entries_by_string[check_string])
				if(findtext(clean_check_string, clean_other_string))
					failures |= "[check_string], [other_string]"
				else if(findtext(clean_other_string, clean_check_string))
					failures |= "[other_string], [check_string]"
	if(length(failures))
		fail("Found [length(failures)] overlapping string ID\s:\n[jointext(failures, "\n")].")
	else
		pass("No overlapping string IDs.")
	return TRUE
