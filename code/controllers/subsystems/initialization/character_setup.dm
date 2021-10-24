SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	init_order = SS_INIT_CHAR_SETUP
	priority = SS_PRIORITY_CHAR_SETUP
	flags = SS_BACKGROUND
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/preferences_datums = list()
	var/list/chars_awaiting_load = list()
	var/list/newplayers_requiring_init = list()

	var/list/save_queue = list()

/datum/controller/subsystem/character_setup/Initialize()
	while(chars_awaiting_load.len)
		var/datum/preferences/prefs = chars_awaiting_load[chars_awaiting_load.len]
		chars_awaiting_load.len--
		prefs.lateload_character() // separated to avoid Initialize() crashing

	while(newplayers_requiring_init.len)
		var/mob/new_player/new_player = newplayers_requiring_init[newplayers_requiring_init.len]
		newplayers_requiring_init.len--
		new_player.deferred_login()

	. = ..()

/datum/controller/subsystem/character_setup/proc/queue_load_character(datum/preferences/prefs)
	// Calling this after subsytem's initialization is pointless
	// and the client's characters will never be loaded.
	ASSERT(!initialized)

	chars_awaiting_load += prefs

/datum/controller/subsystem/character_setup/fire(resumed = FALSE)
	while(save_queue.len)
		var/datum/preferences/prefs = save_queue[save_queue.len]
		save_queue.len--

		if(!QDELETED(prefs))
			prefs.save_preferences()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/character_setup/proc/queue_preferences_save(datum/preferences/prefs)
	save_queue |= prefs