/decl/modpack/persistence
	name = "Persistence Gamemode Content"

/decl/modpack/persistence/initialize()
	. = ..()
	admin_verbs_admin.Add(/client/proc/save_server)
	admin_verbs_admin.Add(/client/proc/regenerate_mine)
	for(var/client/C in GLOB.admins)
		C.remove_admin_verbs()
		C.add_admin_verbs()