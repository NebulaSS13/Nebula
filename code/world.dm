#define WORLD_ICON_SIZE 32

//This file is just for the necessary /world definition
//Try looking in game/world.dm

/world
	mob = /mob/new_player
	turf = /turf/unsimulated/dark_filler
	area = /area/space
	view = "15x15"
	cache_lifespan = 7
	hub = "Exadv1.spacestation13"
	icon_size = WORLD_ICON_SIZE
	fps = 20
#ifdef FIND_REF_NO_CHECK_TICK
#pragma push
#pragma ignore loop_checks
	loop_checks = FALSE
#pragma pop
#endif

#warn MACRO DEBUG CODE DO NOT PUSH

/client
	var/x_mt_watchingfocus = FALSE
	var/x_mt_winmon_enabled = FALSE
	var/list/x_mt_winmon_packet //Lazylist

/// Dumps the list of all macros. This should almost always be just default
/client/verb/dump_macroset_ids()
	set name = "mt Dump Macroset IDs"
	set category = "_MACRO_TEST"
	to_chat(usr, (jointext(splittext(winget(src, "", "macros"), ";"), "\n") || "NULL (Bad. Incredibly. Incredibly bad.)"))

/// List all children of default. Name for macros is their bound key.
/client/verb/dump_set()
	set name = "mt Dump default bindings"
	set category = "_MACRO_TEST"
	to_chat(usr, (jointext(splittext(winget(src, "default.*" , "name"), ";"), "\n")|| "NULL (Bad. Real bad.)"))

/// A slightly more pleasant way to execute free wingets.
/client/verb/arbitrary_winget(cmd as text)
	set name = "awing"
	set desc = "Run an arbitrary Winset call, Space-separated arguments."
	set category = "_MACRO_TEST"
	var/list/parts = splittext(cmd, " ")
	to_chat(usr, (winget(src, parts[1], parts[2]) || "NULL (Bad Call?)"))

/// A slightly more pleasant way to execute free winsets.
/client/verb/arbitrary_winset(cmd as text)
	set name = "aswin"
	set desc = "Run an arbitrary Winset call, Space-separated arguments."
	set category = "_MACRO_TEST"
	var/list/parts = splittext(cmd, " ")
	winset(src, parts[1], parts[2])
	to_chat(usr, ("CALLED: winset({client:[src.ckey]}, \"[parts[1]]\",\"[parts[2]]\")"))

/// Will dump the currently focused skin element to chat. Used for tracking down focus juggling issues.
/client/verb/focuswatch()
	set name = "mt toggle focus watch"
	set category = "_MACRO_TEST"
	if(x_mt_watchingfocus)
		x_mt_watchingfocus = FALSE
		return
	else
		x_mt_watchingfocus = TRUE
		while(x_mt_watchingfocus)
			// Live-report the element with focus.
			to_chat(usr, (winget(src, "", "focus") || "NULL (Entire game defocused?)"))
			sleep(0.5) //Every half second

/client/verb/winmon(cmd as text|null)
	set name = "winmon"
	set desc = "Repeatedly run a winget to monitor it's value"
	set category = "_MACRO_TEST"
	if(x_mt_winmon_enabled || isnull(cmd))
		x_mt_winmon_enabled = FALSE
		return
	else
		x_mt_winmon_enabled = TRUE
		var/list/parts = splittext(cmd, " ")
		x_mt_winmon_packet = parts
		while(x_mt_winmon_enabled)
			// Repeatedly rerun the same winget to watch the value
			var/winout = winget(src, x_mt_winmon_packet[1], x_mt_winmon_packet[2])
			to_chat(usr, ( winout ? "WINMON:[winout]": "WINMON: NULL (Bad Call?)"))
			sleep(0.5)