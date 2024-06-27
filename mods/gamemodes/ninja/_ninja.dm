/decl/modpack/ninja
	name = "Ninja Gamemode"

/decl/modpack/ninja/initialize()
	. = ..()
	admin_verbs_fun += /datum/admins/proc/toggle_space_ninja
	admin_verbs_server += /datum/admins/proc/toggle_space_ninja
	admin_verbs_hideable += /datum/admins/proc/toggle_space_ninja