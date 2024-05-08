/decl/configuration_category/events
	name = "Client"
	desc = "Configuration options relating to client settings."
	associated_configuration = list(
		/decl/config/num/clients/lock_client_view_x,
		/decl/config/num/clients/lock_client_view_y,
		/decl/config/num/clients/max_client_view_x,
		/decl/config/num/clients/max_client_view_y,
		/decl/config/toggle/popup_admin_pm,
		/decl/config/toggle/aggressive_changelog,
		/decl/config/lists/forbidden_versions
	)

/decl/config/lists/forbidden_versions
	uid = "forbidden_versions"
	default_value = list("512.0001", "512.0002")
	desc = "BYOND builds that will result the client using them to be banned."

/decl/config/num/clients/lock_client_view_x
	uid = "lock_client_view_x"
	default_value = 0
	desc = "Set to an integer to lock the automatic client view scaling on the X axis."

/decl/config/num/clients/lock_client_view_y
	uid = "lock_client_view_y"
	default_value = 0
	desc = "Set to an integer to lock the automatic client view scaling on the Y axis."

/decl/config/num/clients/max_client_view_x
	uid = "max_client_view_x"
	default_value = MAX_VIEW
	desc = "Change to set a maximum size for the client view X scaling."

/decl/config/num/clients/max_client_view_x/update_post_value_set()
	global.click_catchers = null
	for(var/client/client)
		client.reset_click_catchers()
	. = ..()

/decl/config/num/clients/max_client_view_y
	uid = "max_client_view_y"
	default_value = MAX_VIEW
	desc = "Change to set a maximum size for the client view Y scaling."

/decl/config/num/clients/max_client_view_y/update_post_value_set()
	global.click_catchers = null
	for(var/client/client)
		client.reset_click_catchers()
	. = ..()

/decl/config/toggle/popup_admin_pm
	uid = "popup_admin_pm"
	desc = list(
		"Remove the # to show a popup 'reply to' window to every non-admin that recieves an adminPM.",
		"The intention is to make adminPMs more visible. (although I fnd popups annoying so this defaults to off)."
	)

/decl/config/toggle/aggressive_changelog
	uid = "aggressive_changelog"
	desc = "Determines if the changelog file should automatically open when a user connects and hasn't seen the latest changelog."
