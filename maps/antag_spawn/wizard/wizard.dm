/datum/map_template/ruin/antag_spawn/wizard
	name = "Wizard Base"
	id = "wizard_spawn"
	suffixes = list("wizard/wizard_base.dmm")
	apc_test_exempt_areas = list(
		/area/map_template/wizard_station = NO_SCRUBBER|NO_VENT|NO_APC
	)

/area/map_template/wizard_station
	name = "\improper Wizard's Den"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	req_access = list(access_syndicate)
