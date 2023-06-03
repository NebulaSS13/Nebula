/datum/map/nexus
	name = "nexus"
	full_name = "ISC Nexus"
	path = "nexus"
	ground_noun = "plated covering"

	station_name  = "Independent Space Complex \"Nexus\""
	station_short = "Nexus"

	dock_name     = "Communications HQ"
	boss_name     = "Logistics Director"
	boss_short    = "LD"
	company_name  = "Private Resupply Industries"
	company_short = "PRI"

	lobby_screens = list('maps/nexus/lobby/nexus_lobby.png')
	welcome_sound = 'sound/effects/alarm.ogg'

	overmap_ids = list(OVERMAP_ID_SPACE)
	num_exoplanets = 1

	emergency_shuttle_leaving_dock = "Attention all hands: the escape pods have been launched, maintaining burn for %ETA%."
	emergency_shuttle_called_message = "Attention all hands: emergency evacuation procedures are now in effect. Escape pods will launch in %ETA%"
	emergency_shuttle_recall_message = "Attention all hands: emergency evacuation sequence aborted. Return to normal operating conditions."
	evac_controller_type = /datum/evacuation_controller/lifepods

	starting_money = 70000
	department_money = 0
	salary_modifier = 1

	radiation_detected_message = "High levels of radiation have been detected in proximity of the %STATION_NAME%. Please move to the closest saferoom available."

	allowed_spawns = list(/decl/spawnpoint/cryo)
	default_spawn = /decl/spawnpoint/cryo

	default_telecomms_channels = list(
		list("name" = "Science",       "key" = "n", "frequency" = 1351, "color" = COMMS_COLOR_SCIENCE,   "span_class" = "sciradio", "secured" = list(access_research)),
		list("name" = "Medical",       "key" = "m", "frequency" = 1355, "color" = COMMS_COLOR_MEDICAL,   "span_class" = "medradio", "secured" = list(access_medical)),
		list("name" = "Supply",        "key" = "u", "frequency" = 1347, "color" = COMMS_COLOR_SUPPLY,    "span_class" = "supradio", "secured" = list(access_cargo)),
		list("name" = "Service",       "key" = "v", "frequency" = 1349, "color" = COMMS_COLOR_SERVICE,   "span_class" = "srvradio", "secured" = list(access_bar)),
		COMMON_FREQUENCY_DATA,
		list("name" = "AI Private",    "key" = "p", "frequency" = 1343, "color" = COMMS_COLOR_AI,        "span_class" = "airadio",  "secured" = list(access_ai_upload)),
		list("name" = "Entertainment", "key" = "z", "frequency" = 1461, "color" = COMMS_COLOR_ENTERTAIN, "span_class" = CSS_CLASS_RADIO, "receive_only" = TRUE),
		list("name" = "Command",       "key" = "c", "frequency" = 1353, "color" = COMMS_COLOR_COMMAND,   "span_class" = "comradio", "secured" = list(access_bridge)),
		list("name" = "Engineering",   "key" = "e", "frequency" = 1357, "color" = COMMS_COLOR_ENGINEER,  "span_class" = "engradio", "secured" = list(access_engine)),
		list("name" = "Security",      "key" = "s", "frequency" = 1359, "color" = COMMS_COLOR_SECURITY,  "span_class" = "secradio", "secured" = list(access_security))
		)

/datum/map/nexus/get_map_info()
	return "You're aboard the <b>[station_name],</b> a space complex positioned at the vast frontier of space. \
	Whenever you take a bunk in the station staff or captain one of the many currently docked shuttles - it's a good thing this station is still operating."

/datum/map/nexus/create_trade_hubs()
	new/datum/trade_hub/nexus()

/datum/trade_hub/nexus
	name = "Long-Range Subspace Trade Uplink"

/datum/trade_hub/nexus/get_initial_traders()
	return list(
		/datum/trader/medical,
		/datum/trader/mining
	)
