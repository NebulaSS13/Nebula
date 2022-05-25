/datum/map_template/ruin/away_site/tanker
	name = "tanker shuttle"
	description = "Generic tanker shuttle."
	suffixes = list("tanker/tanker.dmm")
	cost = INFINITY
	prefix = "mods/content/generic_shuttles/"
	area_usage_test_exempted_root_areas = list(/area/tanker)
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tanker)
	template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

/obj/effect/overmap/visitable/ship/landable/tanker
	name = "Tanker"
	desc = "Sensors detect an Astor class medium-haul gas tanker."
	shuttle = "Tanker"
	fore_dir = WEST
	max_speed = 1/(10 SECOND)
	sector_flags = OVERMAP_SECTOR_KNOWN
	use_mapped_z_levels = TRUE

/datum/shuttle/autodock/overmap/tanker
	name = "Tanker"
	warmup_time = 40
	fuel_consumption = 2
	current_location = "nav_tanker"
	dock_target = "tanker_dock"
	defer_initialisation = TRUE
	shuttle_area = /area/tanker

/obj/effect/shuttle_landmark/ship/tanker
	landmark_tag = "nav_tanker"

/area/tanker
	name = "Tanker"
	icon_state = "yellow"