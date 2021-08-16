/decl/keybinding
	abstract_type = /decl/keybinding
	var/name
	var/description
	var/list/hotkey_keys
	var/list/classic_keys

/decl/keybinding/Initialize()
	. = ..()
	// Default keys to the master "hotkey_keys"
	if(LAZYLEN(hotkey_keys) && !LAZYLEN(classic_keys))
		classic_keys = hotkey_keys.Copy()
	if(!is_abstract() && length(hotkey_keys))
		if(hotkey_keys[1] == KEYSTROKE_NONE)
			return // No default needed, is unbound.
		for(var/bound_key in hotkey_keys)
			if(!(bound_key in global.default_keybinds))
				global.default_keybinds[bound_key] = list(src)
				return
		PRINT_STACK_TRACE("Could not register default key for [type].")

/decl/keybinding/proc/down(client/user)
	return FALSE

/decl/keybinding/proc/up(client/user)
	return FALSE

/decl/keybinding/proc/can_use(client/user)
	return TRUE

