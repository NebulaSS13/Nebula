/datum/map/fairpoint
	name          = "Fairpoint"
	full_name     = "Fairpoint Metropolitan Area, Upper Downtown District"
	path          = "fairpoint"

	station_name  = "Fairpoint, Upper Downtown District"
	station_short = "Upper Downtown"
	dock_name     = "Residential District Metro"
	boss_name     = "Office of the City Mayor"
	boss_short    = "Office of the Mayor"
	company_name  = "PLACEHOLDER"
	company_short = "HOLDER"
	num_exoplanets = 0
	system_name   = "Fairpoint"

	lobby_screens = list(
		'maps/fairpoint/lobby/cityscape.png'
	)

	evac_controller_type = null

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

	allowed_spawns = list(/decl/spawnpoint/cryo)
	default_spawn = /decl/spawnpoint/cryo

	exterior_atmos_composition = list(
		/decl/material/gas/oxygen = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)

/datum/map/fairpoint/get_map_info()
	return "Welcome to the Fairpoint Metropolitan Area. You are now arriving at the Upper Downtown district, an economic and social center of the city and one of its many borough districts. Enjoy your night!"

/datum/map/fairpoint/create_trade_hubs()
	new /datum/trade_hub/singleton/fairpoint

/datum/trade_hub/singleton/fairpoint
	name = "Fairpoint Freight Network"

/datum/trade_hub/singleton/fairpoint/get_initial_traders()
	return list(
		/datum/trader/medical,
		/datum/trader/mining,
		/datum/trader/books
	)