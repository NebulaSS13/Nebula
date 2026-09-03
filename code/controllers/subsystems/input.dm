SUBSYSTEM_DEF(input)
	name = "Input"
	wait = 1 //SS_TICKER means this runs every tick
	init_order = SS_INIT_INPUT
	flags = SS_TICKER
	priority = SS_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	/// Standard macroset *ALL* players get
	var/list/macro_set
	/// Macros applied only to hotkey users
	var/list/hotkey_only_set
	/// Macros applied onlt to classic users
	var/list/classic_only_set
	/// Typecache of all unprintable keys that are safe for classic to bind
	var/list/unprintables_cache
	/// Macro IDs we shouldn't clear during client.clear_macros()
	var/list/protected_macro_ids


/datum/controller/subsystem/input/Initialize()
	setup_default_macro_sets()
	refresh_client_macro_sets()
	return ..()

// This is for when macro sets are eventualy datumized
/datum/controller/subsystem/input/proc/setup_default_macro_sets()
	macro_set = list(
		// These could probably just be put in the skin. I actually don't 	understand WHY they aren't just in the skin. Besides the use of defines for Tab.
		"Back" = "\".winset \\\"input.text=\\\"\\\"\\\"\"",
		"Tab" = "\".winset \\\"input.focus=true?map.focus=true input.background-color=[COLOR_INPUT_DISABLED]:input.focus=true input.background-color=[COLOR_INPUT_ENABLED]\\\"\"",
		"Escape" = "Reset-Held-Keys",
	)
	hotkey_only_set = list(
		// We don't need to protect printables with hotkey mode, We can save time and just use the magic key.
		"Any" = "\"KeyDown \[\[*\]\]\"",
		"Any+UP" = "\"KeyUp \[\[*\]\]\"",
	)
	classic_only_set = list(
		//We need to force these to capture them for macro modifiers.
		//Did I mention I fucking despise the way this system works at a base, almost reptilian-barely-understands-consciousness level?
		//Because I do.
		"Alt" = "\"KeyDown Alt\"",
		"Alt+UP" = "\"KeyUp Alt\"",
		"Ctrl" = "\"KeyDown Ctrl\"",
		"Ctrl+UP" = "\"KeyUp Ctrl\"",
	)
	// This list may be out of date, and may include keys not actually legal to bind?
	// The only full list is from 2008. http://www.byond.com/docs/notes/macro.html
	unprintables_cache = list(
		// Arrow Keys
		"North" = TRUE,
		"West" = TRUE,
		"East" = TRUE,
		"South" = TRUE,
		// Numpad-Lock Disabled
		"Northwest" = TRUE, // KP_Home
		"Northeast" = TRUE, // KP_PgUp
		"Center" = TRUE,
		"Southwest" = TRUE, // KP_End
		"Southeast" = TRUE, // KP_PgDn
		// Keys you really shouldn't touch, but are technically unprintable
		"Return" = TRUE,
		"Escape" = TRUE,
		"Delete" = TRUE,
		// Things I'm not sure BYOND actually supports anymore.
		"Select" = TRUE,
		"Execute" = TRUE,
		"Snapshot" = TRUE,
		"Attn" = TRUE,
		"CrSel" = TRUE,
		"ExSel" = TRUE,
		"ErEOF" = TRUE,
		"Zoom" = TRUE,
		"PA1" = TRUE,
		"OEMClear" = TRUE,
		// Things the modern ref says is okay
		"Pause" = TRUE,
		"Play" = TRUE,
		"Insert" = TRUE,
		"Help" = TRUE,
		"LWin" = TRUE,
		"RWin" = TRUE,
		"Apps" = TRUE,
		"Numpad0" = TRUE,
		"Numpad1" = TRUE,
		"Numpad2" = TRUE,
		"Numpad3" = TRUE,
		"Numpad4" = TRUE,
		"Numpad5" = TRUE,
		"Numpad6" = TRUE,
		"Numpad7" = TRUE,
		"Numpad8" = TRUE,
		"Numpad9" = TRUE,
		"Multiply" = TRUE,
		"Add" = TRUE,
		"Separator" = TRUE,
		"Subtract" = TRUE,
		"Decimal" = TRUE,
		"Divide" = TRUE,
		"F1" = TRUE,
		"F2" = TRUE,
		"F3" = TRUE,
		"F4" = TRUE,
		"F5" = TRUE,
		"F6" = TRUE,
		"F7" = TRUE,
		"F8" = TRUE,
		"F9" = TRUE,
		"F10" = TRUE,
		"F11" = TRUE,
		"F12" = TRUE,
		"F13" = TRUE,
		"F14" = TRUE,
		"F15" = TRUE,
		"F16" = TRUE,
		"F17" = TRUE,
		"F18" = TRUE,
		"F19" = TRUE,
		"F20" = TRUE,
		"F21" = TRUE,
		"F22" = TRUE,
		"F23" = TRUE,
		"F24" = TRUE,
	)
	// Macro IDs we don't delete on wipe, Usually stuff baked into the skin, or that we have to be more careful with.
	protected_macro_ids = list(
		"PROTECTED-Shift",
		"PROTECTED-ShiftUp"
	)

// Badmins just wanna have fun ♪
/datum/controller/subsystem/input/proc/refresh_client_macro_sets()
	for(var/client/C in global.clients)
		C.set_macros()

/datum/controller/subsystem/input/fire()
	for(var/client/C in global.clients)
		C.keyLoop()
