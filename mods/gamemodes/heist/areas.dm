//Areas
/area/map_template/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0
	req_access = list(access_raider)

/area/map_template/skipjack_station/start
	name = "\improper Skipjack"
	icon_state = "yellow"
	req_access = list(access_raider)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/map_template/syndicate_mothership/raider_base
	name = "\improper Raider Base"
	requires_power = 0
	dynamic_lighting = FALSE
	req_access = list(access_raider)