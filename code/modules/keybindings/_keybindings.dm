/datum/keybinding
	/// A default hotkey keys.
	var/list/hotkey_keys
	/// A classic hotkey keys when client don't use hotkey mode. Uses `hotkey_keys` if not defined.
	var/list/classic_keys

	/// A unique keybind id for preference storing.
	var/name
	/// A full keybind name for displaying.
	var/full_name
	/// A bit informative description what this keybind does.
	var/description

	/// A keybind category for sorting in preference menu.
	var/category = CATEGORY_MISC

/datum/keybinding/New()
	// Default keys to the master "hotkey_keys"
	if(LAZYLEN(hotkey_keys) && !LAZYLEN(classic_keys))
		classic_keys = hotkey_keys.Copy()

/datum/keybinding/proc/down(client/user)
	return FALSE

/datum/keybinding/proc/up(client/user)
	return FALSE

/datum/keybinding/proc/can_use(client/user)
	return TRUE
