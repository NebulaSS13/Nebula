/area/test_area/general
	name = "\improper Test Area - General"
	icon_state = "blue"

/area/test_area/west
	name = "\improper Test Area - West Side"
	icon_state = "west"

/area/test_area/east
	name = "\improper Test Area - East Side"
	icon_state = "east"

/area/test_area/powered_non_dynamic_lighting
	name = "\improper Test Area - Powered - Non-Dynamic Lighting"
	icon_state = "green"
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/test_area/requires_power_non_dynamic_lighting
	name = "\improper Test Area - Requires Power - Non-Dynamic Lighting"
	icon_state = "red"
	requires_power = TRUE
	dynamic_lighting = FALSE

/area/test_area/powered_dynamic_lighting
	name = "\improper Test Area - Powered - Dynamic Lighting"
	icon_state = "yellow"
	requires_power = FALSE
	dynamic_lighting = TRUE

/area/test_area/requires_power_dynamic_lighting
	name = "\improper Test Area - Requires Power - Dynamic Lighting"
	icon_state = "purple"
	requires_power = TRUE
	dynamic_lighting = TRUE

/area/test_area/edge_of_map
	name = "\improper Test Area - Edge of Map - Only map space turfs here"
