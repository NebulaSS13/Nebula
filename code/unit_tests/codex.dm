/datum/unit_test/codex
	name = "CODEX - No Codex String IDs Shall Overlap"

/datum/unit_test/codex/start_test()
	var/list/failures = list()
	for(var/check_string in SScodex.entries_by_string)
		var/clean_check_string = lowertext(check_string)
		for(var/other_string in SScodex.entries_by_string)
			if(SScodex.entries_by_string[other_string] != SScodex.entries_by_string[check_string])
				var/clean_other_string = lowertext(other_string)
				if(findtext(clean_check_string, clean_other_string))
					failures |= "[check_string], [other_string]"
				else if(findtext(clean_other_string, clean_check_string))
					failures |= "[other_string], [check_string]"
	if(length(failures))
		fail("Found [length(failures)] overlapping string ID\s:\n[jointext(failures, "\n")].")
	else
		pass("No overlapping string IDs.")
	return TRUE
