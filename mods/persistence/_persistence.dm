/decl/modpack/persistence
	name = "Persistence Gamemode Content"

/decl/modpack/persistence/initialize()
	. = ..()
	admin_verbs_admin.Add(/client/proc/save_server)
	admin_verbs_admin.Add(/client/proc/regenerate_mine)
	admin_verbs_admin.Remove(/client/proc/admin_ghost)
	admin_verbs_admin.Add(/client/proc/special_admin_ghost)