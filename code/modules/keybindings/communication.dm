/decl/keybinding/client/communication
	name = "Communication"
	abstract_type = /decl/keybinding/client/communication

/decl/keybinding/client/communication/say
	hotkey_keys = list("F3", "T")
	uid = "keybind_Say"
	name = "IC Say"

/decl/keybinding/client/communication/ooc
	hotkey_keys = list("F2", "O")
	uid = "keybind_OOC"
	name = "Out Of Character Say (OOC)"

/decl/keybinding/client/communication/looc
	hotkey_keys = list("L")
	uid = "keybind_LOOC"
	name = "Local Out Of Character Say (LOOC)"

/decl/keybinding/client/communication/looc/down(client/user)
	user.looc()
	return TRUE

/decl/keybinding/client/communication/me
	hotkey_keys = list("F4", "M")
	uid = "keybind_Me"
	name = "Custom Emote (/Me)"

/decl/keybinding/client/communication/me/down(client/user)
	user.mob.me_wrapper()
	return TRUE
