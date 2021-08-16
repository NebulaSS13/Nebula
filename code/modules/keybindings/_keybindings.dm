/decl/keybinding
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
		for(var/bound_key in hotkey_keys)
			LAZYINITLIST(global.hotkey_keybinding_list_by_key[bound_key])
			global.hotkey_keybinding_list_by_key[bound_key] += src

/decl/keybinding/proc/down(client/user)
	return FALSE

/decl/keybinding/proc/up(client/user)
	return FALSE

/decl/keybinding/proc/can_use(client/user)
	return TRUE

