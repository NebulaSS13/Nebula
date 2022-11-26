// Currently not actually represented in file systems, though the support for it is in place already.
/datum/computer_file/data/email_message
	stored_data = ""
	var/title = ""
	var/source = ""
	var/spam = FALSE
	var/timestamp = ""
	var/datum/computer_file/attachment = null

/datum/computer_file/data/email_message/Destroy()
	. = ..()
	QDEL_NULL(attachment)

/datum/computer_file/data/email_message/PopulateClone(datum/computer_file/data/email_message/clone)
	clone = ..()
	clone.title      = title
	clone.source     = source
	clone.spam       = spam
	clone.timestamp  = timestamp
	clone.attachment = attachment?.Clone()
	return clone

// Turns /email_message/ file into regular /data/ file.
/datum/computer_file/data/email_message/proc/export()
	var/datum/computer_file/data/dat = new/datum/computer_file/data()
	dat.stored_data =  "Received from [source] at [timestamp]."
	dat.stored_data += "\[b\][title]\[/b\]"
	dat.stored_data += stored_data
	dat.calculate_size()
	return dat

/datum/computer_file/data/email_message/proc/set_timestamp()
	timestamp = stationtime2text()

