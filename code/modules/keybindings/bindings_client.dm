// Clients aren't datums so we have to define these procs indpendently.
// These verbs are called for all key press and release events
/client/verb/keyDown(_key as text)
	set hidden = TRUE

	// So here's some eplaination why we use `instant`.
	// Due of verbs nature, you can use the same verb limited time per tick.
	// This means, you unable to perform combinated keypresses at the same time.
	// (i.e multiple movement key press for diagonal direction move)
	// (or ShiftF5 where we press two different keys at the same time)
	// In current case, we should make this verb instant.
	set instant = TRUE

	client_keysend_amount += 1

	var/cache = client_keysend_amount

	if(keysend_tripped && next_keysend_trip_reset <= world.time)
		keysend_tripped = FALSE

	if(next_keysend_reset <= world.time)
		client_keysend_amount = 0
		next_keysend_reset = world.time + (1 SECONDS)

	// The "tripped" system is to confirm that flooding is still happening after one spike
	// not entirely sure how byond commands interact in relation to lag
	// don't want to kick people if a lag spike results in a huge flood of commands being sent
	if(cache >= MAX_KEYPRESS_AUTOKICK)
		if(!keysend_tripped)
			keysend_tripped = TRUE
			next_keysend_trip_reset = world.time + (2 SECONDS)
		else
			log_admin("Client [ckey] was just autokicked for flooding keysends; likely abuse but potentially lagspike.")
			message_admins("Client [ckey] was just autokicked for flooding keysends; likely abuse but potentially lagspike.")
			qdel(src)
			return

	///Check if the key is short enough to even be a real key
	if(LAZYLEN(_key) > MAX_KEYPRESS_COMMANDLENGTH)
		to_chat(src, SPAN_DANGER("Invalid KeyDown detected! You have been disconnected from the server automatically."))
		log_admin("Client [ckey] just attempted to send an invalid keypress. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		message_admins("Client [ckey] just attempted to send an invalid keypress. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		qdel(src)
		return

	//Focus Chat failsafe. Overrides movement checks to prevent WASD.
	if(!prefs.hotkeys && length(_key) == 1 && _key != "Alt" && _key != "Ctrl" && _key != "Shift")
		winset(src, null, "outputwindow.input.focus=true ; input.text=[url_encode(_key)]")
		return

	if(length(keys_held) >= HELD_KEY_BUFFER_LENGTH && !keys_held[_key])
		keyUp(keys_held[1]) //We are going over the number of possible held keys, so let's remove the first one.

	//the time a key was pressed isn't actually used anywhere (as of 2019-9-10) but this allows easier access usage/checking
	keys_held[_key] = world.time
	if(!movement_locked)
		var/movement = movement_keys[_key]
		if(!(next_move_dir_sub & movement))
			next_move_dir_add |= movement

		if(movement && !config.allow_diagonal_movement)
			last_move_dir_pressed = movement

	// Client-level keybindings are ones anyone should be able to do at any time
	// Things like taking screenshots, hitting tab, and adminhelps.
	var/AltMod = keys_held["Alt"] ? "Alt" : ""
	var/CtrlMod = keys_held["Ctrl"] ? "Ctrl" : ""
	var/ShiftMod = keys_held["Shift"] ? "Shift" : ""
	var/full_key
	switch(_key)
		if("Alt", "Ctrl", "Shift")
			full_key = "[AltMod][CtrlMod][ShiftMod]"
		else
			if(AltMod || CtrlMod || ShiftMod)
				full_key = "[AltMod][CtrlMod][ShiftMod][_key]"
				key_combos_held[_key] = full_key
			else
				_key = capitalize(_key)
				full_key = _key
	var/keycount = 0
	for(var/kb_name in prefs.key_bindings[full_key])
		keycount++
		var/datum/keybinding/kb = global.keybindings_by_name[kb_name]
		if(kb.can_use(src) && kb.down(src) && keycount >= MAX_COMMANDS_PER_KEY)
			break

	holder?.key_down(full_key, src)
	mob.key_down(full_key, src)

	mob.update_mouse_pointer()

/client/verb/keyUp(_key as text)
	set instant = TRUE
	set hidden = TRUE

	var/key_combo = key_combos_held[_key]
	if(key_combo)
		key_combos_held -= _key
		keyUp(key_combo)

	if(!keys_held[_key])
		return

	keys_held -= _key

	if(!movement_locked)
		var/movement = movement_keys[_key]
		if(!(next_move_dir_add & movement))
			next_move_dir_sub |= movement

	// We don't do full key for release, because for mod keys you
	// can hold different keys and releasing any should be handled by the key binding specifically
	for (var/kb_name in prefs.key_bindings[_key])
		var/datum/keybinding/kb = global.keybindings_by_name[kb_name]
		if(kb.can_use(src) && kb.up(src))
			break
	holder?.key_up(_key, src)
	mob.key_up(_key, src)

	mob.update_mouse_pointer()

// Called every game tick
/client/keyLoop()
	holder?.keyLoop(src)
	mob.keyLoop(src)
