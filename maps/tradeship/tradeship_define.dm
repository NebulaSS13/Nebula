/datum/map/tradeship
	name = "Tradeship"
	full_name = "Tradeship Ivenmoth"
	path = "tradeship"

	station_name  = "Tradeship Ivenmoth"
	station_short = "Ivenmoth"

	dock_name     = "Val Salia Station"
	boss_name     = "Trade Administration"
	boss_short    = "Admin"
	company_name  = "Tradehouse Ivenmoth"
	company_short = "Ivenmoth"
	overmap_event_areas = 11

	default_law_type = /datum/ai_laws/corporate

	// yingspace.png was remixed from Out-Of-Placers assets by Raptie and is included with kind permission.
	lobby_screens = list('maps/tradeship/lobby/yingspace.png')

	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"
	use_overmap = 1
	num_exoplanets = 3
	welcome_sound = 'sound/effects/cowboysting.ogg'
	emergency_shuttle_leaving_dock = "Attention all hands: the escape pods have been launched, maintaining burn for %ETA%."
	emergency_shuttle_called_message = "Attention all hands: emergency evacuation procedures are now in effect. Escape pods will launch in %ETA%"
	emergency_shuttle_called_sound = sound('sound/AI/torch/abandonship.ogg', volume = 45)
	emergency_shuttle_recall_message = "Attention all hands: emergency evacuation sequence aborted. Return to normal operating conditions."
	evac_controller_type = /datum/evacuation_controller/lifepods

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

/datum/map/tradeship/get_map_info()
	return "You're aboard the <b>[station_name],</b> a survey and mercantile vessel affiliated with <b>Tradehouse Ivenmoth</b>, a large merchant guild operating out of Val Salia Station. \
	No meaningful authorities can claim the planets and resources in this uncharted sector, so their exploitation is entirely up to you - mine, poach and deforest all you want."

/datum/map/tradeship/setup_map()
	..()
	SStrade.traders += new /datum/trader/xeno_shop
	SStrade.traders += new /datum/trader/medical
	SStrade.traders += new /datum/trader/mining