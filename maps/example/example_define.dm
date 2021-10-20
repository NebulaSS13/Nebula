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

	allowed_spawns = list(/decl/spawnpoint/arrivals)

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"
