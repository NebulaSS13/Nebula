/datum/computer_file/report/warrant
	title = "Warrant"
	form_name = "W-104"
	
	write_access = list(list(access_security), list(access_bridge))
	read_access = list(list(access_security), list(access_bridge))
	var/archived = FALSE

/datum/computer_file/report/warrant/New()
	filename = "warrant[sequential_id(type)]"
	..()

/datum/computer_file/report/warrant/proc/get_nano_summary(uncut)
	var/charges = get_reason()
	if(!uncut && length(charges) > 50)
		charges = copytext(charges, 1, 50) + "..."
	return list(list(
		"id" = uid,
		"name" = get_name(),
		"reason" = charges,
		"auth" = get_auth()
	))

/datum/computer_file/report/warrant/proc/get_broadcast_summary()
	return "\A [get_category()] warrant for <b>[get_name()]</b>"

/datum/computer_file/report/warrant/proc/get_formatted_version()

/datum/computer_file/report/warrant/proc/get_category()
	if(archived)
		return "archive"

/datum/computer_file/report/warrant/proc/get_name()
/datum/computer_file/report/warrant/proc/get_reason()
/datum/computer_file/report/warrant/proc/get_auth()
	return value_by_field_name("Authorized by")

/datum/computer_file/report/warrant/arrest
	title = "Arrest Warrant"
	form_name = "W-104-A"
	write_access = list(access_security)

/datum/computer_file/report/warrant/arrest/generate_fields()
	add_field(/datum/report_field/text_label/header, "Arrest Warrant")
	add_field(/datum/report_field/simple_text, "Name", "Unknown")
	add_field(/datum/report_field/pencode_text, "Charges", "No charges")
	add_field(/datum/report_field/signature, "Authorized by", "Unathorized")

/datum/computer_file/report/warrant/arrest/get_category()
	. = ..()
	if(!.)
		return "arrest"

/datum/computer_file/report/warrant/arrest/get_name()
	return value_by_field_name("Name")

/datum/computer_file/report/warrant/arrest/get_reason()
	return value_by_field_name("Charges")

/datum/computer_file/report/warrant/arrest/get_formatted_version()
	return {"
			<HTML><HEAD><TITLE>Arrest Warramt: [get_name()]</TITLE></HEAD>
			<BODY><center><h2>Warrant Tracker System</h2>
			Issued in the jurisdiction of the</br>
			[global.using_map.boss_name] in [global.using_map.system_name]</br>
			</br>
			<h1>ARREST WARRANT</h1></center>
			</br>
			This document serves as authorization and notice for the arrest of _<u>[get_name()]</u>____ for the crime(s) of:</br>[get_reason()]</br>
			</br>
			Vessel or habitat: _<u>[global.using_map.station_name]</u>____</br>
			</br>_<u>[get_auth()]</u>____</br>
			<small>Person authorizing arrest</small></br>
			</BODY></HTML>
			"}

/datum/computer_file/report/warrant/search
	title = "Search Warrant"
	form_name = "W-104-S"
	write_access = list(access_security)

/datum/computer_file/report/warrant/search/generate_fields()
	add_field(/datum/report_field/text_label/header, "Search Warrant")
	add_field(/datum/report_field/simple_text, "Person/Location", "Unknown")
	add_field(/datum/report_field/pencode_text, "Reason", "No reason")
	add_field(/datum/report_field/signature, "Authorized by", "Unathorized")

/datum/computer_file/report/warrant/search/get_category()
	. = ..()
	if(!.)
		return "search"
	
/datum/computer_file/report/warrant/search/get_name()
	return value_by_field_name("Person/Location")

/datum/computer_file/report/warrant/search/get_reason()
	return value_by_field_name("Reason")

/datum/computer_file/report/warrant/search/get_formatted_version()
	return {"
	<HTML><HEAD><TITLE>Search Warrant: [get_name()]</TITLE></HEAD>
	<BODY><center><h2>Warrant Tracker System</h2>
	Issued in the jurisdiction of the</br>
	[global.using_map.boss_name] in [global.using_map.system_name]</br>
	</br>
	<h1>SEARCH WARRANT</h1></center>
	</br>
	<b>Suspect's/location name: </b>[get_name()]</br>
	</br>
	<b>For the following reasons: </b> [get_reason()]</br>
	</br>
	<b>Warrant issued by: </b> [get_auth()]</br>
	</br>
	Vessel or habitat: _<u>[global.using_map.station_name]</u>____</br>
	</br>
	<center><small><i>The Security Officer(s) bearing this Warrant are hereby authorized by the Issuer to conduct a one time lawful search of the Suspect's person/belongings/premises and/or Department for any items and materials that could be connected to the suspected criminal act described below, pending an investigation in progress.</br>
	</br>
	The Security Officer(s) are obligated to remove any and all such items from the Suspects posession and/or Department and file it as evidence.</br>
	</br>
	The Suspect/Department staff is expected to offer full co-operation.</br>
	</br>
	In the event of the Suspect/Department staff attempting to resist/impede this search or flee, they must be taken into custody immediately! </br>
	</br>
	All confiscated items must be filed and taken to Evidence!</small></i></center></br>
	</BODY></HTML>
	"}