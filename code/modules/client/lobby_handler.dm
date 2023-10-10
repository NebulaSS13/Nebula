/decl/lobby_handler
	var/list/lobby_options = list(
		/datum/lobby_option/setup,
		/datum/lobby_option/view_manifest,
		/datum/lobby_option/observe,
		/datum/lobby_option/character_setup
	)

/decl/lobby_handler/Initialize()
	. = ..()
	for(var/option in lobby_options)
		lobby_options += new option(src)
		lobby_options -= option
	lobby_options = sortTim(lobby_options, /proc/cmp_lobby_option_asc)

/decl/lobby_handler/proc/get_lobby_header(var/mob/new_player/viewer)
	return "<i>[global.using_map.get_map_info()]</i><hr>"

/decl/lobby_handler/proc/get_lobby_footer(var/mob/new_player/viewer)
	return

/datum/lobby_option
	var/sort_priority = 0

/datum/lobby_option/proc/visible(var/mob/new_player/viewer)
	return TRUE

/datum/lobby_option/proc/get_lobby_menu_string(var/mob/new_player/viewer)
	return

/datum/lobby_option/setup
	sort_priority = 1

/datum/lobby_option/setup/get_lobby_menu_string(var/mob/new_player/viewer)
	return "<a href='byond://?src=\ref[viewer];lobby_setup=1'>Setup Character</A> "

/datum/lobby_option/view_manifest
	sort_priority = 2

/datum/lobby_option/view_manifest/visible(var/mob/new_player/viewer)
	return (GAME_STATE > RUNLEVEL_LOBBY)

/datum/lobby_option/view_manifest/get_lobby_menu_string(var/mob/new_player/viewer)
	return "<a href='byond://?src=\ref[viewer];lobby_crew=1'>View the Crew Manifest</A> "

/datum/lobby_option/observe
	sort_priority = 3

/datum/lobby_option/observe/get_lobby_menu_string(var/mob/new_player/viewer)
	return "<a href='byond://?src=\ref[viewer];lobby_observe=1'>Observe</A> "

/datum/lobby_option/character_setup
	sort_priority = 4

/datum/lobby_option/character_setup/get_lobby_menu_string(var/mob/new_player/viewer)
	var/list/return_string = list()
	return_string += "<hr>Current character: <a href='byond://?src=\ref[viewer.client.prefs];load=1'>"
	return_string += "<b>[viewer.client.prefs.real_name]</b></a>"
	return_string += "[viewer.client.prefs.job_high ? ", [viewer.client.prefs.job_high]" : null]<br>"

	if(GAME_STATE <= RUNLEVEL_LOBBY)
		if(viewer.ready)
			return_string += "<a class='linkOn' href='byond://?src=\ref[viewer];lobby_ready=1'>Un-Ready</a>"
		else
			return_string += "<a href='byond://?src=\ref[viewer];lobby_ready=1'>Ready Up</a>"
	else
		return_string += "<a href='byond://?src=\ref[viewer];lobby_join=1'>Join Game!</A>"
	return JOINTEXT(return_string)
