/client/proc/reload_secrets()
	set name = "Reload Hotloaded Content"
	set category = "Debug"

	if(!check_rights(R_SERVER))
		return

	message_admins("[usr] manually reloaded hotloaded content")
	SSsecrets.load_content(TRUE)
	SSstatistics.add_field_details("admin_verb","SRHC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
