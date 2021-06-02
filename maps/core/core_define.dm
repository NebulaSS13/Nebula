/datum/map/core
	name = "Core"
	full_name = "ISC Core"
	path = "core"
	ground_noun = "plated covering"

	station_levels = list(1, 2)
	contact_levels = list(1, 2)
	player_levels  = list(1, 2)

	station_name  = "Independent Space Complex \"Core\""
	station_short = "Core"

	dock_name     = "Communications HQ"
	boss_name     = "Logistics Director"
	boss_short    = "LD"
	company_name  = "Private Resupply Industries"
	company_short = "PRI"

	lobby_screens = list('maps/core/lobby/vapormoney.png')
	welcome_sound = 'sound/effects/alarm.ogg'

	overmap_event_areas = 11
	use_overmap = 1
	num_exoplanets = 0

	emergency_shuttle_leaving_dock = "Attention all hands: the escape pods have been launched, maintaining burn for %ETA%."
	emergency_shuttle_called_message = "Attention all hands: emergency evacuation procedures are now in effect. Escape pods will launch in %ETA%"
	emergency_shuttle_recall_message = "Attention all hands: emergency evacuation sequence aborted. Return to normal operating conditions."
	evac_controller_type = /datum/evacuation_controller/lifepods

	starting_money = 70000
	department_money = 0
	salary_modifier = 1

	radiation_detected_message = "High levels of radiation have been detected in proximity of the %STATION_NAME%. Please move to the closest saferoom available."

	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"

/datum/map/core/get_map_info()
	return "You're aboard the <b>[station_name],</b> a space complex positioned at the vast frontier of space. \
    Whenever you take a bunk in the station staff or captain one of the many currently docked shuttles - it's a good thing this station is still operating."

/datum/map/core/create_trade_hubs()
	new/datum/trade_hub/core()

/datum/trade_hub/core
	name = "Long-Range Subspace Trade Uplink"

/datum/trade_hub/core/get_initial_traders()
	return list(
		/datum/trader/medical,
		/datum/trader/mining
	)
