/datum/map/example
	name = "Example"
	full_name = "The Example"
	path = "example"

	lobby_screens = list(
		'maps/example/example_lobby.png'
	)

	lobby_tracks = list(
		/decl/music_track/absconditus
	)

	station_levels = list(1, 2, 3)
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3)

	allowed_spawns = list("Arrivals Shuttle")

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"

	default_telecomms_channels = list(
		COMMON_FREQUENCY_DATA,
		list("name" = "Entertainment", "key" = "z", "frequency" = 1461, "color" = COMMS_COLOR_ENTERTAIN, "span_class" = ".radio",    "receive_only" = TRUE),
		list("name" = "Command",       "key" = "c", "frequency" = 1353, "color" = COMMS_COLOR_COMMAND,   "span_class" = ".comradio", "secured" = access_bridge),
		list("name" = "Security",      "key" = "s", "frequency" = 1359, "color" = COMMS_COLOR_SECURITY,  "span_class" = ".secradio", "secured" = access_security),
		list("name" = "Engineering",   "key" = "e", "frequency" = 1357, "color" = COMMS_COLOR_ENGINEER,  "span_class" = ".engradio", "secured" = access_engine),
		list("name" = "Medical",       "key" = "m", "frequency" = 1355, "color" = COMMS_COLOR_MEDICAL,   "span_class" = ".medradio", "secured" = access_medical),
		list("name" = "Science",       "key" = "n", "frequency" = 1351, "color" = COMMS_COLOR_SCIENCE,   "span_class" = ".sciradio", "secured" = access_research),
		list("name" = "Service",       "key" = "v", "frequency" = 1349, "color" = COMMS_COLOR_SERVICE,   "span_class" = ".srvradio", "secured" = access_bar),
		list("name" = "Supply",        "key" = "u", "frequency" = 1347, "color" = COMMS_COLOR_SUPPLY,    "span_class" = ".supradio", "secured" = access_cargo),
		list("name" = "Exploration",   "key" = "x", "frequency" = 1361, "color" = COMMS_COLOR_EXPLORER , "span_class" = ".EXPradio", "secured" = access_eva),
		list("name" = "AI Private",    "key" = "p", "frequency" = 1343, "color" = COMMS_COLOR_AI,        "span_class" = ".airadio",  "secured" = access_ai_upload)
	)
