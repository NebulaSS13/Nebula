/datum/computer_file/data/grant_record
	filetype = "GRT"
	size = 2
	do_not_edit = 1					// Whether the user will be reminded that the file probably shouldn't be edited.
	
/datum/computer_file/data/grant_record/proc/set_value(var/value)
	stored_data = replacetext(sanitize(uppertext(value)), " ", "_")
	filename = stored_data