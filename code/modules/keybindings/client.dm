/datum/keybinding/client
	category = CATEGORY_CLIENT

/datum/keybinding/client/hotkey_mode
	hotkey_keys = list("Tab")
	name = "hotkey_mode"
	full_name = "Toggle Hotkeys"

/datum/keybinding/client/hotkey_mode/down(client/user)
	if(user.prefs)
		user.prefs.hotkeys = !user.prefs.hotkeys
		if(user.prefs.hotkeys)
			winset(user, null, "outputwindow.input.background-color=[COLOR_INPUT_DISABLED];mapwindow.map.focus=true")
		else
			winset(user, null, "outputwindow.input.background-color=[COLOR_INPUT_ENABLED];outputwindow.input.focus=true")
	return TRUE

/datum/keybinding/client/admin_help
	hotkey_keys = list("F1")
	name = "admin_help"
	full_name = "Admin Help"
	description = "Ask an admin for help"

/datum/keybinding/client/screenshot
	hotkey_keys = list("Unbound")
	name = "screenshot"
	full_name = "Save screenshot as..."
	description = "Take a screenshot"

/datum/keybinding/client/screenshot/down(client/user)
	winset(user, null, "command=.screenshot")
	return TRUE

/datum/keybinding/client/toggle_fullscreen
	hotkey_keys = list("F11")
	name = "toggle_fullscreen"
	full_name = "Toggle Fullscreen"
	description = "Toggles fullscreen mode"

/datum/keybinding/client/toggle_fullscreen/down(client/user)
	user.cycle_preference(/datum/client_preference/fullscreen_mode)
	return TRUE

/datum/keybinding/client/fit_viewport
	hotkey_keys = list("ShiftF11")
	name = "fit_viewport"
	full_name = "Fit Viewport"
	description = "Fits your viewport"

/datum/keybinding/client/fit_viewport/down(client/user)
	user.fit_viewport()
	return TRUE
