/datum/game_mode/persistent
	name = "Persistent"
	config_tag = "persistent"
	required_players = 0
	round_description = "Just have fun and role-play, everything saves!"
	extended_round_description = "There are no antagonists, unless an admin creates one. The game saves and you keep everything you've done, so try not to blow everything up!"
	addantag_allowed = ADDANTAG_ADMIN

	ert_disabled = TRUE
	auto_recall_shuttle = TRUE 

/datum/game_mode/persistent/post_setup()
	next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)

	refresh_event_modifiers()

	SSstatistics.set_field_details("round_start","[time2text(world.realtime)]")
	if(SSticker.mode)
		SSstatistics.set_field_details("game_mode","[SSticker.mode]")
	SSstatistics.set_field_details("server_ip","[world.internet_address]:[world.port]")
	return 1