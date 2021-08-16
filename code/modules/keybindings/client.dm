/decl/keybinding/client
	name = "Client"
	abstract_type = /decl/keybinding/client

/decl/keybinding/client/admin_help
	hotkey_keys = list("F1")
	uid = "keybind_admin_help"
	name = "Admin Help"
	description = "Ask an admin for help"

/decl/keybinding/client/admin_help/down(client/user)
	user.adminhelp()
	return TRUE

/decl/keybinding/client/screenshot
	hotkey_keys = list(KEYSTROKE_NONE)
	uid = "keybind_screenshot"
	name = "Screenshot"
	description = "Take a screenshot"

/decl/keybinding/client/screenshot/down(client/user)
	winset(user, null, "command=.screenshot [!user.keys_held["shift"] ? "auto" : ""]")
	return TRUE

/decl/keybinding/client/fit_viewport
	hotkey_keys = list("CtrlF11")
	uid = "keybind_fit_viewport"
	name = "Fit Viewport"
	description = "Fits your viewport"

/decl/keybinding/client/fit_viewport/down(client/user)
	user.fit_viewport()
	return TRUE

/decl/keybinding/client/toggle_fullscreen
	hotkey_keys = list("F11")
	uid = "keybind_toggle_fullscreen"
	name = "Toggle Fullscreen"
	description = "Take a screenshot"

/decl/keybinding/client/toggle_fullscreen/down(client/user)
	user.toggle_fullscreen()
	return TRUE

/decl/keybinding/client/minimal_hud
	hotkey_keys = list("F12")
	uid = "keybind_minimal_hud"
	name = "Minimal HUD"
	description = "Hide most HUD features"

/decl/keybinding/client/minimal_hud/down(client/user)
	user.mob.button_pressed_F12()
	return TRUE
