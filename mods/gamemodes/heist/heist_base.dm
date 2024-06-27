/datum/map_template/ruin/antag_spawn/heist
	name = "Heist Base"
	prefix = null
	mappaths = list(
		"mods/gamemodes/heist/heist_base.dmm"
	)
	modify_tag_vars = FALSE
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/skipjack)
	apc_test_exempt_areas = list(
		/area/map_template/skipjack_station = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/syndicate_mothership/raider_base = NO_SCRUBBER|NO_VENT|NO_APC
	)
