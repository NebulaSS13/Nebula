/datum/map/ministation
	name = "Ministation"
	full_name = "Ministation Zebra"
	path = "ministation"
	ground_noun = "floor"

	station_levels = list(1)
	contact_levels = list(1)
	player_levels = list(1)

	station_name = "Space Station Zebra"
	station_short = "Zebra"

	dock_name     = "Finite Beginnings Free Dock"
	boss_name     = "Trade Administration"
	boss_short    = "Admin"
	company_name  = "Free Trade Union Residual Delta"
	company_short = "RD"
	overmap_event_areas = 11

	default_law_type = /datum/ai_laws/nanotrasen

	lobby_screens = list('maps/ministation/lobby.png')

	//TEMPORARY NOTE: Evac messages are temporary until its set up properly. Make sure they're changed later.
	emergency_shuttle_leaving_dock = "Attention all crew members: the escape shuttle will be arriving shortly, please prepare to board."
	emergency_shuttle_called_message = "Attention all crew members: emergency evacuation procedures are now in effect. Please make your way to the port hallway docking area in a calm and orderly manner."
	emergency_shuttle_recall_message = "Attention all crew members: emergency evacuation sequence aborted. Return to normal operating conditions."
	evac_controller_type = /datum/evacuation_controller/ministation_substitute

	station_networks = list(
		NETWORK_EXODUS,
		NETWORK_MINE,
		NETWORK_SECURITY,
		NETWORK_RESEARCH,
		NETWORK_MEDICAL,
		NETWORK_ENGINEERING,
		NETWORK_ROBOTS,
		"Satellite",
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER)

	pray_reward_type = /obj/item/mollusc/clam

	starting_money = 5000
	department_money = 1000
	salary_modifier = 0.2

	radiation_detected_message = "High levels of radiation have been detected in proximity of the %STATION_NAME%. Station wide maintenance access has been granted. Please take shelter within the nearest maintenance tunnel."

	allowed_spawns = list("Arrivals Shuttle","Cryogenic Storage")
	default_spawn = "Arrivals Shuttle"


/datum/map/ministation/get_map_info()
	return "You're aboard the <b>[station_name],</b> an older station once used for unethical scientific research. It has long since been repurposed as deep space communication relay, though only on paper. \
	Onboard activity is at the whims of the [boss_name] who treat the station as a glorafied dogsbody, and sometimes guinea pig."

/datum/evacuation_controller/ministation_substitute
	name = "lazy ministation evac controller"
	evac_prep_delay =    6 MINUTES
	evac_launch_delay =  1 SECONDS
	evac_transit_delay = 1 SECONDS