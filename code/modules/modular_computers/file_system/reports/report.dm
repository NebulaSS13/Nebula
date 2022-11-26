/datum/computer_file/report
	filename = "report"
	filetype = "RPT"
	var/title = "Generic Report"                           //The name of this report type.
	var/form_name = "AB1"                                  //Form code, for maximum bureaucracy.
	var/creator                                            //The name of the mob that made the report.
	var/file_time                                          //Time submitted.
	write_access = list()                                  //The access required to submit the report.
	read_access = list()                                   //The access required to view the report.
	mod_access = list(list(access_bridge))                 //Changing the read/write access of the file should generally require higher access than the write access itself.
	var/list/datum/report_field/fields = list()            //A list of fields the report comes with, in order that they should be displayed.
	var/available_on_network = 0                           //Whether this report type should show up for download.
	var/logo                                               //Can be set to a pencode logo for use with some display methods.
	var/list/searchable_fields = list()                    //The names of fields in the report which are searchable.

/datum/computer_file/report/New()
	..()
	generate_fields()
	initialize_access()

/datum/computer_file/report/Destroy()
	QDEL_NULL_LIST(fields)
	. = ..()

/*
This proc resets the access to the report, resulting in just one access requirement for read/write.
If null is passed to one of the arguments, that access type is left alone. Pass list() to reset to no access needed instead.
The recursive option resets access to all fields in the report as well.
*/
/datum/computer_file/report/proc/set_access(read_access, write_access, recursive = TRUE)
	if(read_access)
		if(!islist(read_access))
			read_access = list(read_access)
		src.read_access = read_access
	if(write_access)
		if(!islist(write_access))
			write_access = list(write_access)
		src.write_access = write_access
	if(recursive)
		for(var/datum/report_field/field in fields)
			field.set_access(read_access, write_access, TRUE)

// The default behavior propagates (non-empty) preset access to the fields which allow such propogation.
// You can override or modify this behavior on subtypes.
/datum/computer_file/report/proc/initialize_access()
	set_access(length(read_access) ? read_access : null, length(write_access) ? write_access : null, TRUE)

//Looking up fields. Names might not be unique unless you ensure otherwise.
/datum/computer_file/report/proc/field_from_ID(ID)
	for(var/datum/report_field/field in fields)
		if(field.ID == ID)
			return field

/datum/computer_file/report/proc/field_from_name(name)
	for(var/datum/report_field/field in fields)
		if(field.display_name() == name)
			return field

/datum/computer_file/report/proc/value_by_field_name(name)
	var/datum/report_field/field = field_from_name(name)
	if(field)
		return field.get_value()

//The place to enter fields for report subtypes, via add_field.
/datum/computer_file/report/proc/generate_fields()
	return

/datum/computer_file/report/proc/submit(mob/user)
	if(!istype(user))
		return 0
	for(var/datum/report_field/field in fields)
		if(field.required && !field.get_value())
			to_chat(user, "<span class='notice'>You are missing a required field!</span>")
			return 0
	creator = user.name
	file_time = time_stamp()
	rename_file(file_time)
	return 1

/datum/computer_file/report/proc/rename_file(append)
	append = append || time_stamp()
	append = replacetext(append, ":", "_")
	filename = "[form_name]_[append]"

//Don't add fields except through this proc.
/datum/computer_file/report/proc/add_field(field_type, name, value = null, required = 0, searchable = 0, can_mod_access = 1)
	var/datum/report_field/field = new field_type(src)
	field.name = name
	if(value)
		field.value = value
	if(required)
		field.required = 1
	if(searchable)
		field.searchable = 1
		searchable_fields += field.name
	field.can_mod_access = can_mod_access
	field.ID = sequential_id(type)
	fields += field
	return field

/datum/computer_file/report/PopulateClone(datum/computer_file/report/clone)
	clone = ..()
	clone.title     = title
	clone.form_name = form_name
	clone.creator   = creator
	clone.file_time = file_time
	for(var/i = 1, i <= length(fields), i++)
		var/datum/report_field/new_field = clone.fields[i]
		new_field.copy_value(fields[i])
	return clone

/datum/computer_file/report/proc/display_name()
	return "Form [form_name]: [title]"

//if access is given, will include access information by performing checks against it.
/datum/computer_file/report/proc/generate_nano_data(list/given_access, mob/user)
	. = list()
	.["name"] = display_name()
	.["uid"] = uid
	.["creator"] = creator
	.["file_time"] = file_time
	.["fields"] = list()
	if(given_access)
		var/access_flags = get_file_perms(given_access, user)
		.["access"] = access_flags & OS_READ_ACCESS
		.["access_edit"] = access_flags & OS_WRITE_ACCESS
	for(var/datum/report_field/field in fields)
		.["fields"] += list(field.generate_nano_data(given_access, user))
/*
This formats the report into pencode for use with paper and printing. Setting access to null will bypass access checks.
with_fields will include a field link after the field value (useful to print fillable forms).
no_html will strip any html, possibly killing useful formatting in the process.
*/
/datum/computer_file/report/proc/generate_pencode(access, mob/user, with_fields, no_html)
	. = list()
	. += "\[center\][logo]\[/center\]"
	. += "\[center\]\[h2\][display_name()]\[/h2\]\[/center\]"
	. += "\[grid\]"
	for(var/datum/report_field/F in fields)
		. += F.generate_row_pencode(access, user, with_fields)
	. += "\[/grid\]"
	. = JOINTEXT(.)
	if(no_html)
		. = html2pencode(.)

//recipient reports have a designated recipients field, for recieving submitted reports.
/datum/computer_file/report/recipient
	var/datum/report_field/people/list_from_manifest/recipients

/datum/computer_file/report/recipient/Destroy()
	recipients = null
	return ..()

/datum/computer_file/report/recipient/generate_fields()
	recipients = add_field(/datum/report_field/people/list_from_manifest, "Send Copies To")

/datum/computer_file/report/recipient/submit(mob/user, list/access)
	if((. = ..()))
		recipients.send_email(user)

/*
Access stuff. The report's read/write access should control whether it can be opened/submitted.
For field editing or viewing, use the field's read/write access instead.

Overriden so that read access is required to have write access
*/
/datum/computer_file/report/get_file_perms(list/accesses, mob/user)
	var/perms = ..()
	if(!(perms & OS_READ_ACCESS))
		perms &= ~OS_WRITE_ACCESS
	return perms

// Manually changing the permissions of a report will change *all* contained fields to match.
// TODO: Make report creation and access modification a bit more flexible.
/datum/computer_file/report/change_perms(change, perm, access_key, changer_accesses)
	. = ..()
	if(!.)
		return
	for(var/datum/report_field/field in fields)
		field.set_access(read_access, write_access, TRUE)