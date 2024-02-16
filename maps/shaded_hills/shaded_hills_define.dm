/datum/map/shaded_hills
	name          = "shaded_hills"
	full_name     = "Shaded Hills"
	path          = "shaded_hills"
	station_name  = "Shaded Hills"
	station_short = "Shaded Hills"
	dock_name     = "Shaded Heights"
	boss_name     = "The Elder Council"
	boss_short    = "Elders"
	company_name  = "Whispers from the Deep"
	company_short = "The Deep"
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
