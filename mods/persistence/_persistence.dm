/decl/modpack/persistence
	name = "Persistence Gamemode Content"

/decl/modpack/persistence/initialize()
	. = ..()
	admin_verbs_admin.Add(/datum/admins/proc/save_server)
	admin_verbs_admin.Add(/datum/admins/proc/regenerate_mine)