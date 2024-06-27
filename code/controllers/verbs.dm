/client/proc/debug_antagonist_template()
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/list/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
	var/antag_type = input("Select an antagonist type.", "Antag Debug") as null|anything in all_antag_types
	var/decl/special_role/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.name] template.")

/client/proc/debug_controller(controller as null|anything in list("Jobs","Sun","Radio","Configuration","pAI", "Cameras", "Transfer Controller", "Gas Data","Plants","Wireless","Observation","Alt Appearance Manager","Datacore","Military Branches"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder || !controller)
		return

	switch(controller)
		if("Radio")
			debug_variables(radio_controller)
			SSstatistics.add_field_details("admin_verb","DRadio")
		if("pAI")
			debug_variables(paiController)
			SSstatistics.add_field_details("admin_verb","DpAI")
		if("Cameras")
			debug_variables(cameranet)
			SSstatistics.add_field_details("admin_verb","DCameras")
		if("Transfer Controller")
			debug_variables(transfer_controller)
			SSstatistics.add_field_details("admin_verb","DAutovoter")
		if("Alt Appearance Manager")
			debug_variables(GET_DECL(/decl/appearance_manager))
			SSstatistics.add_field_details("admin_verb", "DAltAppearanceManager")
		if("Military Branches")
			debug_variables(mil_branches)
			SSstatistics.add_field_details("admin_verb", "DMilBranches")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
