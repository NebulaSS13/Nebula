/obj/effect/overmap/visitable/ship/tradeship
	name = "Tradeship Ivenmoth"
	color = "#00ffff"
	start_x = 4
	start_y = 4
	base = 1
	vessel_mass = 5000
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS

	initial_generic_waypoints = list("nav_tradeship_below_bow", "nav_tradeship_below_starboardastern", "nav_tradeship_port_dock_shuttle")
	initial_restricted_waypoints = list(
		"Exploration Pod" = list("nav_tradeship_starboard_dock_pod"), //pod can only dock starboard-side, b/c there's only one door.
	)