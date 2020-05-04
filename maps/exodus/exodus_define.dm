/datum/map/exodus
	name =                 "Walkabout"
	full_name =            "Walkabout Station"
	path =                 "exodus"
	station_name  =        "Walkabout Station"
	station_short =        "Walkabout"
	dock_name     =        "New Gundagai"
	boss_name     =        "Peregrine Group"
	boss_short    =        "PG"
	company_name  =        "Peregrine Group"
	company_short =        "PG"
	system_name =          "Tailem's Star"

	station_levels =       list(1,2)
	contact_levels =       list(1,2)
	player_levels =        list(1,2)
	admin_levels =         list(3)
	evac_controller_type = /datum/evacuation_controller/starship

	shuttle_docked_message = "The public ferry to %dock_name% has docked with the station. It will depart in approximately %ETD%"
	shuttle_leaving_dock =   "The public ferry has left the station. Estimate %ETA% until the ferry docks at %dock_name%."
	shuttle_called_message = "A public ferry to %dock_name% has been scheduled. It will arrive in approximately %ETA%"
	shuttle_recall_message = "The scheduled ferry has been cancelled."

/datum/map/exodus/get_map_info()
	return "Welcome to Walkabout Station, one of the largest remaining stopovers between the core worlds and the rim. Once a corporate science station called the Exodus, it has been recently refurbished and rezoned for civilian use. Enjoy your stay!"
