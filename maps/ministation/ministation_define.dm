/datum/map/ministation
	name = "Ministation"
	full_name = "Ministation Zebra"
	path = "ministation"
	ground_noun = "floor"

	station_name = "Space Station Zebra"
	station_short = "Zebra"

	dock_name     = "Finite Beginnings Free Dock"
	boss_name     = "Trade Administration"
	boss_short    = "Admin"
	company_name  = "Free Trade Union Residual Delta"
	company_short = "RD"

	default_law_type = /datum/ai_laws/nanotrasen

	lobby_screens = list('maps/ministation/ministation_lobby.png')

	shuttle_docked_message = "The public ferry to %dock_name% has docked with the station. It will depart in approximately %ETD%"
	shuttle_leaving_dock   = "The public ferry has left the station. Estimate %ETA% until the ferry docks at %dock_name%."
	shuttle_called_message = "A public ferry to %dock_name% has been scheduled. It will arrive in approximately %ETA%"
	shuttle_recall_message = "The scheduled ferry has been cancelled."

	emergency_shuttle_docked_message = "The emergency shuttle has docked with the station. You have approximately %ETD% to board the emergency shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA%."
	emergency_shuttle_called_sound = 'sound/AI/shuttlecalled.ogg'

	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	evac_controller_type = /datum/evacuation_controller/shuttle

	pray_reward_type = /obj/item/mollusc/clam

	starting_money = 5000
	department_money = 1000
	salary_modifier = 0.2

	radiation_detected_message = "High levels of radiation have been detected in proximity of the %STATION_NAME%. Station wide maintenance access has been granted. Please take shelter within the nearest maintenance tunnel."

	allowed_spawns = list(
		/decl/spawnpoint/arrivals,
		/decl/spawnpoint/cryo
	)
	default_spawn = /decl/spawnpoint/arrivals


/datum/map/ministation/get_map_info()
	return "You're aboard the <b>[station_name],</b> an older station once used for unethical scientific research. It has long since been repurposed as deep space communication relay, though only on paper. \
	Onboard activity is at the whims of the [boss_name] who treat the station as a glorified dogsbody, and sometimes guinea pig."
