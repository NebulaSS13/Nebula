/decl/modpack/response_team
	name = "Emergency Response Teams"

/decl/modpack/response_team/pre_initialize()
	global.admin_verbs_admin += /client/proc/response_team // Response Teams admin verb
	for(var/client/client in global.admins)
		client.add_admin_verbs() // refresh admin verbs. verbs are deduplicated so this is fine. todo: centralized modpack system for this
	. = ..()