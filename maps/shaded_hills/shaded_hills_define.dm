/datum/map/shaded_hills
	name          = "shaded_hills"
	full_name     = "Shaded Hills"
	path          = "shaded_hills"
	station_name  = "shaded hills"
	station_short = "shaded hills"
	dock_name     = "shaded heights"
	boss_name     = "the Elder Council"
	boss_short    = "Elders"
	company_name  = "whispers from the Deep"
	company_short = "the Deep"
	system_name   = "Outward Lands"

	default_species = SPECIES_KOBALOI
	default_spawn   = /decl/spawnpoint/arrivals
	allowed_latejoin_spawns = list(
		/decl/spawnpoint/arrivals
	)

	loadout_categories = list(
		/decl/loadout_category/fantasy/clothing,
		/decl/loadout_category/fantasy/utility
	)

	survival_box_choices = list()

/datum/map/shaded_hills/get_map_info()
	return "You're in the <b>[station_name]</b> of the [system_name], nestled between the mountains and the river. On all sides, you are surrounded by untamed wilds. \
	Far from the control of [boss_name], you are free to carve forward a path to survival for yourself and your comrades however you wish. Strike the earth!"