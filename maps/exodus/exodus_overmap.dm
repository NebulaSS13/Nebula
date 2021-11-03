/obj/effect/overmap/visitable/ship/exodus
	name = "Exodus Station"
	color = "#00ffff"
	start_x = 4
	start_y = 4
	sector_flags = OVERMAP_SECTOR_KNOWN|OVERMAP_SECTOR_BASE|OVERMAP_SECTOR_IN_SPACE
	vessel_mass = 50000
	max_speed = 1/(20 SECONDS)
	burn_delay = 20 SECONDS
	initial_generic_waypoints = list(
		"nav_exodus_port_upper",
		"nav_exodus_fore_upper",
		"nav_exodus_aft_upper",
		"nav_exodus_starboard_lower",
		"nav_exodus_port_lower",
		"nav_exodus_fore_lower",
		"nav_exodus_aft_lower",
		"nav_exodus_engineering_pod_dock",
		"nav_exodus_mining_pod_dock",
		"nav_exodus_research_pod_dock"
	)

/obj/effect/overmap/visitable/ship/landable/pod
	name = "Generic Pod"
	desc = "A single-seater short-range pod."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 4000
	fore_dir = NORTH
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL

// Overmap transit landmarks
/obj/effect/shuttle_landmark/exodus_main_starboard
	name = "Exodus starboard approach"
	landmark_tag = "nav_exodus_starboard_upper"

/obj/effect/shuttle_landmark/exodus_main_port
	name = "Exodus port approach"
	landmark_tag = "nav_exodus_port_upper"

/obj/effect/shuttle_landmark/exodus_main_fore
	name = "Exodus fore approach"
	landmark_tag = "nav_exodus_fore_upper"

/obj/effect/shuttle_landmark/exodus_main_aft
	name = "Exodus aft approach"
	landmark_tag = "nav_exodus_aft_upper"

/obj/effect/shuttle_landmark/exodus_sub_starboard
	name = "Exodus starboard underside"
	landmark_tag = "nav_exodus_starboard_lower"

/obj/effect/shuttle_landmark/exodus_sub_port
	name = "Exodus port underside"
	landmark_tag = "nav_exodus_port_lower"

/obj/effect/shuttle_landmark/exodus_sub_fore
	name = "Exodus fore underside"
	landmark_tag = "nav_exodus_fore_lower"

/obj/effect/shuttle_landmark/exodus_sub_aft
	name = "Exodus aft underside"
	landmark_tag = "nav_exodus_aft_lower"
