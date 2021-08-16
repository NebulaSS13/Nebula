/decl/keybinding/admin
	name = "Admin"
	abstract_type = /decl/keybinding/admin

/decl/keybinding/admin/can_use(client/user)
	return !!user.holder

/decl/keybinding/admin/admin_say
	hotkey_keys = list("F5")
	uid = "keybind_admin_say"
	name = "Admin Say"
	description = "Talk with other admins."

/decl/keybinding/admin/admin_say/down(client/user)
	user.get_admin_say()
	return TRUE

/decl/keybinding/admin/admin_ghost
	hotkey_keys = list("F6")
	uid = "keybind_admin_ghost"
	name = "Aghost"
	description = "Go ghost"

/decl/keybinding/admin/admin_ghost/down(client/user)
	user.admin_ghost()
	return TRUE

/decl/keybinding/admin/list_players
	hotkey_keys = list("F7")
	uid = "keybind_list_players"
	name = "List Players"
	description = "Opens up the list players panel"

/decl/keybinding/admin/list_players/down(client/user)
	user.holder.list_players()
	return TRUE

/decl/keybinding/admin/admin_pm
	hotkey_keys = list("F8")
	uid = "keybind_admin_pm"
	name = "Admin PM"
	description = "Sends Admin PM message"

/decl/keybinding/admin/admin_pm/down(client/user)
	user.cmd_admin_pm_panel()
	return TRUE

/decl/keybinding/admin/invisimin
	hotkey_keys = list("F9")
	uid = "keybind_invisimin"
	name = "Admin Invisibility"
	description = "Toggles ghost-like invisibility (Don't abuse this)"

/decl/keybinding/admin/invisimin/down(client/user)
	user.invisimin()
	return TRUE

/decl/keybinding/admin/dead_say
	hotkey_keys = list("F10")
	uid = "keybind_dead_say"
	name = "Dead Say"
	description = "Allows you to send a message to dead chat"

/decl/keybinding/admin/dead_say/down(client/user)
	user.get_dead_say()
	return TRUE

/decl/keybinding/admin/deadmin
	hotkey_keys = list(KEYSTROKE_NONE)
	uid = "keybind_deadmin"
	name = "De-Admin"
	description = "Shed your admin powers"

/decl/keybinding/admin/deadmin/down(client/user)
	user.deadmin_self()
	return TRUE

/decl/keybinding/admin/readmin
	hotkey_keys = list(KEYSTROKE_NONE)
	uid = "keybind_readmin"
	name = "Re-Admin"
	description = "Regain your admin powers"

/decl/keybinding/admin/readmin/down(client/user)
	user.readmin_self()
	return TRUE

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text|null
	cmd_admin_say(msg)

/client/proc/get_dead_say()
	var/msg = input(src, null, "dsay \"text\"") as text
	dsay(msg)
