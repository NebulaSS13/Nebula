/obj/effect/overmap/visitable/ship/tradeship
	name = "Tradeship Ocelot Alpha"
	color = "#00ffff"
	start_x = 4
	start_y = 4
	vessel_mass = 5000
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	restricted_area = 30
	sector_flags = OVERMAP_SECTOR_KNOWN|OVERMAP_SECTOR_BASE|OVERMAP_SECTOR_IN_SPACE

	initial_generic_waypoints = list("nav_tradeship_below_bow", "nav_tradeship_below_starboardastern", "nav_tradeship_starboard_dock_pod")
	initial_restricted_waypoints = list(
		/datum/shuttle/autodock/overmap/exploration = list("nav_tradeship_port_dock_shuttle"), // exploration ship can only dock portside
	)
