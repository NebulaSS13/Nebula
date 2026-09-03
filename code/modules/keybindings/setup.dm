// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	return
/datum/proc/key_up(key, client/user) // Called when a key is released
	return
/datum/proc/keyLoop(client/user) // Called once every frame
	set waitfor = FALSE
	return

// removes all the existing macros
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")
		var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
		erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)

/// Apply client macros. Has a system to prevent infighting overcalls.
/client/proc/set_macros()
	set waitfor = FALSE //We're going to sleep here even more than TG.

	/* Queue States:
	 * 0 - No running updates
	 * 1 - Running update
	 * 2 - Update requested while already updating. Will rerun update next tick.
	 * 3 - Update requested while already in state 2. Will immediately return.
	 */
	updating_macros++
	if(updating_macros > 2) //Are we the only one in line?
		updating_macros-- //No, dequeue and let them handle it.
		return
	//This isn't an UNTIL because we would rather this lag than deadlock.
	while(!(updating_macros == 1))
		sleep(1)

	//Get their personal macro set, This may be null if we're loading too early
	var/list/personal_macro_set = prefs?.key_bindings
	if(!personal_macro_set)
		//We're too early, Just return, Someone'll follow us up.
		updating_macros--
		return

	//Reset the buffer
	reset_held_keys()

	erase_all_macros()

	//Set up the stuff we don't let them override.
	var/list/macro_set = SSinput.macro_set
	for(var/k in 1 to length(macro_set))
		var/key = macro_set[k]
		var/command = macro_set[key]
		winset(src, "shared-\ref[key]", "parent=default;name=[key];command=[command]")

	var/list/printables
	//If they use hotkeys, we can safely use ANY
	if(prefs.hotkeys)
		var/list/hk_macro_set = SSinput.hotkey_only_set
		for(var/k in 1 to length(hk_macro_set))
			var/key = hk_macro_set[k]
			var/command = hk_macro_set[key]
			winset(src, "hotkey_only-\ref[key]", "parent=default;name=[key];command=[command]")
	else //Otherwise, we can't.
		/// Install the shared set, so that we force capture all modifier keys
		var/list/c_macro_set = SSinput.classic_only_set
		for(var/k in 1 to length(c_macro_set))
			var/key = c_macro_set[k]
			var/command = c_macro_set[key]
			winset(src, "classic_only-\ref[key]", "parent=default;name=[key];command=[command]")
		printables = list()
		//This is to save time muching down this massive list, it might result in holes, it may be better to simply hardcode all these into the skin.
		//I might try that one day, but that day is not today.
		for(var/key in personal_macro_set) //We don't care about the bound key, just the key itself
			if(!prefs.hotkeys && !SSinput.unprintables_cache[key]) //Track printable hotkeys and skip them.
				printables += key
				continue
			winset(src, "personal-\ref[key]", "parent=default;name=[key];command=\"KeyDown [key]\"")
			winset(src, "personal-\ref[key]]-UP", "parent=default;name=[key]+UP;command=\"KeyUp [key]\"")


	if(prefs.hotkeys)
		winset(src, null, "input.background-color=[COLOR_INPUT_ENABLED]")
	else
		winset(src, null, "input.background-color=[COLOR_INPUT_DISABLED]")

	//Do we have bad bindings at all, and if so, do we actually care?
	if(printables?.len && !prefs.hotkeys)
		to_chat(src, "<span class='boldnotice'>Hey, you might have some bad keybinds!</span>\n\
		<span class='notice'>The following keys are bound despite Classic Hotkeys being enabled. These binds are not applied.\n\
		The code used to generate this list is imperfect, You can silence this warning in your Game Preferences.</span>\n\
		Keys: [jointext(printables, ", ")]\
		") //Pref NYI, FIXME, beat me with a stick before margetime.

	update_special_keybinds()
	updating_macros-- //Decrement, Let the next thread through.

// byond bug ID:2694120
/client/verb/reset_macros_wrapper()
	set name = "Fix Keybindings"
	set category = "OOC"
	reset_macros()

/client/proc/reset_macros(skip = FALSE)
	if(!skip)
		if(alert(src, "Change your keyboard language to ENG and press Ok", "Reset macros") != "Ok")
			return
		to_chat(src, SPAN_NOTICE("Keybindings should be fixed now."))
	set_macros()

/**
 * Manually clears any held keys, in case due to lag or other undefined behavior a key gets stuck.
 *
 * Hardcoded to the ESC key.
 */
/client/verb/reset_held_keys()
	set name = "Reset Held Keys"
	set hidden = TRUE

	for(var/key in keys_held)
		keyUp(key)

	//In case one got stuck and the previous loop didn't clean it, somehow.
	for(var/key in key_combos_held)
		keyUp(key_combos_held[key])
