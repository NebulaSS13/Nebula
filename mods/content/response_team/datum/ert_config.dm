/decl/configuration_category/response_team
	name = "Response Team"
	desc = "Configuration options relating to emergency response teams."
	configuration_file_location = "config/gamemodes/ert.txt"
	associated_configuration = list(
		/decl/config/toggle/ert_admin_call_only
	)

/decl/config/toggle/ert_admin_call_only
	uid = "ert_admin_call_only"
	desc = "Restricted ERT to be only called by admins."