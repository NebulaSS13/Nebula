/datum/forensics
	var/name = "some kind of forensic evidence"
	var/unique = TRUE  // duplicates are not allowed in data list
	var/max_entries = 10  //will hold that many entries, removing oldest when overflown
	var/list/data
	var/remove_on_transfer //if it should be removed when picked up by forensic samplers

//subtypes can implement any merging if needed before calling parent
/datum/forensics/proc/add_data(newdata)
	if(!newdata)
		return
	if(unique && (newdata in data))
		return
	LAZYADD(data, newdata)
	if(length(data) > max_entries)
		data.Cut(1,2)

/datum/forensics/proc/add_from_atom(atom/A)

/datum/forensics/proc/copy()
	var/datum/forensics/F = new type()
	F.data = data.Copy()
	return F

/datum/forensics/proc/get_formatted_data()
	. = list("<h4>[capitalize(name)] report</h4>")
	for(var/D in data)
		. += "<li>[D]"
	return jointext(., "<br>")