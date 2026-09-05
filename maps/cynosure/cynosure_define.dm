/datum/map/cynosure
	name = "Cynosure"
	full_name = "Cynosure Station"
	path = "cynosure"
	lobby_screens = list('maps/cynosure/title_cynosure.png')
	overmap_ids = list(OVERMAP_ID_SPACE)

	lobby_tracks = list(
		/decl/music_track/chasing_time,
		/decl/music_track/epicintro2015,
		/decl/music_track/human,
		/decl/music_track/marhaba,
		/decl/music_track/treacherous_voyage,
		/decl/music_track/asfarasitgets,
		/decl/music_track/space_oddity,
		/decl/music_track/martiancowboy
	)

	station_name  = "Cynosure Station"
	station_short = "Cynosure"
	dock_name     = "NCS Northern Star"
	boss_name     = "Central Command"
	boss_short    = "Centcom"
	company_name  = "NanoTrasen"
	company_short = "NT"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has landed at Cynosure departures pad. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %dock_name% has been scheduled. The shuttle has been called. Those leaving should proceed to Cynosure Departures Pad in approximately %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	shuttle_arriving_at_dock_message = "The Crew Transfer Shuttle has docked at %dock_name%. Please disembark in an orderly fashion."

	emergency_shuttle_docked_message = "The Emergency Shuttle has landed at Cynosure departures pad. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at Cynosure departures pad in approximately %ETA%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_sound = 'sound/AI/shuttlecalled.ogg'
	emergency_shuttle_arriving_at_dock_message = "The Emergency Shuttle has docked at %dock_name%. Please disembark in an orderly fashion. If you are injured, please remain calm and await emergency medical response."

	command_report_sound = 'sound/AI/commandreport.ogg'
	grid_check_sound = 'sound/AI/poweroff.ogg'
	grid_restored_sound = 'sound/AI/poweron.ogg'
	meteor_detected_sound = 'sound/AI/meteors.ogg'
	radiation_detected_sound = 'sound/AI/radiation.ogg'
	space_time_anomaly_sound = 'sound/AI/spanomalies.ogg'
	unidentified_lifesigns_sound = 'sound/AI/aliens.ogg'

	default_telecomms_channels = list(
		COMMON_FREQUENCY_DATA,
		list("name" = "Entertainment", "key" = "z", "frequency" = 1461, "color" = COMMS_COLOR_ENTERTAIN, "span_class" = CSS_CLASS_RADIO, "receive_only" = TRUE),
		list("name" = "Command",       "key" = "c", "frequency" = 1353, "color" = COMMS_COLOR_COMMAND,   "span_class" = "comradio", "secured" = list(access_bridge)),
		list("name" = "Security",      "key" = "s", "frequency" = 1359, "color" = COMMS_COLOR_SECURITY,  "span_class" = "secradio", "secured" = list(access_security)),
		list("name" = "Engineering",   "key" = "e", "frequency" = 1357, "color" = COMMS_COLOR_ENGINEER,  "span_class" = "engradio", "secured" = list(access_engine)),
		list("name" = "Medical",       "key" = "m", "frequency" = 1355, "color" = COMMS_COLOR_MEDICAL,   "span_class" = "medradio", "secured" = list(access_medical)),
		list("name" = "Science",       "key" = "n", "frequency" = 1351, "color" = COMMS_COLOR_SCIENCE,   "span_class" = "sciradio", "secured" = list(access_research)),
		list("name" = "Service",       "key" = "v", "frequency" = 1349, "color" = COMMS_COLOR_SERVICE,   "span_class" = "srvradio", "secured" = list(access_bar)),
		list("name" = "Supply",        "key" = "u", "frequency" = 1347, "color" = COMMS_COLOR_SUPPLY,    "span_class" = "supradio", "secured" = list(access_cargo)),
		list("name" = "Exploration",   "key" = "x", "frequency" = 1361, "color" = COMMS_COLOR_EXPLORER , "span_class" = "EXPradio", "secured" = list(access_eva)),
		list("name" = "AI Private",    "key" = "p", "frequency" = 1343, "color" = COMMS_COLOR_AI,        "span_class" = "airadio",  "secured" = list(access_ai_upload))
	)

	evac_controller_type = /datum/evacuation_controller/shuttle
	lobby_handler = /decl/lobby_handler/cynosure

/datum/map/cynosure/get_map_info()
	. = list()
	. +=  "[full_name] is a a cutting-edge anomaly research facility on the frozen garden world of Sif, jewel of the Vir system.<br>"
	. +=  "Following the Skathari Incursion, an invasion of reality-bending creatures from the remnants of a dead universe, the known galaxy has been thrown into disarray.<br>"
	. +=  "The Solar Confederate Government struggles under its own weight, with new factions arising with promises of autonomy, security or profit like circling vultures.<br>"
	. +=  "Humanity already stands on the precipice of a technological singularity that few are ready to face, and the winds of change whip at their backs.<br>"
	. +=  "On the edge of Sif's Anomalous Region, NanoTrasen seeks to exploit new phenomena stirred by the Incursion... That's where you come in."
	return jointext(., "<br>")

/decl/lobby_handler/cynosure
	browser_height = 520
