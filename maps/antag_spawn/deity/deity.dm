/datum/map_template/ruin/antag_spawn/deity
	name = "Deity Base"
	id = "deity_spawn"
	suffixes = list("deity/deity_base.dmm")
	apc_test_exempt_areas = list(
		/area/map_template/deity_spawn = NO_SCRUBBER|NO_VENT|NO_APC
	)

/area/map_template/deity_spawn
	name = "\improper Deity Spawn"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0