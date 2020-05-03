/datum/map/persistence
	name = "Outreach"
	full_name = "Outreach Outpost"
	path = "persistence"

	station_levels = list(1, 2, 3, 4)
	contact_levels = list(1, 2, 3, 4)
	player_levels = list(1, 2, 3, 4)
	saved_levels = list(3, 4)
	mining_areas = list(1, 2)

	// A list of turfs and their default turfs for serialization optimization.
	default_z_turfs = list(
		/turf/simulated/floor/exoplanet = 3,
		/turf/simulated/open = 4
	)

	overmap_size = 35
	overmap_event_areas = 34

	allowed_spawns = list("Cyrogenic Storage")
	default_spawn = "Cyrogenic Storage"

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"

	lobby_screens = list(
		'maps/persistence/lobby/exoplanet.png'
	)
	lobby_tracks = list(
		/music_track/dirtyoldfrogg
	)

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

	use_overmap = TRUE
